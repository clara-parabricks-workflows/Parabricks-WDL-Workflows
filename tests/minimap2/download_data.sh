#!/bin/bash

# Download sample FASTQ for minimap2
DATA_DIR=../../data
mkdir -p ${DATA_DIR}

file_url="https://raw.githubusercontent.com/nf-core/test-datasets/modules/data/genomics/sarscov2/illumina/fastq/test_1.fastq.gz"

curl $file_url -C - -o ${DATA_DIR}/test.fastq.gz
