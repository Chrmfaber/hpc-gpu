gpu_matmult_y24.gpu4 <- read.table("~/Google Drive/10.semester/02614 HPC/Assignment 3/GIT3/mattmult/Data_v1/gpu_matmult_y24.gpu4.dat", quote="\"", comment.char="")
gpu_matmult_40.gpu4 <- read.table("~/Google Drive/10.semester/02614 HPC/Assignment 3/GIT3/mattmult/Data_v1/gpu_matmult_40.gpu4.dat", quote="\"", comment.char="")
gpu_matmult_x24.gpu4 <- read.table("~/Google Drive/10.semester/02614 HPC/Assignment 3/GIT3/mattmult/Data_v1/gpu_matmult_x24.gpu4.dat", quote="\"", comment.char="")
gpu_matmult_y8.gpu4 <- read.table("~/Google Drive/10.semester/02614 HPC/Assignment 3/GIT3/mattmult/Data_v1/gpu_matmult_y8.gpu4.dat", quote="\"", comment.char="")
gpu_matmult_x8.gpu4 <- read.table("~/Google Drive/10.semester/02614 HPC/Assignment 3/GIT3/mattmult/Data_v1/gpu_matmult_x8.gpu4.dat", quote="\"", comment.char="")


gpu_matmult_y24.gpu4 <- gpu_matmult_y24.gpu4[1:2]
gpu_matmult_40.gpu4 <- gpu_matmult_40.gpu4[1:2]
gpu_matmult_x24.gpu4 <- gpu_matmult_x24.gpu4[1:2]
gpu_matmult_y8.gpu4 <- gpu_matmult_y8.gpu4[1:2]
gpu_matmult_x8.gpu4 <- gpu_matmult_x8.gpu4[1:2]

colnames(gpu_matmult_y24.gpu4) <- c("Memory","Flops")
colnames(gpu_matmult_40.gpu4) <- c("Memory","Flops")
colnames(gpu_matmult_x24.gpu4) <- c("Memory","Flops")
colnames(gpu_matmult_y8.gpu4) <- c("Memory","Flops")
colnames(gpu_matmult_x8.gpu4) <- c("Memory","Flops")

gpu_matmult_y24.gpu4$Type <- "matmult_gpu4_x16_y24"
gpu_matmult_40.gpu4$Type <- "matmult_gpu4_x16_y16"
gpu_matmult_x24.gpu4$Type <- "matmult_gpu4_x24_y16"
gpu_matmult_y8.gpu4$Type <- "matmult_gpu4_x16_y8"
gpu_matmult_x8.gpu4$Type <- "matmult_gpu4_x8_y16"


matmult_gpu4 <- rbind(gpu_matmult_y24.gpu4,gpu_matmult_40.gpu4,gpu_matmult_x24.gpu4,gpu_matmult_y8.gpu4,gpu_matmult_x8.gpu4)
matmult_gpu4$Type <- as.factor(matmult_gpu4$Type)
matmult_gpu4$GFlops <- matmult_gpu4$Flops/1000
matmult_gpu4$MBMemory <- matmult_gpu4$Memory/1000

ggplot(data=matmult_gpu4, aes(x=MBMemory, y=GFlops,col=Type))+
  geom_line()+geom_point()+labs(x="Memory(MB)", y="GFlops/s")
