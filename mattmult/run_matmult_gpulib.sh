#!/bin/sh
EXPNAME="gpu_matmult"
#BSUB -J gpu_matmult
#BSUB -q hpcintrogpu
#BSUB -gpu "num=1:mode=exclusive_process:mps=yes"
#BSUB -W 24:00
#BSUB -R "span[hosts=1]"
#BSUB -R "rusage[mem=2GB]"
#BSUB -B -N
#BSUB -M 3GB

module load cuda/10.0
module load gcc/7.3.0

NMK="10 20 30 40 50 100 200 300 400 500 1000 2000 3000 4000"
#TYPE="nat lib blk knm kmn mnk mkn nkm nmk per gpulib gpu1 gpu2 gpu3 gpu4 gpu5 gpu6"
TYPE="gpulib"
LOGEXT=dat

for TTT in $TYPE
do
for values in $NMK
do
   MATMULT_COMPARE=0 ./matmult_f_v2.nvcc $TTT $values $values $values | grep -v CPU >> Data/$EXPNAME.$TTT.$LOGEXT
done
done

# time to say 'Good bye' ;-)
#
exit 0
