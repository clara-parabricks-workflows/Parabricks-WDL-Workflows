version 1.2
# Copyright 2025 NVIDIA CORPORATION & AFFILIATES

task fq2bam {
    input {
        Array[File] reads
        BwaIndex bwaIndex
        Array[File]? interval_file
        Array[File]? known_sites
        String output_fmt
        Boolean single_ended
        Array[String]? args
        Int memory
        Int num_gpus
        Int num_cpus
        String container
    }

    String prefix = "test"
    String extension_bam = output_fmt
    String extension_bam_index = if output_fmt == "cram" then "crai" else "bai"
    
    String known_sites_command = if defined(known_sites) then
        sep(" ", prefix("--knownSites ", select_first([known_sites, []])))
        else ""

    String known_sites_output_cmd = if defined(known_sites) then
        "--out-recal-file ${prefix}.table"
        else ""
    
    String interval_file_command = if defined(interval_file) then
        sep(" ", prefix("--interval-file ", select_first([interval_file, []])))
        else ""

    String in_fq_command = if single_ended then 
        sep(" ", prefix("--in-se-fq ", reads))
        else "--in-fq ${sep(" ", reads)}"

    command <<<
        set -e

        pbrun \
            fq2bam \
            --ref ~{bwaIndex.fastaFile} \
            ~{in_fq_command} \
            --out-bam "~{prefix}.~{extension_bam}" \
            ~{known_sites_command} \
            ~{known_sites_output_cmd} \
            ~{interval_file_command} \
            --num-gpus ~{num_gpus} \
            --bwa-cpu-thread-pool ~{num_cpus} \
            --monitor-usage \
            ~{sep(" ", select_first([args, []]))}
        >>>

    output {
        File bam = "${prefix}.${extension_bam}"
        File bai = "${prefix}.${extension_bam}.${extension_bam_index}"
        File? bqsr_table = if defined(known_sites) then "${prefix}.table" else None
        File? qc_metrics = if contains(select_first([args,[]]), "--out-qc-metrics-dir") then "${prefix}_qc_metrics" else None
        File? duplicate_metrics = if contains(select_first([args,[]]), "--out-duplicate-metrics") then "${prefix}.duplicate-metrics.txt" else None
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
        description: "Converts FASTQ files to BAM/CRAM format using NVIDIA Parabricks fq2bam"
    }

    parameter_meta {
        # inputs
        reads: {description: "Array of FASTQ files to align", category: "required"}
        bwaIndex: "Reference genome FASTA file"
        interval_file: "Optional interval file for targeted regions (can be used multiple times)"
        known_sites: "Optional array of known variant sites for BQSR (can be used multiple times)"
        output_fmt: "Output format: 'bam' or 'cram'"
        single_ended: "Whether reads are single-ended"
        args: "Optional additional arguments for pbrun"
        memory: "Memory in GB"
        num_gpus: "Number of GPUs to use"
        num_cpus: "Number of CPU threads"
        container: "Container image URI"

        # outputs
        bam: "Aligned BAM/CRAM file"
        bai: "Index file for the BAM/CRAM"
        bqsr_table: "Optional BQSR table if known sites are provided"
        qc_metrics: "Optional QC metrics directory if specified in args"
        duplicate_metrics: "Optional duplicate metrics file if specified in args"
    }
}

struct BwaIndex {
    File fastaFile
    Array[File] indexFiles
}

workflow parabricks_fq2bam {
    input {
        File sample_sheet
        BwaIndex bwaIndex
        Array[File]? interval_file
        Array[File]? known_sites
        String output_fmt
        Boolean single_ended
        Array[String]? args
        Int memory
        Int num_gpus
        Int num_cpus
        String container
    }

    call fq2bam {
        reads = read_lines(sample_sheet),
        bwaIndex = bwaIndex, 
        interval_file = interval_file,
        known_sites = known_sites, 
        output_fmt = output_fmt, 
        single_ended = single_ended, 
        args = args, 
        memory = memory, 
        num_gpus = num_gpus, 
        num_cpus = num_cpus, 
        container = container
    }

    output {
        File bam = fq2bam.bam
        File bai = fq2bam.bai
        File? bqsr_table = fq2bam.bqsr_table
        File? qc_metrics = fq2bam.qc_metrics
        File? duplicate_metrics = fq2bam.duplicate_metrics
    }

    meta {
        author: "Gary Burnett (gburnett@nvidia.com)"
        description: "Converts FASTQ files to BAM/CRAM format using NVIDIA Parabricks fq2bam"
    }

    parameter_meta {
        # inputs 
        sample_sheet: "Sample sheet of FASTQ files to align"
        bwaIndex: "Reference genome FASTA file"
        interval_file: "Optional interval file for targeted regions (can be used multiple times)"
        known_sites: "Optional array of known variant sites for BQSR (can be used multiple times)"
        output_fmt: "Output format: 'bam' or 'cram'"
        single_ended: "Whether reads are single-ended"
        args: "Optional additional arguments for pbrun"
        memory: "Memory in GB"
        num_gpus: "Number of GPUs to use"
        num_cpus: "Number of CPU threads"
        container: "Container image URI"

        # outputs
        bam: "Aligned BAM/CRAM file"
        bai: "Index file for the BAM/CRAM"
        bqsr_table: "Optional BQSR table if known sites are provided"
        qc_metrics: "Optional QC metrics directory if specified in args"
        duplicate_metrics: "Optional duplicate metrics file if specified in args"
    }
}
