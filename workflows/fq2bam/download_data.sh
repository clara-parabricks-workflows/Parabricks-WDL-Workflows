#!/bin/bash 

# This script downloads the data files for fq2bam into $DATA_DIR
# It resumes interrupted file downloads and doesn't download files if they already exist

DATA_DIR=../../data
mkdir -p ${DATA_DIR}

file_url="https://github.com/nf-core/test-datasets/raw/methylseq/testdata/SRR389222_sub1.fastq.gz"

curl $file_url -C - -O --output-dir ${DATA_DIR}
