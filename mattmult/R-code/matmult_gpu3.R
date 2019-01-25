gpu_matmult.lib <- read.table("~/Google Drive/10.semester/02614 HPC/Assignment 3/GIT3/mattmult/Data_v1/gpu_matmult.lib_12core.dat", quote="\"", comment.char="")
gpu_matmult.gpu3_col <- read.table("~/Google Drive/10.semester/02614 HPC/Assignment 3/GIT3/mattmult/Data_v1/gpu_matmult.gpu3Col.dat", quote="\"", comment.char="")
gpu_matmult.gpu3_row <- read.table("~/Google Drive/10.semester/02614 HPC/Assignment 3/GIT3/mattmult/Data_v1/gpu_matmult.gpu3Row.dat", quote="\"", comment.char="")

gpu_matmult.lib <- gpu_matmult.lib[1:2]
colnames(gpu_matmult.lib) <- c("Memory","Flops")
gpu_matmult.lib$Type <- "matmult_lib"
gpu_matmult.gpu3_col <- gpu_matmult.gpu3_col[1:2]
colnames(gpu_matmult.gpu3_col) <- c("Memory","Flops")
gpu_matmult.gpu3_col$Type <- "matmult_gpu3_col"
gpu_matmult.gpu3_row <- gpu_matmult.gpu3_row[1:2]
colnames(gpu_matmult.gpu3_row) <- c("Memory","Flops")
gpu_matmult.gpu3_row$Type <- "matmult_gpu3_row"


gpu_matmult.gpu3_lib <- rbind(gpu_matmult.gpu3_row,gpu_matmult.gpu3_col,gpu_matmult.lib)

gpu_matmult.gpu3_lib$Type <- as.factor(gpu_matmult.gpu3_lib$Type)
gpu_matmult.gpu3_lib$Flops2 <- gpu_matmult.gpu3_lib$Flops/1000
gpu_matmult.gpu3_lib$Memory2 <- gpu_matmult.gpu3_lib$Memory/1000

ggplot(data=gpu_matmult.gpu3_lib, aes(x=Memory2, y=Flops2,col=Type)) +
  geom_line()+geom_point()+labs(x="Memory(MB)", y="GFlops/s")

ggplot(data=gpu_matmult.gpu3_lib, aes(x=Memory2, y=Flops2,col=Type)) + xlim(0,25)+
  geom_line()+geom_point()+labs(x="Memory(MB)", y="GFlops/s")
