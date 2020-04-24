
# necessary for python module control
bsklenv <- basilisk::BasiliskEnvironment(envname="bsklenv",
    pkgname="BiocSklearn",
    packages=c("scikit-learn==0.22.2.post1", "h5py==2.10.0"))
#    packages=c("h5py==2.10.0"))

