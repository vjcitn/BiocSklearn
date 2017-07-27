#' take a step in sklearn IncrementalPCA partial fit procedure
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
