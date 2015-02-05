#!/bin/bash
#PBS -l nodes=1:ppn=12
#PBS -l walltime=12:00:00
#PBS -V_ind
#PBS -N freebayes
#PBS -o logs/output.$sample.$PBS_JOBNAME.$PBS_O_JOBID
#PBS -e logs/error.$sample.$PBS_JOBNAME.$PBS_O_JOBID

#
# Inputs:
# 		- sample = sample name
#

source setup.sh

export OMP_NUM_THREADS=12

output_vcf=$vcf_dir/$sample.freebayes.vcf
complete_vcf=$vcf_dir/$sample.freebayes.vcf.gz

freebayes-parallel <(fasta_generate_regions.py $reference.fai 100000) $OMP_NUM_THREADS -f $reference ${sample}.bam > $output_vcf

# Add in contigs so file can be compressed, this is for WS245.
cat $output_vcf | \ 
awk 'NR == 3 {print $0; print "##contig=<ID=I,length=15072434>\n##contig=<ID=II,length=15279421>\n##contig=<ID=III,length=13783801>\n##contig=<ID=IV,length=17493829>\n##contig=<ID=V,length=20924180>\n##contig=<ID=X,length=17718942>\n##contig=<ID=MtDNA,length=13794>"} NR != 3 { print $0 }' | \
bcftools view -O z | $complete_vcf
bcftools index $complete_vcf

if [[ -f $complete_vcf && -f $complete_vcf.csi ]];
then
   rm $outbam
else
   echo "File $complete_vcf or $complete_vcf.csi does not exist."
fi