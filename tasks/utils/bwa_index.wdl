version 1.2
# Copyright 2025 NVIDIA CORPORATION & AFFILIATES

# Build BWA index files for a FASTA reference (baseline bwa)

task bwa_index {
    input {
        File ref_fasta
        Array[String]? args
        Int memory
        Int num_cpus
        String container
    }

    String prefix = basename(ref_fasta)

    command <<<<
        set -e

        # Use baseline bwa to build the index files
        bwa index ~{sep(" ", select_first([args, []]))} ~{ref_fasta}
    >>>>

    output {
        # BWA produces .amb, .ann, .bwt, .pac, .sa files next to the FASTA
        File amb = "${ref_fasta}.amb"
        File ann = "${ref_fasta}.ann"
        File bwt = "${ref_fasta}.bwt"
        File pac = "${ref_fasta}.pac"
        File sa  = "${ref_fasta}.sa"
        Array[File] indexFiles = [amb, ann, bwt, pac, sa]
        File fastaFile = ref_fasta
    }

    requirements {
        docker: container
        cpu: num_cpus
        memory: memory
    }

    meta { author: "Gary Burnett (gburnett@nvidia.com)" }

    parameter_meta {
        ref_fasta: "Reference FASTA file to index"
        args: "Optional additional arguments for bwa"
        memory: "Memory in GB"
        num_cpus: "Number of CPU threads"
        container: "Container image URI"
    }
}

struct BwaIndex {
    File fastaFile
    Array[File] indexFiles
}
