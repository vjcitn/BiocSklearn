#' container for sklearn objects and transforms
#' @slot transform stored as R matrix
#' @slot method string identifying method
#' @return the getTransformed method returns a matrix
#' @note In Bioc 3.11, the `object` slot is removed.  This is a consequence
#' of adoption of basilisk discipline for acquiring and using python resources,
#' which greatly increases reliability, at the expense of added complication in
#' handling python objects interactively in R.  We are working on restoring
#' this functionality but it will take time.
#' @exportClass SkDecomp
#' @export getTransformed
setClass("SkDecomp", representation(transform="ANY", method="character"))

#' constructor for SkDecomp
#' @param transform typically a numerical matrix representing a projection of the input
#' @param method character(1) arbitrary tag describing the decomposition
#' @export
SkDecomp = function(transform, method) {
  new("SkDecomp", transform=transform, method=method)
}

setMethod("show", "SkDecomp", function(object) {
  cat("SkDecomp instance, method: ", object@method, "\n")
  cat("use getTransformed() to acquire projected input.\n")
})
setGeneric("getTransformed", function(x) standardGeneric("getTransformed"))
#' @rdname SkDecomp-class
#' @aliases getTransformed
#' @param x instance of SkDecomp
#' @exportMethod getTransformed
setMethod("getTransformed", "SkDecomp", function(x) x@transform)

#' use sklearn PCA procedure
#' @importFrom basilisk basiliskStart basiliskStop basiliskRun
#' @param mat a matrix -- can be R matrix or numpy.ndarray
#' @param \dots additional parameters passed to sklearn.decomposition.PCA, for additional information use \code{py_help() on a reticulate-imported sklearn.decomposition.PCA instance.}
#' @note If no additional arguments are passed, all defaults are used.
#' @return matrix with rotation
#' @examples
#' #irloc = system.file("csv/iris.csv", package="BiocSklearn")
#' #irismat = SklearnEls()$np$genfromtxt(irloc, delimiter=',')
#' #skpi = skPCA(irismat)
#' #getTransformed(skpi)[1:5,]
#' chk = skPCA(data.matrix(iris[,1:4]))
#' chk
#' head(getTransformed(chk))
#' head(prcomp(data.matrix(iris[,1:4]))$x)
#' @export
skPCA = function(mat, ...) {
 proc = basilisk::basiliskStart(bsklenv, testload="scipy") # avoid package-specific import
 on.exit(basilisk::basiliskStop(proc))
 basilisk::basiliskRun(proc, function(mat, ...) {
     sk = reticulate::import("sklearn") 
     op <- sk$decomposition$PCA(...)
     numans = op$fit_transform(mat)
     BiocSklearn::SkDecomp(transform=numans, method="PCA") # new("SkDecomp", method="PCA", transform=numans)  # this may be too heavy -- may deprecate
   }, mat=mat, ...)
}

