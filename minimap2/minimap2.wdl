version 1.2

import "../shared/ref_struct.wdl" as ref_struct

task minimap2 {
    input {
        File? reads_fq
        File? reads_bam
        File? index 
        ReferenceFiles ref
        Array[File]? interval_file
        Array[File]? known_sites
        String output_fmt
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

    String in_reads_command = if defined(reads_fq) then
            "--in-fq ~{reads_fq}"
        else if defined(reads_bam) then
            "--in-bam ~{reads_bam}"
        else ""

    String index_command = if defined(index) then
            "--index ~{index}"
        else ""

    command <<<
        set -e

        # Make sure the reference and index files are in the same directory 
        ref_dir=$(dirname ~{ref.fasta})
        ln -s ~{ref.fasta_fai} ${ref_dir}/$(basename ~{ref.fasta_fai})
        for bwa_file in ~{sep(" ", ref.bwa_index)}; do
            ln -s "$bwa_file" ${ref_dir}/$(basename "$bwa_file")
        done

        pbrun \
            minimap2 \
            --ref ~{ref.fasta} \
            ~{in_reads_command} \
            --out-bam ~{prefix}.~{extension_bam} \
            ~{known_sites_command} \
            ~{known_sites_output_cmd} \
            ~{interval_file_command} \
            ~{index_command} \
            --num-gpus ~{num_gpus} \
            ~{sep(" ", select_first([args, []]))}
    >>>

    output {
        File bam = "${prefix}.${extension_bam}"
        File bai = "${prefix}.${extension_bam}.${extension_bam_index}"
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
        description: "NVIDIA Parabricks GPU accelerated Minimap2"
        outputs: {
            bam: "The output BAM/CRAM file",
            bai: "The output BAM/CRAM index file"
        }
    }

    parameter_meta {
        reads_fq: "Input FASTQ file(s) for alignment"
        reads_bam: "Input BAM file(s) for alignment"
        index: "Pre-built minimap2 index file"
        ref: "Reference genome files"
        interval_file: "Optional interval file(s) to restrict alignment regions"
        known_sites: "Optional known sites file(s) for base recalibration"
        output_fmt: "Output format, either 'bam' or 'cram'"
        args: "Additional command line arguments to pass to minimap2"
        memory: "Amount of memory to allocate to the task (in MB)"
        num_gpus: "Number of GPUs to allocate to the task"
        num_cpus: "Number of CPU cores to allocate to the task"
        container: "Docker container image with Parabricks installed"
    }

}
