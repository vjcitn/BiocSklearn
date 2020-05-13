
# necessary for python module control
bsklenv <- basilisk::BasiliskEnvironment(envname="bsklenv",
    pkgname="BiocSklearn",
    packages=c("scikit-learn==0.23.0", "h5py==2.10.0", "pandas==1.0.3"))

