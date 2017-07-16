#' use sklearn PCA procedure
#' @param mat a matrix -- can be R matrix or numpy.ndarray
#' @note all defaults are used
#' @return matrix with rotation
#' @examples
#' irloc = system.file("csv/iris.csv", package="BiocSklearn")
#' irismat = SklearnEls$np$genfromtxt(irloc, delimiter=',')
#' skPCA(irismat)[1:5,]
#' @export
skPCA = function(mat) {
 skpc = SklearnEls$skd$PCA()
 skpc$fit_transform(mat)
}
