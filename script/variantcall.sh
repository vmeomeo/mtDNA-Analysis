#!/usr/bin/env bash

gatk AddOrReplaceReadGroups -I in/N1_MT.bam -O temp/N1_S1.bam -LB library -PL Illumina -PU machine -SM N1
gatk MarkDuplicates -I temp/N1_S1.bam -O temp/N1_S12.bam -M temp/N1_metricfile.txt -CREATE_INDEX true
gatk FixMateInformation -I temp/N1_S12.bam -O temp/N1_S123.bam --CREATE_INDEX true -SO coordinate --VALIDATION_STRINGENCY SILENT
gatk BaseRecalibrator -I temp/N1_S123.bam -R ref/ref.fa -O temp/N1-BQSR.table --known-sites ref/mtONLY_2022.vcf

gatk ApplyBQSR -I temp/N1_S123.bam -R ref/ref.fa -O temp/N1_S1234.bam --bqsr-recal-file temp/N1-BQSR.table

gatk HaplotypeCaller -R ref/ref.fa -I temp/N1_S1234.bam --sample-ploidy 24 --pcr-indel-model AGGRESSIVE --dbsnp ref/mtONLY_2022.vcf -O out/N1-hcall.vcf

gatk VariantFiltration -R ref/ref.fa -V out/N1-hcall.vcf -O out/N1-hcallfiltered.vcf --filter-expression "QD < 2.0 || MQ < 40.0 || MQRankSum < -12.5 || ReadPosRankSum < -8.0" --filter-name "my_snp_filter" 

java -jar ../snpEff/snpEff.jar -c ../snpEff/snpEff.config -v MT out/N1-hcallfiltered.vcf > out/N1-snpeff
