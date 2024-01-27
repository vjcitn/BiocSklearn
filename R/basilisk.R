
# necessary for python module control
bsklenv <- basilisk::BasiliskEnvironment(envname="bsklenv",
    pkgname="BiocSklearn",
    packages=c("numpy==1.26.3", "scikit-learn==1.4.0", "h5py==3.6.0", "pandas==1.5.3", "joblib==1.3.2",
      "scipy==1.11.1"))

