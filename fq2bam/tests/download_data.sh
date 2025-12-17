#!/bin/bash 

# This script downloads the data files for fq2bam into $DATA_DIR
# It resumes interrupted file downloads and doesn't download files if they already exist

DATA_DIR=../../data
REF_DIR=${DATA_DIR}/ref

mkdir -p ${DATA_DIR}
mkdir -p ${REF_DIR}

# Download fastq sample
file_url="https://raw.githubusercontent.com/nf-core/test-datasets/modules/data/genomics/sarscov2/illumina/fastq/test_1.fastq.gz"
curl $file_url -C - -o ${DATA_DIR}/test.fastq.gz

# Download reference 
file_url="https://raw.githubusercontent.com/nf-core/test-datasets/modules/data/genomics/sarscov2/genome/genome.fasta"
curl $file_url -C - -o ${REF_DIR}/genome.fasta
