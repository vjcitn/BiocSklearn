
# necessary for python module control
bsklenv <- basilisk::BasiliskEnvironment(envname="bsklenv",
    pkgname="BiocSklearn",
    packages=c("pandas==0.25.1", "scikit-learn=0.22.2.post1", "h5py==2.10.0", "joblib==0.14.0",
           "numpy==1.17"))

