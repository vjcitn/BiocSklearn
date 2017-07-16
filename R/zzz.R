#' onLoad
#' @name onLoad
#' @rdname infrastructure
#' @aliases SklearnEls
#' @note Package installs in .GlobalEnv a list with references to numpy, pandas, h5py, and sklearn.decomposition.
#' @export SklearnEls
.onLoad = function(libname, pkgname) {
  packageStartupMessage("Setting up python infrastructure, including numpy with convert=FALSE ...")
  np <- import("numpy", delay_load=TRUE, convert=FALSE)
  pd <- import("pandas", delay_load=TRUE)
  h5py <- import("h5py", delay_load=TRUE)
  skd <- import("sklearn.decomposition", delay_load=TRUE)
  SklearnEls <<- list(np=np, pd=pd, h5py=h5py, skd=skd)
  packageStartupMessage("Done.")
}
