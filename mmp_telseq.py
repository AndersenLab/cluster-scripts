#!/sb/home/mzamanian/.linuxbrew/bin/python
#PBS -l nodes=1:ppn=8
#PBS -l walltime=60:00:00
#PBS -A hpt-060-aa
#PBS -V
#PBS -N mmp

import os
from coverage import *

line_num = os.environ['line']

os.system("""cd $working_dir;
cd mmp;
export OMP_NUM_THREADS=1;
export PATH=$PATH:/sb/project/hpt-060-aa/telseq/src/Telseq""")

f=open('strain_info.txt')
lines=f.readlines()
lines = [x.strip().split("\t") for x in lines]

line = lines[line_num]
strain_name = line[0].split(" ")[2]
reference = "/gs/scratch/mzamanian/NU/reference/WS245/c_elegans.PRJNA13758.WS245.genomic.fa.gz"

# Process SRA Files
for i in line[1:]:
	i06 = i[0:6]
	i09 = i[0:9]
	loc_string = "ftp://ftp-trace.ncbi.nih.gov/sra/sra-instant/reads/ByRun/sra/SRR/{i06}/{i09}/{i}.sra"
	loc_string = loc_string.format(**locals())
	print "downloading " +  loc_string.format(**locals())
	os.system("wget {loc_string}".format(**locals()))
	os.system("fastq-dump --split-files --gzip {i} ".format(i=i))
	os.system("rm {i}".format(**locals()))
	# Align
	RG = '@RG\tID:{i}\tSM:{strain_name}'.format(**locals())
	os.system(r"bwa mem -R '{RG}' -t 8 {reference} {i}_1.fastq.gz {i}_2.fastq.gz > {i}.tmp.bam".format(i=i.replace(".sra",""), RG=RG, reference=reference))
	os.system("samtools sort -T {i}.TEMP -@ 8 {i}.tmp.bam > {i}.sorted.bam && samtools index {i}.sorted.bam".format(**locals()))
	os.system("rm {i}.tmp.bam")

# Combine processed SRA Files
SRA_files = ' '.join([x.replace(".sra","") + ".sorted.bam" for x in line[1:]])
os.system("samtools merge -@ 8 {strain_name}.bam {SRA_files} && samtools index {strain_name}.bam".format(**locals()))

# Produce Coverage Statistics Here


# Run Telseq Here
#telseq -z 'AATCCG' -u $file.bam -o $file.telseq_elegans.AATCCG.noreadgroup.txt
os.system("telseq -z 'TTAGGC' -u {strain_name}.sorted.bam -o {strain_name}.telseq_elegans.TTAGGC.noreadgroup.txt")
#telseq -z 'GTCTAG' -u $file.bam -o $file.telseq_elegans.GTCTAG.noreadgroup.txt