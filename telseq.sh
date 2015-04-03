#!/bin/bash
#PBS -l nodes=1:ppn=1
#PBS -l walltime=60:00:00
#PBS -A hpt-060-aa
#PBS -V
#PBS -N telseq

cd $working_dir

export OMP_NUM_THREADS=1
export PATH=$PATH:/sb/project/hpt-060-aa/telseq/src/Telseq

telseq -z 'TTAGGG' $file.bam -o $file.telseq_elegans.TTAGGG.txt

#telseq -z 'GTATGC' $file.bam -o $file.telseq.GTATGC.txt
#telseq -z 'GTCTAG' $file.bam -o $file.telseq.GTCTAG.txt

#telseq -z 'AGTCGT' $file.bam -o $file.telseq.AGTCGT.txt
#telseq -z 'GATCGT' $file.bam -o $file.telseq.GATCGT.txt

#telseq -z 'CTATGG' $file.bam -o $file.telseq.CTATGG.txt
#telseq -z 'GCCATT' $file.bam -o $file.telseq.GCCATT.txt

#telseq -z 'TCGGAT' $file.bam -o $file.telseq.TCGGAT.txt
#telseq -z 'TGTGAC' $file.bam -o $file.telseq.TGTGAC.txt

#telseq -z 'TTAGGC' -u $file.bam -o $file.telseq_elegans.TTAGGC.noreadgroup.txt
#telseq -z 'GTCTAG' -u $file.bam -o $file.telseq_elegans.GTCTAG.noreadgroup.txt


