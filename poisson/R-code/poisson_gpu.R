jacobi_gpu1 <- read.delim("~/Google Drive/10.semester/02614 HPC/Assignment 3/GIT3/poisson/jacobi_gpu1.dat", header=FALSE)
jacobi_gpu1 <- jacobi_gpu1[2:3]
jacobi_gpu2 <- read.delim("~/Google Drive/10.semester/02614 HPC/Assignment 3/GIT3/poisson/jacobi_gpu2.dat", header=FALSE)
jacobi_gpu2 <- jacobi_gpu2[2:3]
jacobi_gpu3 <- read.delim("~/Google Drive/10.semester/02614 HPC/Assignment 3/GIT3/poisson/jacobi_gpu3.dat", header=FALSE)
jacobi_gpu3 <- jacobi_gpu3[2:3]
CUP_reference <- read_csv("10.semester/02614 HPC/Assignment 3/GIT3/poisson/poisson_omp_best.s.dat",col_names = FALSE)
CUP_reference <- CUP_reference[8:9]
CUP_reference$X8 <- as.numeric(CUP_reference$X8)
CUP_reference$X9 <- as.numeric(CUP_reference$X9)

colnames(jacobi_gpu1) <- c("Memory","GFlops")
colnames(jacobi_gpu2) <- c("Memory","GFlops")
colnames(jacobi_gpu3) <- c("Memory","GFlops")
colnames(CUP_reference) <- c("GFlops","Memory")
jacobi_gpu1$Type <- "jacobi_gpu1"
jacobi_gpu2$Type <- "jacobi_gpu2"
jacobi_gpu3$Type <- "jacobi_gpu3"
CUP_reference$Type <- "CPU_reference"
CUP_reference$GFlops <- CUP_reference$GFlops/1000
CUP_reference$Memory <- jacobi_gpu2$Memory

jacobi <- rbind(jacobi_gpu1,jacobi_gpu2,jacobi_gpu3,CUP_reference)
jacobi$Type <- as.factor(jacobi$Type)
jacobi$Memory2 <- jacobi$Memory/1000

ggplot(data=jacobi, aes(x=Memory2, y=GFlops,col=Type))+
  geom_line()+geom_point()+labs(x="Memory(MB)", y="GFlops/s")

ggplot(data=jacobi, aes(x=Memory2, y=GFlops,col=Type)) +xlim(0,25000)+ylim(0,350)+
  geom_line()+geom_point()+labs(x="Memory(MB)", y="GFlops/s")

data1 <- jacobi[which(jacobi$Type=="jacobi_gpu1"),]
data2 <- jacobi[which(jacobi$Type=="CPU_reference"),]
data3 <- rbind(data1,data2)

ggplot(data=data3, aes(x=Memory2, y=GFlops,col=Type))+xlim(0,75)+ylim(0,0.1)+
  geom_line()+geom_point()+labs(x="Memory(MB)", y="GFlops/s")
