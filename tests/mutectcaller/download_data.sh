#!/bin/bash

# Download sample BAM for mutectcaller
DATA_DIR=../../data
mkdir -p ${DATA_DIR}

file_url="https://raw.githubusercontent.com/nf-core/test-datasets/modules/data/genomics/homo_sapiens/illumina/bam/test2.paired_end.recalibrated.sorted.bam"

curl $file_url -C - -o ${DATA_DIR}/test.bam
