jacobi_gpu1 <- read.delim("~/Google Drive/10.semester/02614 HPC/Assignment 3/GIT3/poisson/jacobi_gpu1.dat", header=FALSE)
jacobi_gpu1 <- jacobi_gpu1[1:6]
jacobi_gpu2 <- read.delim("~/Google Drive/10.semester/02614 HPC/Assignment 3/GIT3/poisson/jacobi_gpu2.dat", header=FALSE)
jacobi_gpu2 <- jacobi_gpu2[1:6]
jacobi_gpu3 <- read.delim("~/Google Drive/10.semester/02614 HPC/Assignment 3/GIT3/poisson/jacobi_gpu3.dat", header=FALSE)
jacobi_gpu3 <- jacobi_gpu3[1:6]

colnames(jacobi_gpu1) <- c("N","Memory","GFlops","banwidth","totalTime","IOtime")
colnames(jacobi_gpu2) <- c("N","Memory","GFlops","banwidth","totalTime","IOtime")
colnames(jacobi_gpu3) <- c("N","Memory","GFlops","banwidth","totalTime","IOtime")
jacobi_gpu1$Type <- "jacobi_gpu1"
jacobi_gpu2$Type <- "jacobi_gpu2"
jacobi_gpu3$Type <- "jacobi_gpu3"

jacobi <- rbind(jacobi_gpu1,jacobi_gpu2,jacobi_gpu3)
jacobi$Type <- as.factor(jacobi$Type)
jacobi$Memory <- jacobi$Memory/1000

ggplot(data=jacobi, aes(x=as.factor(Memory), y=GFlops,col=Type,group=Type)) +
  geom_line()+geom_point()+labs(x="Memory(MB)", y="GFlops/s")

ggplot(data=jacobi, aes(x=Memory, y=GFlops,col=Type)) +xlim(0,25)+
  geom_line()+geom_point()+labs(x="Memory(MB)", y="GFlops/s")

ggplot(data=jacobi[which(jacobi$Type=="jacobi_gpu1"),], aes(x=Memory, y=GFlops,group=Type))+
  geom_line()+geom_point()+labs(x="Memory(MB)", y="GFlops/s")
