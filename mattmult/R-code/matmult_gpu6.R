gpu6 <- read.table("~/Google Drive/10.semester/02614 HPC/Assignment 3/GIT3/mattmult/Data/gpu6.dat", quote="\"", comment.char="")
gpu6 <-  gpu6[1:2]
colnames(gpu6) <- c("Memory","Flops")
gpu6$Type <- "matmult_gpu6"

gpu5_matmult_bs16 <- read.table("~/Google Drive/10.semester/02614 HPC/Assignment 3/GIT3/mattmult/Data_v1/gpu5_matmult_bs16.dat", quote="\"", comment.char="")
gpu5_matmult_bs16 <-  gpu5_matmult_bs16[1:12,1:2]
colnames(gpu5_matmult_bs16) <- c("Memory","Flops")
gpu5_matmult_bs16$Type <- "matmult_gpu5:16"

gpu_matmult_gpu6 <- rbind(gpu5_matmult_bs16,gpu6)

gpu_matmult_gpu6$Flops2 <- gpu_matmult_gpu6$Flops/1000
gpu_matmult_gpu6$Memory2 <- gpu_matmult_gpu6$Memory/1000
gpu_matmult_gpu6$Type <- as.factor(gpu_matmult_gpu6$Type)

ggplot(data=gpu_matmult_gpu6, aes(x=Memory2, y=Flops2,col=Type)) +
  geom_line()+geom_point()+labs(x="Memory(MB)", y="GFlops/s")
