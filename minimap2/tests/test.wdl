version 1.2

import "../minimap2.wdl" as minimap2  
import "../../shared/bwa_index.wdl" as bwa_index
import "../../shared/samtools_faidx.wdl" as samtools_faidx

workflow minimap2_test {
    input {
        File? reads_fq
        File? reads_bam
        File? index 
        File fasta
        Array[File]? interval_file
        Array[File]? known_sites
        String output_fmt
        Array[String]? args
        Int memory
        Int num_gpus
        Int num_cpus
        String container
    }

    call samtools_faidx.samtools_faidx {
        fasta = fasta
    }

    call bwa_index.bwa_index {
        fasta = fasta
    }

    call minimap2.minimap2 {
        reads_fq = reads_fq,
        reads_bam = reads_bam,
        index = index, 
        ref = ReferenceFiles { 
            fasta: fasta, 
            fasta_fai: samtools_faidx.fai,
            bwa_index: bwa_index.index_files 
        },
        interval_file = interval_file,
        known_sites = known_sites,
        output_fmt = output_fmt,
        args = args,
        memory = memory,
        num_gpus = num_gpus,
        num_cpus = num_cpus,
        container = container
    }

    output {
        File bam = minimap2.bam
        File bai = minimap2.bai
    }
    
    meta { 
        author: "Gary Burnett (gburnett@nvidia.com)" 
        description: "Test workflow for minimap2 alignment"
    }

    parameter_meta {
        reads_fq: "Input FASTQ file"
        reads_bam: "Input BAM file"
        index: "Pre-built minimap2 index"
        fasta: "Reference genome in FASTA format"
        interval_file: "Optional interval file for targeted alignment"
        known_sites: "Optional known sites for BQSR"
        output_fmt: "Output format, either 'bam' or 'cram'"
        args: "Additional command-line arguments for minimap2"
        memory: "Memory allocation for the task (in MB)"
        num_gpus: "Number of GPUs to use"
        num_cpus: "Number of CPU cores to use"
        container: "Docker container image to use for the task"
    }
}
