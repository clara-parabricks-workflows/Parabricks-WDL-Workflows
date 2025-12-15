version 1.2
# Copyright 2025 NVIDIA CORPORATION & AFFILIATES

task haplotypecaller {

    input {
        File bam
        BwaIndex bwaIndex
        Array[File]? interval_file
        Array[File]? known_sites
        Array[String]? args
        Int memory
        Int num_gpus
        Int num_cpus
        String container
    }

    String prefix = "test"

    String interval_file_command = if defined(interval_file) then
        sep(" ", prefix("--interval-file ", select_first([interval_file, []])))
        else ""

    String known_sites_command = if defined(known_sites) then
        sep(" ", prefix("--knownSites ", select_first([known_sites, []])))
        else ""

    command <<< 
        set -e

        pbrun \
            haplotypecaller \
            --ref ~{bwaIndex.fastaFile} \
            --in-bam ~{bam} \
            --out-variants "~{prefix}.vcf" \
            ~{interval_file_command} \
            ~{known_sites_command} \
            --num-gpus ~{num_gpus} \
            ~{sep(" ", select_first([args, []]))}
    >>>

    output {
        File vcf = "${prefix}.vcf"
    }

    requirements {
        docker: container
        cpu: num_cpus
        memory: memory
        gpu: true
    }

    hints {
        gpu: num_gpus
    }

    meta {
        author: "Gary Burnett (gburnett@nvidia.com)"
        description: "NVIDIA Parabricks GPU accelerated HaplotypeCaller"
    }

    parameter_meta {
        # inputs
        bam: "The input BAM file"
        bwaIndex: "Reference genome FASTA file"
        interval_file: "Optional interval file for targeted regions (can be used multiple times)"
        known_sites: "Optional array of known variant sites for BQSR (can be used multiple times)"
        args: "Optional additional arguments for pbrun"
        memory: "Memory in GB"
        num_gpus: "Number of GPUs to use"
        num_cpus: "Number of CPU threads"
        container: "Container image URI"

        # outputs
        vcf: "VCF file produced by HaplotypeCaller"
    }

}

struct BwaIndex {
    File fastaFile
    Array[File] indexFiles
}

workflow parabricks_haplotypecaller {

    input {
        File bam
        BwaIndex bwaIndex
        Array[File]? interval_file
        Array[File]? known_sites
        Array[String]? args
        Int memory
        Int num_gpus
        Int num_cpus
        String container
    }

    call haplotypecaller {
        bam = bam,
        bwaIndex = bwaIndex,
        interval_file = interval_file,
        known_sites = known_sites,
        args = args,
        memory = memory,
        num_gpus = num_gpus,
        num_cpus = num_cpus,
        container = container
    }

    output {
        File vcf = haplotypecaller.vcf
    }

    meta {
        author: "Gary Burnett (gburnett@nvidia.com)"
        description: "NVIDIA Parabricks GPU Accelerated HaplotypeCaller"
    }

    parameter_meta {
        # inputs
        bam: "The input BAM file"
        bwaIndex: "Reference genome FASTA file"
        interval_file: "Optional interval file for targeted regions (can be used multiple times)"
        known_sites: "Optional array of known variant sites for BQSR (can be used multiple times)"
        args: "Optional additional arguments for pbrun"
        memory: "Memory in GB"
        num_gpus: "Number of GPUs to use"
        num_cpus: "Number of CPU threads"
        container: "Container image URI"

        # outputs
        vcf: "VCF file produced by HaplotypeCaller"
    }

}
