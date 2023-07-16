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
Input: .gz input files in raw data folder
Output: .umi.fastq files in umi folder
First, we unzip the raw input files. Then we use umi-tools to deal with Unique Molecular Identifiers (UMIs)/Random Molecular Tags (RMTs) and single cell RNA-Seq cell barcodes.
