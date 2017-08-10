#' take a step in sklearn IncrementalPCA partial fit procedure
#' @importFrom methods is
#' @importFrom methods new
#' @param mat a matrix -- can be R matrix or numpy.ndarray
#' @param n_components number of PCA to retrieve
#' @param obj sklearn.decomposition.IncrementalPCA instance
#' @note if obj is missing, the process is initialized with the matrix provided
#' @return trained IncrementalPCA reference, to which 'transform' method can be applied to obtain projection for any compliant input
#' @examples
#' irloc = system.file("csv/iris.csv", package="BiocSklearn")
#' irismat = SklearnEls()$np$genfromtxt(irloc, delimiter=',')
#' ta = SklearnEls()$np$take
#' ipc = skPartialPCA_step(ta(irismat,0:49,0L))
#' ipc = skPartialPCA_step(ta(irismat,50:99,0L), obj=ipc)
#' ipc = skPartialPCA_step(ta(irismat,100:149,0L), obj=ipc)
#' head(names(ipc))
#' ipc$transform(ta(irismat,0:5,0L))
#' fullproj = ipc$transform(irismat)
#' fullpc = prcomp(data.matrix(iris[,1:4]))$x
#' round(cor(fullpc,fullproj),3)
#' @export
skPartialPCA_step = function(mat, n_components, obj) {
 if (is(mat, "matrix")) {
    nr = nrow(mat)
    nc = ncol(mat)
    }
 else if (is(mat, "numpy.ndarray")) {
    d = py_to_r(mat$shape)
    nr = d[[1]]
    nc = d[[2]]
    }
 if (missing(n_components)) n_components = as.integer(
     min(c(nc,nr)))
 if (missing(obj)) 
    obj = SklearnEls()$skd$IncrementalPCA(n_components=n_components)
 obj$partial_fit(mat)
}

#h5gen = function(rows, cols) {
#  HDF5_FILE = system.file("hdf5/tenx10kmat.h5", package="BiocSklearn")
#  t( h5read(HDF5_FILE, DSNAME, list(rows, cols)) )
#}
#
#tgm =
#  TENxMatrix("~/Research/TENEX/1M_neurons_filtered_gene_bc_matrices_h5.h5")
#
#mmgen = function(rows, cols) {
#  t(as.matrix(tgm[rows, cols]))
#}
#
submatGenerator = function(srcfun, rows, cols) {
  srcfun(rows=rows, cols=cols)
  }
#
#
#ch = chunk(SAMP_INDS, chunk.size=CHUNK_SIZE)
#
#date()

#' incremental partial PCA for projection of samples from SummarizedExperiment
#' @importFrom BBmisc chunk
#' @return python instance of \code{sklearn.decomposition.incremental_pca.IncrementalPCA}
#' @aliases skIncrPPCA,SummarizedExperiment-method
#' @note Will treat samples as records and all features (rows) as attributes, projecting
#' to an \code{n_components}-dimensional space.  Method will acquire chunk of assay data
#' and transpose before computing PCA contributions.
#' @examples
#' se1500 = loadHDF5SummarizedExperiment(
#'      system.file("hdf5/tenx_1500", package="BiocSklearn"))
#' lit = skIncrPPCA(se1500[, 1:50], chunksize=5, n_components=4)
#' round(cor(pypc <- lit$transform(dat <- t(as.matrix(assay(se1500[,1:50]))))),3)
#' rpc = prcomp(dat)
#' round(cor(rpc$x[,1:4], pypc), 3)
#' @exportMethod skIncrPPCA
setGeneric("skIncrPPCA", function(se, chunksize, n_components, assayind=1, ...) 
    standardGeneric("skIncrPPCA"))
setMethod("skIncrPPCA", "SummarizedExperiment", 
   function(se, chunksize, n_components, assayind=1, ...) {
   stopifnot(assayind==1)
   n_components = as.integer(n_components)
   chunksize = as.integer(chunksize)
   rowvec = 1:nrow(se)
   colvec = 1:ncol(se)
   chs = chunk(colvec, chunk.size=chunksize)
   matgen = function(rows, cols) t(as.matrix(assay(se[rows, cols]))) # assayind handling?
   cur = skPartialPCA_step(
      submatGenerator( matgen, rowvec, chs[[1]] ), n_components )
   for (i in 2:length(chs)) { 
      cat(i)
      cur = skPartialPCA_step(
        submatGenerator( matgen, rowvec, chs[[i]]), n_components, cur)
      }
   cur
})
