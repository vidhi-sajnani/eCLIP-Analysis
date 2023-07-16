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
## UMI
Input: .gz input files in raw data folder <br>
Output: .umi.fastq files in umi folder<br>
First, we unzip the raw input files. Then we use umi-tools to deal with Unique Molecular Identifiers (UMIs)/Random Molecular Tags (RMTs) and single cell RNA-Seq cell barcodes.

## CutAdapt
Input: .umi.fastq files in umi folder<br> 
Output: .adapt1.fastq un adapt1 folder<be><br>
Input: .adapt1.fastq un adapt1 folder<br>
Output: .adapt2.fastq un adapt2 folder<br>
Cutadapt finds and removes adapter sequences, primers, poly-A tails, and other types of unwanted sequences from your high-throughput sequencing reads.









