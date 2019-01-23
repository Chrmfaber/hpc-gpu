#!/bin/sh
EXPNAME="gpu_poisson"
#BSUB -J "gpu_poisson"
#BSUB -q hpcintrogpu
#BSUB -gpu "num=1:mode=exclusive_process:mps=yes"
#BSUB -W 24:00
#BSUB -R "span[hosts=1]"
#BSUB -R "rusage[mem=2GB]""
#BSUB -B -N
#BSUB -M 3GB

NMK="10 20 30 40 50 100 200 300 400 500 1000 2000 3000 4000"
meth="g"
LOGEXT=dat

k=5000
eps=0.0000000001
#th="1 2 4 8 16 24"
th="1"
for t in $th;
do echo -n " $t ";
  for n in $N
  do
  OMP_NUM_THREADS=$t time -f "%e %U %S" ./poisson.gcc $meth $n $k $eps >> Data/$EXPNAME.$meth.$LOGEXT
  done
done
