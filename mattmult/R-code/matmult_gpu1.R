gpu_matmult.lib <- read.table("~/Google Drive/10.semester/02614 HPC/Assignment 3/GIT3/mattmult/Data_v1/gpu_matmult.lib.dat", quote="\"", comment.char="")
gpu_matmult.gpu1 <- read.table("~/Google Drive/10.semester/02614 HPC/Assignment 3/GIT3/mattmult/Data_v1/gpu_matmult.gpu1.dat", quote="\"", comment.char="")

gpu_matmult.lib <- gpu_matmult.lib[1:2]
colnames(gpu_matmult.lib) <- c("Memory","Flops")
gpu_matmult.lib$Type <- "matmult_lib"
gpu_matmult.gpu1 <- gpu_matmult.gpu1[1:2]
colnames(gpu_matmult.gpu1) <- c("Memory","Flops")
gpu_matmult.gpu1$Type <- "matmult_gpu1"






