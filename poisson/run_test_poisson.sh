#!/bin/sh
EXPNAME="jacobi_gpu1"
#BSUB -J jacobi_gpu1
#BSUB -q hpcintrogpu
#BSUB -gpu "num=1:mode=exclusive_process:mps=yes"
#BSUB -W 24:00
#BSUB -R "span[hosts=1]"
#BSUB -R "rusage[mem=3GB]"
#BSUB -B -N
#BSUB -M 3GB

N="10 20 30 40 50 100 200 300 400 500 1000 2000 3000 4000"
LOGEXT=dat
k=5000

do echo -n " $t ";
  for n in $N
  do
  time -f "%e %U %S" ./jacobi_gpu1.gcc  $n $k >> Data/$EXPNAME.$LOGEXT
  done
done
