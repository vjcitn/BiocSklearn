#' create a file connection to HDF5 matrix
#' @param infile a pathname to an HDF5 file
#' @param mode character(1) defaults to "r", see py_help for h5py.File
#' @param \dots unused
#' @note The result of this function must be used with basiliskRun with the
#' env argument set to bsklenv, or there is a risk of
#' inconsistent python modules being invoked.  This should only be used
#' with the persistent environment discipline of basilisk.
#' @return instance of (S3) h5py._hl.files.File
#' @examples
#' if (interactive()) {   # not clear why
#' fn = system.file("ban_6_17/assays.h5", package="BiocSklearn")
#' proc = basilisk::basiliskStart(BiocSklearn:::bsklenv)
#' basilisk::basiliskRun(proc, function(infile, mode="r") {
#'  h5py = reticulate::import("h5py") 
#'  hh = h5py$File( infile, mode=mode )
#'  cat("File reference:\n ")
#'  print(hh)
#'  cat("File attributes in python:\n ")
#'  print(head(names(hh)))
#'  cat("File keys in python:\n ")
#'  print(hh$keys())
#'  cat("HDF5 dataset in python:\n ")
#'  print(hh['assay001'])
#' }, infile=fn, mode="r")
#' basilisk::basiliskStop(proc)
#' }
#' @export
h5mat = function( infile, mode="r", ... ) {
 proc = basilisk::basiliskStart(bsklenv)
 on.exit(basilisk::basiliskStop(proc))
 basilisk::basiliskRun(proc, function(infile, ...) {
     h5py = reticulate::import("h5py") 
     h5py$File( infile, mode=mode )
     }, infile=infile, mode=mode, ...)
}

#' obtain an HDF5 dataset reference suitable for handling as numpy matrix 
#' @param filename a pathname to an HDF5 file
#' @param dsname internal name of HDF5 matrix to use, defaults to 'assay001'
#' @return instance of (S3) "h5py._hl.dataset.Dataset"
#' @note This should only be used with persistent environment discipline of basilisk.
#' Additional support is planned in Bioc 3.12.
#' @examples
#' \dontrun{
#' fn = system.file("ban_6_17/assays.h5", package="BiocSklearn")
#' ban = H5matref(fn)
#' ban
#' proc = basilisk::basiliskStart(bsklenv)
#' basilisk::basiliskRun(proc, function() {
#'  np = import("numpy", convert=FALSE) # ensure
#'  print(ban$shape)
#'  print(np$take(ban, 0:3, 0L))
#'  fullpca = skPCA(ban)
#'  dim(getTransformed(fullpca))
#'  ta = np$take
#'  })
#' basilisk::basiliskStop(proc)
#' }
#' # project samples
#' \dontrun{  # on celaya2 this code throws errors, and
#' #  I have seen
#' # .../lib/python2.7/site-packages/sklearn/decomposition/incremental_pca.py:271: RuntimeWarning: Mean of empty slice.
#' #   explained_variance[self.n_components_:].mean()
#' # .../lib/python2.7/site-packages/numpy/core/_methods.py:85: RuntimeWarning: invalid value encountered in double_scalars
#' #   ret = ret.dtype.type(ret / rcount)
#' ta(ban, 0:20, 0L)$shape
#' st = skPartialPCA_step(ta(ban, 0:20, 0L))
#' st = skPartialPCA_step(ta(ban, 21:40, 0L), obj=st)
#' st = skPartialPCA_step(ta(ban, 41:63, 0L), obj=st)
#' oo = st$transform(ban)
#' dim(oo)
#' cor(oo[,1:4], getTransformed(fullpca)[,1:4])
#' } # so blocking this part of example for now
#' @export 
H5matref = function(filename, dsname="assay001") {
 proc = basilisk::basiliskStart(bsklenv)
 on.exit(basilisk::basiliskStop(proc))
 basilisk::basiliskRun(proc, function(filename, dsname) {
  py_run_string("import h5py")
  py_run_string(paste0("f = h5py.File('", filename, "', mode='r')"))
  mref = py_run_string(paste0("g = f['", dsname, "']"))
  mref$g }, filename=filename, dsname=dsname)
}
