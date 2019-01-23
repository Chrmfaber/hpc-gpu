#!/bin/bash
EXPNAME="gpu_poisson"
#BSUB -J "gpu_poisson"
#BSUB -q hpcintro
#BSUB -W 360
#BSUB -R "select[model == XeonGold6126]"
#BSUB -n 1 -R "span[hosts=1]"
#BSUB -B -N

NMK="10 20 30 40 50 100 200 300 400 500 1000 2000 3000 4000"
meth="g"

k=5000
eps=0.0000000001
#th="1 2 4 8 16 24"
th="1"
for t in $th;
do echo -n " $t ";
  for n in $N
  do
  OMP_NUM_THREADS=$t time -f "%e %U %S" ./poisson.gcc $meth $n $k $eps >> Data/$EXPNAME.$meth.dat;
  done
done
