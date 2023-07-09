#!/bin/bash
#SBATCH -p medium
#SBATCH -o outfile-%J
#SBATCH -t 44:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=vidhi.sajnani@mpi-dortmund.mpg.de
#SBATCH -c 64
#SBATCH --mem-per-cpu=4000

pureclip -i  ../Data/Processed/MEC1_MED12_wt_S3_merged.aligned.sorted.bam -bai  ../Data/Processed/MEC1_MED12_wt_S3_merged.aligned.sorted.bam.bai -g ../../Genome/hg38/Homo_sapiens.GRCh38.dna.primary_assembly.fa -iv '1;2;3;' -nt 10 -o ../Data/Processed/PureCLIP.crosslink_sites_human.bed

echo 'PureCLIP done'
done
