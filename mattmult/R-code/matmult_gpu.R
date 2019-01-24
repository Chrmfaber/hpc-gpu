library(ggplot2)
gpu_matmult.gpulib <- read.table("~/Google Drive/10.semester/02614 HPC/Assignment 3/GIT3/mattmult/Data_v1/gpu_matmult.gpulib.dat", quote="\"", comment.char="")
gpu_matmult.lib <- read.table("~/Google Drive/10.semester/02614 HPC/Assignment 3/GIT3/mattmult/Data_v2/gpu_matmult.lib_v2.dat", quote="\"", comment.char="")
gpu_matmult.gpu1 <- read.table("~/Google Drive/10.semester/02614 HPC/Assignment 3/GIT3/mattmult/Data_v1/gpu_matmult.gpu1.dat", quote="\"", comment.char="")
gpu_matmult.gpu2 <- read.table("~/Google Drive/10.semester/02614 HPC/Assignment 3/GIT3/mattmult/Data_v1/gpu_matmult.gpu2.dat", quote="\"", comment.char="")
gpu_matmult.gpu3_col <- read.table("~/Google Drive/10.semester/02614 HPC/Assignment 3/GIT3/mattmult/Data_v1/gpu_matmult.gpu3Col.dat", quote="\"", comment.char="")
gpu_matmult.gpu3_row <- read.table("~/Google Drive/10.semester/02614 HPC/Assignment 3/GIT3/mattmult/Data_v1/gpu_matmult.gpu3Row.dat", quote="\"", comment.char="")
gpu_matmult.gpu4_col <- read.table("~/Google Drive/10.semester/02614 HPC/Assignment 3/GIT3/mattmult/Data_v1/gpu_matmult.gpu4Col.dat", quote="\"", comment.char="")
gpu_matmult.gpu4_row <- read.table("~/Google Drive/10.semester/02614 HPC/Assignment 3/GIT3/mattmult/Data_v1/gpu_matmult.gpu4Row.dat", quote="\"", comment.char="")
gpu_matmult_gpu5_bs16 <- read.table("~/Google Drive/10.semester/02614 HPC/Assignment 3/GIT3/mattmult/Data_v1/gpu5_matmult_bs16.dat", quote="\"", comment.char="")

gpu_matmult.gpulib <- gpu_matmult.gpulib[1:2]
colnames(gpu_matmult.gpulib) <- c("Memory","Flops")
gpu_matmult.gpulib$Type <- "matmult_gpulib"
gpu_matmult.lib <- gpu_matmult.lib[1:2]
colnames(gpu_matmult.lib) <- c("Memory","Flops")
gpu_matmult.lib$Type <- "matmult_lib"
gpu_matmult.gpu1 <- gpu_matmult.gpu1[1:2]
colnames(gpu_matmult.gpu1) <- c("Memory","Flops")
gpu_matmult.gpu1$Type <- "matmult_gpu1"
gpu_matmult.gpu2 <- gpu_matmult.gpu2[1:2]
colnames(gpu_matmult.gpu2) <- c("Memory","Flops")
gpu_matmult.gpu2$Type <- "matmult_gpu2"
gpu_matmult.gpu3_col <- gpu_matmult.gpu3_col[1:2]
colnames(gpu_matmult.gpu3_col) <- c("Memory","Flops")
gpu_matmult.gpu3_col$Type <- "matmult_gpu3_col"
gpu_matmult.gpu3_row <- gpu_matmult.gpu3_row[1:2]
colnames(gpu_matmult.gpu3_row) <- c("Memory","Flops")
gpu_matmult.gpu3_row$Type <- "matmult_gpu3_row"
gpu_matmult.gpu4_col <- gpu_matmult.gpu4_col[1:2]
colnames(gpu_matmult.gpu4_col) <- c("Memory","Flops")
gpu_matmult.gpu4_col$Type <- "matmult_gpu4_col"
gpu_matmult.gpu4_row <- gpu_matmult.gpu4_row[1:2]
colnames(gpu_matmult.gpu4_row) <- c("Memory","Flops")
gpu_matmult.gpu4_row$Type <- "matmult_gpu4_row"
gpu_matmult_gpu5_bs16 <- gpu_matmult_gpu5_bs16[1:10,1:2]
colnames(gpu_matmult_gpu5_bs16) <- c("Memory","Flops")
gpu_matmult_gpu5_bs16$Type <- "matmult_gpu5:16"

gpu_matmult <- rbind(gpu_matmult.gpu1,gpu_matmult.gpu2,gpu_matmult.gpu3_row,gpu_matmult.gpu3_col,gpu_matmult.gpu4_col,gpu_matmult.gpu4_row,gpu_matmult.gpulib,gpu_matmult.lib,gpu_matmult_gpu5_bs16)

gpu_matmult$Flops <- gpu_matmult$Flops/1000
gpu_matmult$Memory <- gpu_matmult$Memory/1000
gpu_matmult$Type <- as.factor(gpu_matmult$Type)

ggplot(data=gpu_matmult, aes(x=Memory, y=Flops,col=Type)) +
  geom_line()+geom_point()+labs(x="Memory(MB)", y="GFlops/s")

ggplot(data=gpu_matmult, aes(x=Memory, y=Flops,col=Type)) + ylim(0,0.16)+xlim(0,0.03)+
  geom_line()+geom_point()+labs(x="Memory(MB)", y="GFlops/s")

ggplot(data=gpu_matmult, aes(x=Memory, y=Flops,col=Type)) + ylim(0,65)+xlim(0,2.2)+
  geom_line()+geom_point()+labs(x="Memory(MB)", y="GFlops/s")
