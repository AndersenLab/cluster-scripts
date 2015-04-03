#!/bin/bash
#PBS -l nodes=1:ppn=16
#PBS -l walltime=40:00:00
#PBS -A hpt-060-aa
#PBS -V
#PBS -N bamsurgeon

#
# Inputs:
# 		- n = varset number
#

cd $working_dir

export OMP_NUM_THREADS=16

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

# Collect stats on complete File
cd addsnv_logs_$outbam
for f in `find . -maxdepth 1 -name "*.log"`; do
	cat $f | egrep '(^snv)' >> ../bamsurgeon_varfiles/snv_log_${outbam/.bam/}.log
done;