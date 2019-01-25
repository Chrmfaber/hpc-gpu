gpu_matmult_16.gpu4 <- read.table("~/Google Drive/10.semester/02614 HPC/Assignment 3/GIT3/mattmult/Data_v1/gpu_matmult_16.gpu4.dat", quote="\"", comment.char="")
gpu_matmult_24.gpu4 <- read.table("~/Google Drive/10.semester/02614 HPC/Assignment 3/GIT3/mattmult/Data_v1/gpu_matmult_24.gpu4.dat", quote="\"", comment.char="")
gpu_matmult_32.gpu4 <- read.table("~/Google Drive/10.semester/02614 HPC/Assignment 3/GIT3/mattmult/Data_v1/gpu_matmult_32.gpu4.dat", quote="\"", comment.char="")
gpu_matmult_40.gpu4<- read.table("~/Google Drive/10.semester/02614 HPC/Assignment 3/GIT3/mattmult/Data_v1/gpu_matmult_40.gpu4.dat", quote="\"", comment.char="")
gpu_matmult_48.gpu4<- read.table("~/Google Drive/10.semester/02614 HPC/Assignment 3/GIT3/mattmult/Data_v1/gpu_matmult_48.gpu4.dat", quote="\"", comment.char="")

gpu_matmult_16.gpu4 <- gpu_matmult_16.gpu4[1:2]
gpu_matmult_24.gpu4 <- gpu_matmult_24.gpu4[1:2]
gpu_matmult_32.gpu4 <- gpu_matmult_32.gpu4[1:2]
gpu_matmult_40.gpu4 <- gpu_matmult_40.gpu4[1:2]
gpu_matmult_48.gpu4 <- gpu_matmult_48.gpu4[1:2]

colnames(gpu_matmult_16.gpu4) <- c("Memory","Flops")
colnames(gpu_matmult_24.gpu4) <- c("Memory","Flops")
colnames(gpu_matmult_32.gpu4) <- c("Memory","Flops")
colnames(gpu_matmult_40.gpu4) <- c("Memory","Flops")
colnames(gpu_matmult_48.gpu4) <- c("Memory","Flops")

gpu_matmult_16.gpu4$Type <- "matmult_gpu4_16"
gpu_matmult_24.gpu4$Type <- "matmult_gpu4_24"
gpu_matmult_32.gpu4$Type <- "matmult_gpu4_32"
gpu_matmult_40.gpu4$Type <- "matmult_gpu4_40"
gpu_matmult_48.gpu4$Type <- "matmult_gpu4_48"

matmult_gpu4 <- rbind(gpu_matmult_16.gpu4,gpu_matmult_24.gpu4,gpu_matmult_32.gpu4,gpu_matmult_40.gpu4,gpu_matmult_48.gpu4)
matmult_gpu4$Type <- as.factor(matmult_gpu4$Type)
matmult_gpu4$GFlops <- matmult_gpu4$Flops/1000
matmult_gpu4$MBMemory <- matmult_gpu4$Memory/1000

ggplot(data=matmult_gpu4, aes(x=MBMemory, y=GFlops,col=Type))+
  geom_line()+geom_point()+labs(x="Memory(MB)", y="GFlops/s")

ggplot(data=matmult_gpu4, aes(x=MBMemory, y=GFlops,col=Type))+xlim(0,100)+ylim(0,800)+
  geom_line()+geom_point()+labs(x="Memory(MB)", y="GFlops/s")

##############

gpu_matmult.lib <- read.table("~/Google Drive/10.semester/02614 HPC/Assignment 3/GIT3/mattmult/Data_v1/gpu_matmult.lib_12core.dat", quote="\"", comment.char="")
gpu_matmult.gpu4_col <- read.table("~/Google Drive/10.semester/02614 HPC/Assignment 3/GIT3/mattmult/Data_v1/gpu_matmult.gpu4Col.dat", quote="\"", comment.char="")
gpu_matmult.gpu4_row <- read.table("~/Google Drive/10.semester/02614 HPC/Assignment 3/GIT3/mattmult/Data_v1/gpu_matmult.gpu4Row.dat", quote="\"", comment.char="")

gpu_matmult.lib <- gpu_matmult.lib[1:2]
colnames(gpu_matmult.lib) <- c("Memory","Flops")
gpu_matmult.lib$Type <- "matmult_lib"
gpu_matmult.gpu4_col <- gpu_matmult.gpu4_col[1:2]
colnames(gpu_matmult.gpu4_col) <- c("Memory","Flops")
gpu_matmult.gpu4_col$Type <- "matmult_gpu4_col"
gpu_matmult.gpu4_row <- gpu_matmult.gpu4_row[1:2]
colnames(gpu_matmult.gpu4_row) <- c("Memory","Flops")
gpu_matmult.gpu4_row$Type <- "matmult_gpu4_row"


gpu_matmult.gpu4_lib <- rbind(gpu_matmult.gpu4_row,gpu_matmult.gpu4_col,gpu_matmult.lib)

gpu_matmult.gpu4_lib$Type <- as.factor(gpu_matmult.gpu4_lib$Type)
gpu_matmult.gpu4_lib$Flops2 <- gpu_matmult.gpu4_lib$Flops/1000
gpu_matmult.gpu4_lib$Memory2 <- gpu_matmult.gpu4_lib$Memory/1000

ggplot(data=gpu_matmult.gpu4_lib, aes(x=Memory2, y=Flops2,col=Type)) +
  geom_line()+geom_point()+labs(x="Memory(MB)", y="GFlops/s")

ggplot(data=gpu_matmult.gpu4_lib, aes(x=Memory2, y=Flops2,col=Type)) + xlim(0,25)+ylim(0,400)+
  geom_line()+geom_point()+labs(x="Memory(MB)", y="GFlops/s")

