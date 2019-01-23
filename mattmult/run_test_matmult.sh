#!/bin/sh
EXPNAME="gpu_matmult"
#BSUB -J "gpu_matmult"
#BSUB -q hpcintro
#BSUB -W 360
#BSUB -R "select[model == XeonGold6126]"
#BSUB -n 1 -R "span[hosts=1]"
#BSUB -B -N

NMK="10 20 30 40 50 100 200 300 400 500 1000 2000 3000 4000"
TYPE="nat lib blk knm kmn mnk mkn nkm nmk per gpulib gpu1 gpu2 gpu3 gpu4 gpu5 gpu6"
LOGEXT=dat
/bin/rm -f TestO3nat.$LOGEXT

for TTT in $TYPE
do
for values in $NMK
do
    ./matmult_f.nvcc $TTT $values $values $values | grep -v CPU >> Data/$EXPNAME.$TTT.$LOGEXT.dat
echo "Done with NMK: $values"
done
echo "Done with type: $TTT"
done

# time to say 'Good bye' ;-)
#
exit 0
