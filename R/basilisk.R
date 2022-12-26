
# necessary for python module control
bsklenv <- basilisk::BasiliskEnvironment(envname="bsklenv",
    pkgname="BiocSklearn",
    packages=c("numpy==1.21", "scikit-learn==1.0.2", "h5py==3.6.0", "pandas==1.3.5", "joblib==1.0.0",
      "scipy==1.4.1"))

