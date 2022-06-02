#' interface to sklearn.cluster.KMeans using basilisk discipline
#' @param mat a matrix-like datum or reference to such
#' @param \dots arguments to sklearn.cluster.KMeans
#' @return a list with cluster assignments (integers starting with zero) and
#' asserted cluster centers.
#' @note This is a demonstrative interface to the resources of sklearn.cluster.
#' In this particular interface, we are using sklearn.cluster.k_means_.KMeans.
#' There are many other possibilities in sklearn.cluster: _dbscan_inner,
#' _feature_agglomeration,
#' _hierarchical,
#' _k_means,
#' _k_means_elkan,
#' affinity_propagation_,
#' bicluster,
#' birch,
#' dbscan_,
#' hierarchical,
#' k_means_,
#' mean_shift_,
#' setup,
#' spectral.
#' @note Basilisk discipline has not been used for this function, 1 June 2022.
#' @examples
#' irloc = system.file("csv/iris.csv", package="BiocSklearn")
#' np = reticulate::import("numpy", delay_load=TRUE, convert=FALSE)
#' h5py = reticulate::import("h5py", delay_load=TRUE)
#' irismat = np$genfromtxt(irloc, delimiter=',')
#' ans = skKMeans(irismat, n_clusters=2L)
#' names(ans) # names of available result components
#' table(iris$Species, ans$labels)
#' # now use an HDF5 reference
#' irh5 = system.file("hdf5/irmat.h5", package="BiocSklearn")
#' fref = h5py$File(irh5)
#' ds = fref$`__getitem__`("quants") 
#' ans2 = skKMeans(np$array(ds)$T, n_clusters=2L) # HDF5 matrix is transposed relative to python array layout!  Is the np$array conversion unduly costly?
#' table(ans$labels, ans2$labels)
#' ans3 = skKMeans(np$array(ds)$T, 
#'    n_clusters=8L, max_iter=200L, 
#'    algorithm="full", random_state=20L)
#' dem = skKMeans(iris[,1:4], n_clusters=3L, max_iter=100L, algorithm="full",
#'    random_state=20L)
#' str(dem)
#' tab = table(iris$Species, dem$labels)
#' tab
#' plot(iris[,1], iris[,3], col=as.numeric(factor(iris$Species)))
#' points(dem$centers[,1], dem$centers[,3], pch=19, col=apply(tab,2,which.max))
#' @export
skKMeans = function(mat, ...) {
# proc = basilisk::basiliskStart(bsklenv)
# on.exit(basilisk::basiliskStop(proc))
# basilisk::basiliskRun(proc, function(mat, ...) {
   skcl = try(reticulate::import("sklearn.cluster"))
   if (inherits(skcl, "try-error")) stop("need pip install sklean")
   ans = skcl$KMeans(...)$fit(mat)
   list(labels=ans$labels_, centers=ans$cluster_centers_)
   } #, mat=mat, ...)
#}

