#!/usr/bin/env bash

cd /NGS/in

gdown https://drive.google.com/uc?id=16srlIzQuNrJJNXh6s5RZpbQh0z6VZ3re
gdown https://drive.google.com/uc?id=1TRjCNORDbO4XxdqEK_aQ2dgnSuNbO7IY
gdown https://drive.google.com/uc?id=1vBtrvLtGUUeRpyrdsY-en7grLOy-mtcQ
gdown https://drive.google.com/uc?id=1qQKA79LPxMsDihXgndi30JWx7UihWz0r


samtools view -h VTTrung1_mkdp.bam > N1.sam 
samtools view -h VTTrung2_mkdp.bam > N2.sam

sed 's/NC\_12920\.1/MT/g' N1.sam > N1_MT.sam
sed 's/NC\_12920\.1/MT/g' N2.sam > N2_MT.sam

samtools view -S -b N1_MT.sam > N1_MT.bam
samtools view -S -b N2_MT.sam > N2_MT.bam

cd ..

## THIS PART TO A NEW FILE
gatk AddOrReplaceReadGroups -I in/N1_MT.bam -O temp/N1_S1.bam -LB library -PL Illumina -PU machine -SM N1
gatk MarkDuplicates -I temp/N1_S1.bam -O temp/N1_S12.bam -M temp/N1_metricfile.txt -CREATE_INDEX true
gatk FixMateInformation -I temp/N1_S12.bam -O temp/N1_S123.bam --CREATE_INDEX true -SO coordinate --VALIDATION_STRINGENCY SILENT
gatk BaseRecalibrator -I temp/N1_S123.bam -R ref/ref.fa -O temp/N1-BQSR.table --known-sites ref/mtONLY_2022.vcf

gatk ApplyBQSR -I temp/N1_S123.bam -R ref/ref.fa -O temp/N1_S1234.bam --bqsr-recal-file temp/N1-BQSR.table

gatk HaplotypeCaller -R ref/ref.fa -I temp/N1_S1234.bam --sample-ploidy 24 --pcr-indel-model AGGRESSIVE --dbsnp ref/mtONLY_2022.vcf -O out/N1-hcall.vcf

gatk VariantFiltration -R ref/ref.fa -V out/N1-hcall.vcf -O N28-hcallfiltered.vcf --filter-expression "QD < 2.0 || MQ < 40.0 || MQRankSum < -12.5 || ReadPosRankSum < -8.0" --filter-name "my_snp_filter" 

java –jar $SNPEFF/snpEff.jar –c $SNPEFF/snpEff.confiq –v hg38 $line-hcallfiltered.vcf > $line-hcallfiltered_snpef
