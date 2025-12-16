version 1.2
# Copyright 2025 NVIDIA CORPORATION & AFFILIATES

# Task: Run samtools faidx on a FASTA reference (creates .fai)

task samtools_faidx {
    input {
        File ref_fasta
        Array[String]? args = []
        Int memory = 8
        Int num_cpus = 4
        String container = "biocontainers/samtools:v1.9-4-deb_cv1"
    }

    command <<<
        set -e

        samtools faidx ~{ref_fasta} ~{sep(" ", select_first([args, []]))}
    >>>

    output {
        File fai = "${ref_fasta}.fai"
    }

    requirements {
        docker: container
        cpu: num_cpus
        memory: memory
    }

    meta { 
        author: "Gary Burnett (gburnett@nvidia.com)"
        description: "Creates a FASTA index (.fai) using samtools faidx"
    }

    parameter_meta {
        ref_fasta: "Reference FASTA file to index"
        args: "Optional additional arguments to pass to samtools faidx"
        memory: "Memory in GB"
        num_cpus: "Number of CPU threads"
        container: "Container image URI"
    }
}
