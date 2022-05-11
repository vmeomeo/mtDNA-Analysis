#!/usr/bin/env bash

cd ..
mkdir MGS
cd NGS
mkdir in
mkdir out
mkdir temp
mkdir ref

cd ref
wget "http://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nucleotide&id=NC_012920.1&rettype=fasta" -O ref.fa
wget "http://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/ALL.chrMT.phase3_callmom-v0_4.20130502.genotypes.vcf.gz"
gzip -dk ALL.chrMT.phase3_callmom-v0_4.20130502.genotypes.vcf.gz
mv ALL.chrMT.phase3_callmom-v0_4.20130502.genotypes.vcf mtONLY_2022.vcf
samtools faidx ref.fa
bwa index -a bwtsw ref.fa
gatk CreateSequenceDictionary -R ref.fa

gatk IndexFeatureFile -I mtONLY_2022.vcf

cd ..
wget https://github.com/broadinstitute/picard/releases/download/2.27.1/picard.jar

