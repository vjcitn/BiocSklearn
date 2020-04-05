# This is primary source for incremental partial PCA

biosk_chunk = function (x, chunk.size, n.chunks) 
{
    nm = sum(c(missing(chunk.size), missing(n.chunks)))
    if (nm != 1) 
        stop("exactly one of chunk.size and n.chunks may be missing")
    if (missing(chunk.size)) 
        return(split(x, sort(seq_len(length(x))%%as.integer(n.chunks)) + 
            1))
    if (missing(n.chunks)) {
        n.chunks = ceiling(length(x)/chunk.size)
        return(split(x, sort(seq_len(length(x))%%as.integer(n.chunks)) + 
            1))
    }
}

#' use basilisk discipline to perform partial (n_components) incremental (chunk.size) PCA with scikit.decomposition
#' @param mat a matrix
#' @param n_components integer(1) number of PCs to compute
#' @param chunk.size integer(1) number of rows to use each step
#' @note A good source for capabilities and examples is at the [sklearn doc site](https://scikit-learn.org/stable/modules/decomposition.html#decompositions).
#' @examples
#' lk = skIncrPartialPCA(iris[,1:4], n_components=3L)
#' lk
#' head(getTransformed(lk))
#' @export
skIncrPartialPCA = function(mat, n_components, chunk.size=10) {
 proc = basilisk::basiliskStart(bsklenv)
 on.exit(basilisk::basiliskStop(proc))
 basilisk::basiliskRun(proc, function(mat, n_components, chunk.size) {
     sk = reticulate::import("sklearn") # is another level needed -- decomposition._incremental_pca? Apr 2020
     op <- sk$decomposition$IncrementalPCA(n_components=as.integer(n_components))
     chinds = biosk_chunk(seq_len(nrow(mat)), chunk.size=chunk.size)
     for (i in 1:length(chinds)) {
        op$partial_fit(mat[chinds[[i]],])
        }
     new("SkDecomp", method="IncrPartialPCA", transform=op$transform(mat))  # this may be too heavy -- may deprecate
   }, mat=mat, n_components, chunk.size=10)
}

#' demo of HDF5 processing with incremental PCA/batch_size/fit_transform
#' @param fn character(1) path to HDF5 file
#' @param dsname character(1) name of dataset within HDF5 file, assumed to be 2-dimensional array
#' @param n_components numeric(1) passed to IncrementalPCA
#' @param chunk.size numeric(1) passed to IncrementalPCA as batch_size
#' @note Here we use IncrementalPCA$fit_transform and let python take care of chunk retrieval.
#' `skIncrPartialPCA` acquires chunks from R matrix and uses IncrementalPCA$partial_fit.
#' @examples
#' fn = system.file("hdf5/irmatt.h5", package="BiocSklearn") # 'transposed' relative to R iris
#' dem = skIncrPCA_h5(fn, n_components=3L, dsname="tquants")
#' dem
#' head(getTransformed(dem))
#' @export
skIncrPCA_h5 = function(fn, dsname="assay001", n_components, chunk.size=10L) {
 proc = basilisk::basiliskStart(bsklenv)
 on.exit(basilisk::basiliskStop(proc))
 useh5 = function(fn, dsname, n_components, chunk.size) {
     sk = reticulate::import("sklearn") # is another level needed -- decomposition._incremental_pca? Apr 2020
     h5 = reticulate::import("h5py") # 
     matref = h5$File(fn, mode="r")
     op <- sk$decomposition$IncrementalPCA(n_components=as.integer(n_components), 
         batch_size=as.integer(chunk.size))  # coercions crucial here, unrelated errors arise if not present
     op$fit_transform(matref[dsname])
     new("SkDecomp", method="IncrPartialPCA", transform=op$transform(matref[dsname]))  # this may be too heavy -- may deprecate
   }
 basilisk::basiliskRun(proc, useh5, 
    fn=fn, dsname=dsname, n_components=n_components, chunk.size=chunk.size)
}
