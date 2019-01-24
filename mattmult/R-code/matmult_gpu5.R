gpu5_matmult_bs8 <- read.table("~/Google Drive/10.semester/02614 HPC/Assignment 3/GIT3/mattmult/Data_v1/gpu5_matmult_bs8.dat", quote="\"", comment.char="")
gpu5_matmult_bs8 <-  gpu5_matmult_bs8[1:12,c(1:2)]
colnames(gpu5_matmult_bs8) <- c("Memory","Flops")
gpu5_matmult_bs8$blk <- "Block8"
gpu5_matmult_bs16 <- read.table("~/Google Drive/10.semester/02614 HPC/Assignment 3/GIT3/mattmult/Data_v1/gpu5_matmult_bs16.dat", quote="\"", comment.char="")
gpu5_matmult_bs16 <-  gpu5_matmult_bs16[1:12,1:2]
colnames(gpu5_matmult_bs16) <- c("Memory","Flops")
gpu5_matmult_bs16$blk <- "Block16"
gpu5_matmult_bs32 <- read.table("~/Google Drive/10.semester/02614 HPC/Assignment 3/GIT3/mattmult/Data_v1/gpu5_matmult_bs32.dat", quote="\"", comment.char="")
gpu5_matmult_bs32 <-  gpu5_matmult_bs32[1:12,1:2]
colnames(gpu5_matmult_bs32) <- c("Memory","Flops")
gpu5_matmult_bs32$blk <- "Block32"

gpu_matmult_gpu5 <- rbind(gpu5_matmult_bs16,gpu5_matmult_bs8,gpu5_matmult_bs32)

gpu_matmult_gpu5$Flops <- gpu_matmult_gpu5$Flops/1000
gpu_matmult_gpu5$Memory <- gpu_matmult_gpu5$Memory/1000
gpu_matmult_gpu5$blk <- as.factor(gpu_matmult_gpu5$blk)

ggplot(data=gpu_matmult_gpu5, aes(x=Memory, y=Flops,col=blk)) +
  geom_line()+geom_point()+labs(x="Memory(MB)", y="GFlops/s")
