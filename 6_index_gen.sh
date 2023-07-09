#!/bin/bash
#SBATCH -p medium
#SBATCH -o outfile-%J
#SBATCH -t 44:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=vidhi.sajnani@mpi-dortmund.mpg.de
#SBATCH -c 64
#SBATCH --mem-per-cpu=4000
module load rev/11.06
module load STAR/2.7.3a

:'
STAR --runThreadN 64 \
--runMode genomeGenerate \
--genomeDir /scratch1/users/vidhi.sajnani/Rep_Elements/hg38 \
--genomeFastaFiles /scratch1/users/vidhi.sajnani/Rep_Elements/hg38/10090.fasta \
--genomeSuffixLengthMax 300
'
STAR --runThreadN 64 \
--runMode genomeGenerate \
--genomeDir /scratch1/users/vidhi.sajnani/Genome/mm10 \
--genomeFastaFiles /scratch1/users/vidhi.sajnani/Genome/mm10/Mus_musculus.GRCm39.dna_rm.primary_assembly.fa \
--sjdbGTFfile /scratch1/users/vidhi.sajnani/Genome/mm10/Mus_musculus.GRCm39.109.gtf \
--outFileNamePrefix human_index \
--limitGenomeGenerateRAM 168632718050 

#here change the directory to specify the fastq/fasta file and the output directory
#this step is needed for repetetive elements and the human genome fastq file
