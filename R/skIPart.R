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
#' @examples
#' lk = skIncrPartialPCA(iris[,1:4], n_components=3L)
#' lk
#' head(getTransformed(lk))
#' @export
skIncrPartialPCA = function(mat, n_components, chunk.size=10) {
 proc = basilisk::basiliskStart(bsklenv)
 on.exit(basilisk::basiliskStop(proc))
 basilisk::basiliskRun(proc, function(mat, n_components, chunk.size) {
     sk = reticulate::import("sklearn") 
     op <- sk$decomposition$IncrementalPCA(n_components=as.integer(n_components))
     chinds = biosk_chunk(seq_len(nrow(mat)), chunk.size=chunk.size)
     for (i in 1:length(chinds)) {
        op$partial_fit(mat[chinds[[i]],])
        }
     new("SkDecomp", method="IncrPartialPCA", transform=op$transform(mat))  # this may be too heavy -- may deprecate
   }, mat=mat, n_components, chunk.size=10)
}
