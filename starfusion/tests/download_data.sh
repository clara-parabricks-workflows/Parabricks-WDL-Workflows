#!/bin/bash 

# This script downloads the data files for starfusion into $DATA_DIR
# It resumes interrupted file downloads and doesn't download files if they already exist

# Download data files
DATA_DIR=../../data
mkdir -p ${DATA_DIR}

base_url="https://raw.githubusercontent.com/nf-core/test-datasets/modules/data/"
file_url="genomics/homo_sapiens/genome/test_starfusion_rnaseq_1.fastq.gz"
curl $base_url$file_url -C - -o ${DATA_DIR}/test.fastq.gz

# Download reference files
REF_DIR=${DATA_DIR}/ref
mkdir -p ${REF_DIR}

base_url="https://raw.githubusercontent.com/nf-core/test-datasets/modules/data/genomics/homo_sapiens/"
file_urls=(
    "genome/minigenome.fa"
    "genome/minigenome.gtf"
    "genome/CTAT_HumanFusionLib.mini.dat.gz"
    "genome/Pfam-A.hmm.gz"
    "rnaseq/test_starfusion.annotfilterrule.pm"
)

for file_url in "${file_urls[@]}"; do
    filename=$(basename "$file_url")
    curl "$base_url$file_url" -C - -o "${REF_DIR}/$filename"
done
