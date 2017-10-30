
.onLoad <- function(libname, pkgname) {
  # delay load foo module (will only be loaded when accessed via $)
  packageStartupMessage("checking python library availability...")
  chk <- try(import("sklearn"))
  if (inherits(chk, "try-error")) stop("sklearn not found in python environment")
  chk <- try(import("numpy"))
  if (inherits(chk, "try-error")) stop("numpy not found in python environment")
  chk <- try(import("pandas"))
  if (inherits(chk, "try-error")) stop("pandas not found in python environment")
  packageStartupMessage("done.")
}
