version 1.2

import "../shared/ref_struct.wdl" as ref_struct

task deepvariant {

    input {
        File bam
        ReferenceFiles ref
        Array[File]? interval_file
        File? pb_model_file
        File? proposed_variants
        String prefix
        Array[String]? args
        Int memory
        Int num_gpus
        Int num_cpus
        String container
    }

    String interval_file_command = if defined(interval_file) then
        sep(" ", prefix("--interval-file ", select_first([interval_file, []])))
        else ""

    String pb_model_file_command = if defined(pb_model_file) then
        "--pb-model-file ${pb_model_file}"
        else ""

    String proposed_variants_command = if defined(proposed_variants) then
        "--proposed-variants ${proposed_variants}"
        else ""

    command <<< 
        set -e

        # Make sure the reference and index files are in the task's working directory
        ln -s ~{ref.fasta} $(basename ~{ref.fasta})
        ln -s ~{ref.fasta_fai} $(basename ~{ref.fasta_fai})
        for bwa_file in ~{sep(" ", ref.bwa_index)}; do
            ln -s "$bwa_file" $(basename "$bwa_file")
        done

        pbrun \
            deepvariant \
            --ref $(basename ~{ref.fasta}) \
            --in-bam ~{bam} \
            --out-variants "~{prefix}.vcf" \
            ~{interval_file_command} \
            ~{pb_model_file_command} \
            ~{proposed_variants_command} \
            --num-gpus ~{num_gpus} \
            --preserve-file-symlinks \
            ~{sep(" ", select_first([args, []]))}
    >>>

    output {
        File vcf = "${prefix}.vcf"
        File? gvcf = "${prefix}.g.vcf.gz"
    }

    requirements {
        docker: container
        cpu: num_cpus
        memory: "~{memory} GB"
        gpu: true
    }

    hints {
        gpu: num_gpus
    }

    meta {
        author: "Gary Burnett (gburnett@nvidia.com)"
        description: "The NVIDIA Parabricks GPU accelerated version of DeepVariant"
    }

    parameter_meta {
        # inputs
        reads: {description: "Array of FASTQ files to align", category: "required"}
        bwaIndex: "Reference genome FASTA file"
        interval_file: "Optional interval file for targeted regions (can be used multiple times)"
        known_sites: "Optional array of known variant sites for BQSR (can be used multiple times)"
        output_fmt: "Output format: 'bam' or 'cram'"
        single_ended: "Whether reads are single-ended"
        prefix: "Prefix for output files"
        args: "Optional additional arguments for pbrun"
        memory: "Memory requirement (in GB) for the task"
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