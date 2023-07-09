#!/bin/bash -l
# star alignment of all samples

export PRE=/scratch1/users/vidhi.sajnani/CUTL_eclip/Data/Processed/1_mESC_MED12_wt_S1
export GENOME=/scratch1/users/vidhi.sajnani/Genome/hg38/
export ADAPT2=/scratch1/users/vidhi.sajnani/CUTL_eclip/Data/Processed/adapt2/mESC_MED12_wt_S1
export ALIGN=/scratch1/users/vidhi.sajnani/CUTL_eclip/Data/Processed/align/1_mESC_MED12_wt_S1
export DEDUP=/scratch1/users/vidhi.sajnani/CUTL_eclip/Data/Processed/dedup/mESC_MED12_wt_S1
export REP=/scratch1/users/vidhi.sajnani/Rep_Elements/hg38/
export REALIGN=/scratch1/users/vidhi.sajnani/CUTL_eclip/Data/Processed/aligned_rep/1_mESC_MED12_wt_S1

#uncomment here and mention the directory where the index for rep elements is located
#first part is to align with rep elements

for i in ../Data/Processed/adapt2/MEC1_MED12_wt_S3_L00*_R1.adapt2.fastq
do
SAMPLE=$(echo ${i} | sed "s/_R1.adapt2.fastq//")
F1=$(basename "${SAMPLE%adapt2.fastq}_rep")
echo ${SAMPLE}
echo ${F1}
echo 'L001 alignmnet starts..'  
STAR --runMode alignReads --runThreadN 16 \
--genomeDir $REP \
--readFilesIn ${i} \
${SAMPLE}_R2.adapt2.fastq \
--outSAMunmapped Within \
--outFilterMultimapNmax 30 \
--outFilterMultimapScoreRange 1 \
--outSAMattributes All \
--outSAMtype BAM Unsorted \
--outFilterType BySJout \
--outReadsUnmapped Fastx \
--outFilterScoreMin 10 \
--outSAMattrRGline ID:foo \
--alignEndsType EndToEnd \
--outFileNamePrefix $REALIGN/$F1

mv $REALIGN/$F1Unmapped.out.mate1 $REALIGN/$F1.repeat-unmapped_R1.fq
mv $REALIGN/$F1Unmapped.out.mate2 $REALIGN/$F1.repeat-unmapped_R2.fq

#done
#echo 'Done alignment'
####################################################



conda init bash
source ~/.bashrc
conda activate vi
#this part is to allign to the human genome

for i in $REALIGN/*_repUnmapped.out.mate1
do
SAMPLE=$(echo ${i} | sed "s/_repUnmapped.out.mate1//")
SAMPLE1=$(basename "${SAMPLE}_repUnmapped.out.mate2")
F1=$(basename "${SAMPLE}_repeat-unmapped.sorted.R1.fq")
F2=$(basename "${SAMPLE}_repeat-unmapped.sorted.R2.fq")
F3=$(basename "${SAMPLE}_genome")

fastq-sort --id ${i} > $REALIGN/$F1
fastq-sort --id ${SAMPLE}_repUnmapped.out.mate2 > $REALIGN/$F2


echo 'L001 alignmnet starts..1'   
STAR --runMode alignReads \
--runThreadN 32 \
--genomeDir $GENOME \
--readFilesIn ${i} \
--outSAMunmapped Within \
--outFilterScoreMin 10 \
--outFilterMultimapNmax 1 \
--outFilterMultimapScoreRange 1 \
--outStd Log \
--outFilterType BySJout \
--outSAMtype BAM Unsorted \
--outReadsUnmapped Fastx \
--outSAMattributes All \
--outFileNamePrefix $ALIGN/$F3 \
--alignEndsType EndToEnd
done
echo 'Done alignment1'

#--outFilterScoreMinOverLread 0.2 \
#--outFilterMatchNminOverLread 0.2 \

# merge aligned reads

for i in $ALIGN/*L001_genomeAligned.out.bam
do
SAMPLE1=$(echo ${i} | sed "s/_L001_genomeAligned.out.bam//")
SAMPLE=$(basename "${SAMPLE1}")
echo ${SAMPLE}_L001_genomeAligned.out.bam
#for i in $ALIGN/*_L001_geomeAligned.out.bam
#do
#SAMPLE1=$(echo ${i} | sed "s/_L001_genomeAligned.out.bam//")
#SAMPLE=$(basename "${SAMPLE1}")
#F1=$(basename "${SAMPLE1}_merged.aligned.bam")

samtools merge -@ 16 -f $PRE/${SAMPLE}_merged.aligned.bam \
$ALIGN/${SAMPLE}_L001_genomeAligned.out.bam $ALIGN/${SAMPLE}_L002_genomeAligned.out.bam $ALIGN/${SAMPLE}_L003_genomeAligned.out.bam $ALIGN/${SAMPLE}_L004_genomeAligned.out.bam

#pre-dedup: sort and index bam file, make bed file from aligned merged file ###############################


samtools sort -@ 16 $PRE/${SAMPLE}_merged.aligned.bam > $PRE/${SAMPLE}_merged.aligned.sorted.bam
samtools index $PRE/${SAMPLE}_merged.aligned.sorted.bam
#bamToBed -i $PRE/${SAMPLE}_merged.aligned.sorted.bam > $PRE/${SAMPLE}_merged.aligned.sorted.bed && \

module purge
module load py-umi-tools
module load samtools
# deduplication ########################
echo 'deduplication is started..'
echo $PRE/${SAMPLE}_merged.aligned.sorted.bam
umi_tools dedup \
--random-seed 1 \
--method unique \
-I $PRE/${SAMPLE}_merged.aligned.sorted.bam \
--output-stats=cd deduplicated \
--paired \
-S $DEDUP/${SAMPLE}_merged.dedup.bam
echo 'deduplication finished sucessfully'
done
