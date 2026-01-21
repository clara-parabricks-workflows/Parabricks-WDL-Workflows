#!/bin/bash 

# This script downloads the data files for deepvariant into $DATA_DIR
# It resumes interrupted file downloads and doesn't download files if they already exist

DATA_DIR=../../data
REF_DIR=${DATA_DIR}/ref

mkdir -p ${DATA_DIR}
mkdir -p ${REF_DIR}

# Download bam sample
file_url="https://raw.githubusercontent.com/nf-core/test-datasets/modules/data/genomics/homo_sapiens/illumina/bam/test2.paired_end.recalibrated.sorted.bam"
curl $file_url -C - -o ${DATA_DIR}/test.bam

# Download reference 
file_url="https://raw.githubusercontent.com/nf-core/test-datasets/modules/data/genomics/homo_sapiens/genome/chr21/sequence/genome.fasta"
curl $file_url -C - -o ${REF_DIR}/genome.fasta
