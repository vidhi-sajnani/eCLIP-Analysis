#!/bin/bash
#SBATCH -p medium
#SBATCH -o outfile-%J
#SBATCH -t 32:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=vidhi.sajnani@mpi-dortmund.mpg.de
#SBATCH -c 32
#SBATCH --mem=228G

module purge
module load py-umi-tools/1.0.0
module load samtools
module load star
module load cutadapt/4.4
module load star/2.7.3a

#/scratch1/users/vidhi.sajnani/CUTL_eclip/Scripts/1_umi.sh
#/scratch1/users/vidhi.sajnani/CUTL_eclip/Scripts/2_cutadapt.sh
#/scratch1/users/vidhi.sajnani/CUTL_eclip/Scripts/6_index_gen.sh
/scratch1/users/vidhi.sajnani/CUTL_eclip/Scripts/3_align_dedup.sh


#~/Final_fastq_files/trial.sh
