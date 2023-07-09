#!/bin/bash -l

#/scratch1/users/vidhi.sajnani/CUTL_eclip/Data/Raw
export FASTQ=/scratch1/users/vidhi.sajnani/CUTL_eclip/Data/Raw
#/scratch1/users/vidhi.sajnani/CUTL_eclip/Data/Processed/umi
export UMI=/scratch1/users/vidhi.sajnani/CUTL_eclip/Data/Processed/umi
#export ADAPT1=~/Processed/umi/Lo_R2/Adapt1
#export ADAPT2=~/Processed/umi/Lo_R2/Adapt2
#
#gunzip < $FASTQ/MOLM13_GAPDH_Lo_R2_S1_L004_R2_001.fastq.gz > $FASTQ/MOLM13_GAPDH_Lo_R2_S1_L004_R2_001.fastq && \

for f in /scratch1/users/vidhi.sajnani/CUTL_eclip/Data/Raw/*.gz; 
do
STEM=$(basename "${f}" .gz)
gunzip -c "${f}" > /scratch1/users/vidhi.sajnani/CUTL_eclip/Data/Processed/umi/${STEM}
done


echo 'umi-extract from L001 started' 

for i in /scratch1/users/vidhi.sajnani/CUTL_eclip/Data/Processed/umi/*R1_001.fastq
do
SAMPLE1=$(echo ${i} | sed "s/_R1_001.fastq//")
F1=$(basename "${SAMPLE1%fastq}_R1.umi.fastq") F2=$(basename "${SAMPLE1}_R2.umi.fastq")
echo "Start" ${i}
umi_tools extract \
--random-seed 1 \
--bc-pattern=NNNNNNNNNNNN \
--bc-pattern2=NNNNNNNNNN \
--log $UMI/L001-umi.metrics \
-I ${i} \
-S $UMI/$F1 \
--read2-in=${SAMPLE1}_R2_001.fastq \
--read2-out=$UMI/$F2
echo "end" $i
done

echo 'umi_extract finished' \
