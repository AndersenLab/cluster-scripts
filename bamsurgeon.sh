#!/bin/bash
#PBS -l nodes=1:ppn=12
#PBS -l walltime=12:00:00
#PBS -V
#PBS -N bamsurgeon

#
# Inputs:
# 		- n = varset number
#

source setup.sh

export OMP_NUM_THREADS=12

varset=$varset_dir/varset${n}.bed
bamfile=N2.bam
outbam=N2_test_set_${n}.bam
sorted_bam=${outbam/.bam/}.sorted.bam

python $addsnv -v $varset -r $reference -f $bamfile -o $outbam -p $OMP_NUM_THREADS --aligner mem --samtofastq $samtofastq --tmpdir ${n} 

samtools sort -@ $OMP_NUM_THREADS -T ${n}.sorting -O bam $outbam > $sorted_bam
samtools index $sorted_bam

if [[ -f $sorted_bam && -f $sorted_bam.bai ]];
then
   rm $outbam
else
   echo "File $sorted_bam or $sorted_bam.bai does not exist."
fi