version 1.2

import "../shared/ref_struct.wdl" as ref_struct

task fq2bammeth {
    input {
        Array[File] reads
        ReferenceFiles ref
        Array[File]? interval_file
        Array[File]? known_sites
        String output_fmt
        Boolean single_ended
        String prefix
        Array[String]? args
        Int memory
        Int num_gpus
        Int num_cpus
        String container
    }

    String extension_bam = output_fmt
    String extension_bam_index = if output_fmt == "cram" then "crai" else "bai"

    String known_sites_command = if defined(known_sites) then
        sep(" ", prefix("--knownSites ", select_first([known_sites, []])))
        else ""

    String interval_file_command = if defined(interval_file) then
        sep(" ", prefix("--interval-file ", select_first([interval_file, []])))
        else ""

    String in_fq_command = if single_ended then 
        sep(" ", prefix("--in-se-fq ", reads))
        else "--in-fq ${sep(" ", reads)}"

    command <<<
        set -e

        # Make sure the reference and index files are in the same directory 
        ref_dir=$(dirname ~{ref.fasta})
        for bwa_file in ~{sep(" ", ref.bwa_index)}; do
            ln -s "$bwa_file" ${ref_dir}/$(basename "$bwa_file")
        done

        pbrun \
            fq2bam_meth \
            --ref ~{ref.fasta} \
            ~{in_fq_command} \
            --out-bam ~{prefix}.~{extension_bam} \
            ~{known_sites_command} \
            ~{interval_file_command} \
            --num-gpus ~{num_gpus} \
            --monitor-usage \
            ~{sep(" ", select_first([args, []]))}
    >>>

    output {
        File bam = "${prefix}.${extension_bam}"
        File bai = "${prefix}.${extension_bam}.${extension_bam_index}"
        File? meth_metrics = if contains(select_first([args,[]]), "--out-meth-metrics") then "${prefix}.meth_metrics" else None
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
        description: "Converts FASTQ to methylation-aware BAM/CRAM using Parabricks fq2bammeth"
    }

    parameter_meta {
        reads: {description: "Array of FASTQ files to align", category: "required"}
        bwaIndex: "Reference genome FASTA file"
        interval_file: "Optional interval file for targeted regions"
        known_sites: "Optional known sites for BQSR"
        output_fmt: "Output format: 'bam' or 'cram'"
        single_ended: "Whether reads are single-ended"
        prefix: "Prefix for output files"
        args: "Optional additional arguments for pbrun"
        memory: "Memory in GB"
        num_gpus: "Number of GPUs to use"
        num_cpus: "Number of CPU threads"
        container: "Container image URI"
        bam: "Aligned BAM/CRAM file"
    }
}
