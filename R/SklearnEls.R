#' mediate access to python modules from sklearn.decomposition
#' @import reticulate
#' @import knitr
#' @export
SklearnEls = function() {
  np <- import("numpy", delay_load=TRUE, convert=FALSE)
  pd <- import("pandas", delay_load=TRUE)
  h5py <- import("h5py", delay_load=TRUE)
  skd <- import("sklearn.decomposition", delay_load=TRUE)
  list(np=np, pd=pd, h5py=h5py, skd=skd)
}
