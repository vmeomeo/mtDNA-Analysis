#!/usr/bin/env bash

cd ..
bwa mem NGS/raw/N1-R1.fastq.gz NGS/raw/N1-R2.fastq.gz > NGS/in/N1.sam
samtools view –S –b $SAMPLE/$line.sam > $SAMPLE/$line.bam
(mkdir bamsort) samtools sort –o bamsort/$line_sorted.bam $SAMPLE/$line.bam
samtools index ./bamsort/$line_sorted.bam
