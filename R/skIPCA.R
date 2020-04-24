#' use sklearn IncrementalPCA procedure
#' @param mat a matrix -- can be R matrix or numpy.ndarray, if the latter it
#' must be set up in a basilisk persistent environment, and that is not
#' currently demonstrated for this package.
#' @param n_components number of PCA to retrieve
#' @param batch_size number of records to use at each iteration
#' @param \dots passed to python  IncrementalPCA
#' @return matrix with rotation
#' @examples
#' dem = skIncrPCA(iris[,1:4], batch_size=25L)
#' \dontrun{
#' # this is the unsupported way
#' irloc = system.file("csv/iris.csv", package="BiocSklearn")
#' irismat = SklearnEls()$np$genfromtxt(irloc, delimiter=',')
#' ski = skIncrPCA(irismat)
#' ski25 = skIncrPCA(irismat, batch_size=25L) # non-default
#' getTransformed(ski)[1:3,]
#' getTransformed(ski25)[1:3,]
#' } # end dontrun
#' dem = skIncrPCA(iris[,1:4], batch_size=25L, n_components=2L)
#' dem
#' @export
skIncrPCA = function(mat, n_components=2L, batch_size=5L, ...) {
 proc = basilisk::basiliskStart(NULL)
 on.exit(basilisk::basiliskStop(proc))
 basilisk::basiliskRun(proc, function(mat, n_components, batch_size, ...) {
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
   if (missing(batch_size)) 
       batch_size = as.integer(min(c(nr, 5*nc)))
   sk = reticulate::import("sklearn") 
   ipc = sk$decomposition$IncrementalPCA(n_components=n_components,
       batch_size=batch_size, ...)
   new("SkDecomp", transform=ipc$fit_transform(mat), 
       method="IncrementalPCA")
  }, mat=mat, n_components=n_components, batch_size=batch_size, ... )
}


