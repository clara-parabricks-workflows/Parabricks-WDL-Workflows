#!/bin/bash 

# This script downloads the reference files into $REF_DIR
# It resumes interrupted file downloads and doesn't download files if they already exist

REF_DIR=../data/ref
mkdir -p ${REF_DIR}

file_url="https://raw.githubusercontent.com/nf-core/test-datasets/modules/data/genomics/sarscov2/genome/genome.fasta"

curl $file_url -C - -O --output-dir ${REF_DIR}