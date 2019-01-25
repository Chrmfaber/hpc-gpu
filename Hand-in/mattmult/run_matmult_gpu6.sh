#!/bin/sh
EXPNAME="gpu6"
#BSUB -J gpu6
#BSUB -q hpcintrogpu
#BSUB -gpu "num=1:mode=exclusive_process:mps=yes"
#BSUB -W 24:00
#BSUB -R "span[hosts=1]"
#BSUB -R "rusage[mem=16GB]"
#BSUB -B -N


module load cuda/10.0
module load gcc/7.3.0

# NMK="16 20 30 40 50 100 200 300 400 500 1000 2000 3000 4000"
NMK="32 64 128 256 512 768 1024 2048 3072 4096 8192 12288"
LOGEXT=dat

for values in $NMK
do
   MATMULT_COMPARE=0  ./matmult_f.nvcc gpu6 $values $values $values | grep -v CPU >> Data/$EXPNAME.$LOGEXT
done

exit 0
