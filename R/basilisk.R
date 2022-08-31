
# necessary for python module control
bsklenv <- basilisk::BasiliskEnvironment(envname="bsklenv",
    pkgname="BiocSklearn",
    packages=c("python==3.8.10", "scikit-learn==1.1.0", "h5py==3.7.0", "pandas==1.4.3", "joblib==1.1.0"))

