## ----loadup--------------------------------------------------------------
library(BiocSklearn)
SklearnEls()

## ----doimp---------------------------------------------------------------
irloc = system.file("csv/iris.csv", package="BiocSklearn")
irismat = SklearnEls()$np$genfromtxt(irloc, delimiter=',')

## ----dota----------------------------------------------------------------
SklearnEls()$np$take(irismat, 0:2, 0L )

## ----dor-----------------------------------------------------------------
fullpc = prcomp(data.matrix(iris[,1:4]))$x

## ----dopc1---------------------------------------------------------------
ppca = skPCA(irismat)
ppca

## ----lk1-----------------------------------------------------------------
tx = getTransformed(ppca)
dim(tx)
head(tx)

## ----dopy----------------------------------------------------------------
pyobj(ppca)$fit_transform(irismat)[1:3,]

## ----lkconc--------------------------------------------------------------
round(cor(tx, fullpc),3)

## ----doincr--------------------------------------------------------------
ippca = skIncrPCA(irismat) #
ippcab = skIncrPCA(irismat, batch_size=25L)
round(cor(getTransformed(ippcab), fullpc),3)

## ----dopartial-----------------------------------------------------------
ta = SklearnEls()$np$take # provide slicer utility
ipc = skPartialPCA_step(ta(irismat,0:49,0L))
ipc = skPartialPCA_step(ta(irismat,50:99,0L), obj=ipc)
ipc = skPartialPCA_step(ta(irismat,100:149,0L), obj=ipc)
ipc$transform(ta(irismat,0:5,0L))
fullpc[1:5,]

