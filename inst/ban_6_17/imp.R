
library(reticulate)
import("numpy", convert=FALSE)
py_run_string("import h5py")
py_run_string("ff = h5py.File('assays.h5')")
hh = py_run_string("gg = ff['assay001']")
hh

H5matref = function(filename, dsname="assay001") {
  py_run_string("import h5py")
  py_run_string(paste0("f = h5py.File('", filename, "')"))
  mref = py_run_string(paste0("g = f['", dsname, "']"))
  mref$g
}
