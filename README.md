# eCLIP-Analysis
A list of all tools which were utilised in the analysis of eCLIP-seq data.

## Create the following folders:
-Genome
-Rep-Elements
-Data
-Scripts

## Create the following folders under *Data* to store the input and output files:
1. Raw
2. Processed
   * adapt1
   * adapt2
   * align
   * aligned-rep
   * dedup
   * genome

## For Running Jobs
Use the Jobs_sub.sh script to run your jobs (change the name of the job to be run in the file itself) using `sbatch Jobs_sub.sh` 
## UMI
Input: .gz input files in raw data folder <br>
Output: .umi.fastq files in umi folder<be>
<br>
First, we unzip the raw input files. Then we use umi-tools to deal with Unique Molecular Identifiers (UMIs)/Random Molecular Tags (RMTs) and single cell RNA-Seq cell barcodes.

## CutAdapt
Input: .umi.fastq files in umi folder<br> 
Output: .adapt1.fastq un adapt1 folder<be>
<br>
Input: .adapt1.fastq in adapt1 folder<br>
Output: .adapt2.fastq in adapt2 folder<br>
<br>
Cutadapt finds and removes adapter sequences, primers, poly-A tails, and other types of unwanted sequences from your high-throughput sequencing reads. We cut the adaptors twice.
## Indexing
Download the .fa.gz file using wget of the Genome of your respective organism into the Genome folder. Also, download the .gtf.gz file in the same manner into the Genome folder. (For example: http://www.ensembl.org/Mus_musculus/Info/Index) Unzip the files using gunzip. Download the repetitive elements file of your respective organism in the same way from msRepDB(https://msrepdb.cbrc.kaust.edu.sa/pages/msRepDB/index.html) into the Rep-Elements folder.<br>
Use these files in the 6_index_gen.sh script to generate index for Genome and Replicated Elements.

## Star Alignment
Input: .adapt2.fastq in adapt2 folder<br>
Output: files in align, aligned-rep and dedup folders along with bam, bai files in Processed<br>
<br>
First part of aligning is with the Replicated Elements. For the second part, aligning with Genome, we require a conda environment. Then, module load fastq-tools. To determine where on the human genome our reads originated from, we will align our reads to the reference genome using STAR (Spliced Transcripts Alignment to a Reference). STAR is an aligner designed to specifically address many of the challenges of RNA-seq data mapping using a strategy to account for spliced alignments.

## PureCLIP- Peak Analysis
Input: .bam and .bai files in Processed folder<br>
Output: .bed file in Processed<br>
<br>
For bioconda: <br>
conda config --add channels defaults<br>
conda config --add channels bioconda<br>
conda config --add channels conda-forge<br>
conda config --set channel_priority strict<br>
Then, conda install pureclip. Change your file names in the PureLCLIP script and run it to obtain the bed file. 
You can run the following command for the .bed file used in RCAS:<br>
`awk 'BEGIN{FS=OFS="\t"} {print $1, ($2-49), ($3+49), $4, $5, $6}' PureCLIP.crosslink_sites_human.bed > PureCLIP.crosslink_sites_for_RCAS_human.bed`<br>
You can run the following command for the annotated .bed file with gene names (requires gene_loc bed file) used in Enrichment Analysis:<br>
`awk 'BEGIN{FS=OFS="\t"} {print $1, ($2-49), ($3+49), $4, $5, $6}' PureCLIP.crosslink_sites_mus_musculus.bed | bedtools intersect -a - -b ../../../../Genome/gene_loc_file.bed -wa -wb | cut -f1,2,3,4,10,11 | sed "s/;//g" > annotated3.bed`<br>
Use the following code to check the qulity of your read:<br>
`samtools flagstat -@ 12 1_mESC_MED12_wt_S1/mESC_MED12_wt_S1_merged.aligned.sorted.bam`<br>

## Meme- Motifs
Use https://meme-suite.org/meme/doc/install.html?man_type=web#quick_src to install Meme and then run the following command to convert the fasta genome file to bed file<be>
`module load bedtools`<br>
`bedtools getfasta -fi ../../../Genome/mm10/Mus_musculus.GRCm39.dna_rm.primary_assembly.fa -fo mESC_MED12_mut_D_S2.fasta -bed ../../Data/Processed/2_mESC_MED12_mut_D_S2/PureCLIP.crosslink_sites_for_RCAS_mus.bed` <br>
Then run the following code to obtain motifs:<br>
`~/meme/bin/meme -dna -minw 5 -maxw 15 -oc meme2 mESC_MED12_mut_D_S2.fasta -nmotifs 10`









