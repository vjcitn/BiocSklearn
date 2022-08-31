
#' use sklearn pairwise_distances procedure
#' @param mat a matrix -- can be R matrix or numpy.ndarray
#' @param \dots additional parameters passed to sklearn.metrics.pairwise_distances, for additional information use \code{py_help() on a reticulate-imported sklearn.metrics.pairwise_distances instance.}
#' @note If no additional arguments are passed, all defaults are used.
#' @return matrix with rotation
#' @examples
#' irloc = system.file("csv/iris.csv", package="BiocSklearn")
#' data(iris)
#' irismat = as.matrix(iris[,1:4]) 
#' chk1 = skPWD(irismat)
#' chk1[1:4,1:5]
#' chk2 = skPWD(irismat, metric='manhattan')
#' chk2[1:4,1:5]
#' @export
skPWD = function(mat, ...) {
 proc = basilisk::basiliskStart(bsklenv) # avoid package-specific import
 on.exit(basilisk::basiliskStop(proc))
 basilisk::basiliskRun(proc, function(mat, ...) {
     sk = reticulate::import("sklearn") 
     sk$metrics$pairwise_distances(mat, ...)
   }, mat=mat, ...)
}

