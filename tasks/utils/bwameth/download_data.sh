#!/bin/bash

# This script downloads the reference FASTA for bwameth into $DATA_DIR
# It resumes interrupted file downloads and doesn't download files if they already exist

DATA_DIR=../../data/ref
mkdir -p ${DATA_DIR}

file_url="https://storage.googleapis.com/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.fasta"

curl $file_url -C - -o ${DATA_DIR}/Homo_sapiens_assembly38.fasta
