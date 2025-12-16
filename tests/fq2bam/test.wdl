version 1.2

import "../../tasks/fq2bam.wdl" as fq2bam

workflow fq2bam_test {
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

    call fq2bam.fq2bam {
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