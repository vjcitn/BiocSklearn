#' mediate access to python modules from sklearn.decomposition
#' @import reticulate
#' @import knitr
#' @note Returns a list with elements np (numpy), pd (pandas), h5py (h5py),
#' skd (sklearn.decomposition), joblib (sklearn.externals.joblib), each
#' referring to python modules.
#' @examples
#' els = SklearnEls()
#' names(els$skd) # slow at first
#' # try py_help(els$skd$PCA) # etc.
#' @return list of (S3) "python.builtin.module"
#' @export
SklearnEls = function() {
  np <- import("numpy", delay_load=TRUE, convert=FALSE)
  pd <- import("pandas", delay_load=TRUE)
  h5py <- import("h5py", delay_load=TRUE)
  skd <- import("sklearn.decomposition", delay_load=TRUE)
  skcl <- import("sklearn.cluster", delay_load=TRUE)
  joblib <- import("sklearn.externals.joblib", delay_load=TRUE)
  list(np=np, pd=pd, h5py=h5py, skd=skd, skcl=skcl, joblib=joblib)
}
