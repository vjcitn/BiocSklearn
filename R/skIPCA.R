#' use sklearn IncrementalPCA procedure
#' @param mat a matrix -- can be R matrix or numpy.ndarray
#' @param n_components number of PCA to retrieve
#' @return matrix with rotation
#' @examples
#' irloc = system.file("csv/iris.csv", package="BiocSklearn")
#' irismat = SklearnEls$np$genfromtxt(irloc, delimiter=',')
#' skIncrPCA(irismat)[1:5,]
#' skIncrPCA(irismat, batch_size=25L)[1:5,] # slightly different
#' @export
skIncrPCA = function(mat, n_components, batch_size) {
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
 skpc = SklearnEls$skd$IncrementalPCA(n_components=n_components, 
     batch_size=batch_size)
 skpc$fit_transform(mat)
}
