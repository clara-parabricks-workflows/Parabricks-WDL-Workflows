#!/bin/bash 

# This script downloads the reference files into $REF_DIR
# It resumes interrupted file downloads and doesn't download files if they already exist

REF_DIR=../data/ref
mkdir -p ${REF_DIR}

ref_files="{fasta}"
file_url="https://storage.googleapis.com/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.${ref_files}"

curl $file_url -C - -O --output-dir ${REF_DIR}