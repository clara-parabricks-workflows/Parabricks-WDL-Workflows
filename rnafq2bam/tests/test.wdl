version 1.2

import "../rnafq2bam.wdl" as rnafq2bam
import "../../shared/bwa_index.wdl" as bwa_index
import "../../shared/samtools_faidx.wdl" as samtools_faidx
import "../../shared/star_genomegenerate.wdl" as star_genomegenerate

workflow rnafq2bam_test {
    input {
        File sample_sheet
        File fasta
        String output_fmt
        Boolean single_ended
        Boolean qc_metrics_bool
        Boolean duplicate_metrics_bool
        String prefix
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

    call star_genomegenerate.star_genomegenerate {
        fasta = fasta,
        genome_lib_dir_name = "STAR"
    }

    call rnafq2bam.rnafq2bam {
        reads = read_lines(sample_sheet),
        ref = ReferenceFiles { 
            fasta: fasta, 
            fasta_fai: samtools_faidx.fai,
            bwa_index: bwa_index.index_files 
        },
        genome_lib_dir = star_genomegenerate.genome_lib_dir,
        output_fmt = output_fmt,
        single_ended = single_ended,
        qc_metrics_bool = qc_metrics_bool,
        duplicate_metrics_bool = duplicate_metrics_bool,
        prefix = prefix,
        args = args,
        memory = memory,
        num_gpus = num_gpus,
        num_cpus = num_cpus,
        container = container
    }

    output {
        File bam = rnafq2bam.bam
        File bai = rnafq2bam.bai
        Directory? qc_metrics = rnafq2bam.qc_metrics
        File? duplicate_metrics = rnafq2bam.duplicate_metrics
        File? junction = rnafq2bam.junction
    }

    meta {
        author: "Gary Burnett (gburnett@nvidia.com)"
        description: "Converts FASTQ files to BAM/CRAM format using NVIDIA Parabricks fq2bam"
        outputs: {
            bam: "BAM/CRAM file",
            bai: "BAM/CRAM index file",
            qc_metrics: "Directory containing QC metrics (if qc_metrics_bool is true)",
            duplicate_metrics: "File containing duplicate metrics (if duplicate_metrics_bool is true)",
            junction: "File containing junction information (if output_fmt is 'cram')"
        }
    }

    parameter_meta {
        sample_sheet: "Sample sheet file containing paths to FASTQ files"
        fasta: "Reference FASTA file"
        output_fmt: "Output format (bam or cram)"
        single_ended: "Boolean indicating if the input reads are single-ended"
        qc_metrics_bool: "Boolean indicating if QC metrics should be generated"
        duplicate_metrics_bool: "Boolean indicating if duplicate metrics should be generated"
        prefix: "Prefix for output files"
        args: "Array of additional arguments for the fq2bam command"
        memory: "Memory allocation for the workflow"
        num_gpus: "Number of GPUs to use for the workflow"
        num_cpus: "Number of CPUs to use for the workflow"
        container: "Docker container to use for the workflow"
    }
}
