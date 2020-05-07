#' mediate access to python modules from sklearn.decomposition
#' @import reticulate
#' @import knitr
#' @import Rcpp
#' @note Deprecated.  Previously returned a list with elements np (numpy), pd (pandas), h5py (h5py),
#' skd (sklearn.decomposition), joblib (sklearn.externals.joblib), each
#' referring to python modules.  This was done directly with reticulate, but basilisk package
#' discipline is more reliable.
#' @examples
#' \dontrun{
#' els = SklearnEls()
#' names(els$skd) # slow at first
#' # try py_help(els$skd$PCA) # etc.
#' }
#' @return list of (S3) "python.builtin.module"
SklearnEls = function() {
  .Deprecated("basilisk::basiliskStart", "BiocSklearn", "basilisk mediates")
  np <- import("numpy", delay_load=TRUE, convert=FALSE)
  pd <- import("pandas", delay_load=TRUE)
  h5py <- import("h5py", delay_load=TRUE)
  skd <- import("sklearn.decomposition", delay_load=TRUE)
  skcl <- import("sklearn.cluster", delay_load=TRUE)
  joblib <- import("sklearn.externals.joblib", delay_load=TRUE)
  list(np=np, pd=pd, h5py=h5py, skd=skd, skcl=skcl, joblib=joblib)
}
