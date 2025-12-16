version 1.2

import "../shared/ref_struct.wdl" as ref_struct

task rnafq2bam {
    input {
        Array[File] reads
        ReferenceFiles ref
        Array[File]? interval_file
        Array[String]? args
        Int memory
        Int num_gpus
        Int num_cpus
        String container
    }

    String prefix = "test"
    String extension_bam = "bam"
    String extension_bam_index = "bai"

    String interval_file_command = if defined(interval_file) then
        sep(" ", prefix("--interval-file ", select_first([interval_file, []])))
        else ""

    String in_fq_command = "--in-fq ${sep(" ", reads)}"

    command <<<
        set -e

        pbrun \
            rnafq2bam \
            --ref ~{ref.fasta} \
            ~{in_fq_command} \
            --out-bam "~{prefix}.~{extension_bam}" \
            ~{interval_file_command} \
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
        description: "NVIDIA Parabricks GPU accelerated RNA FASTQ to BAM"
    }
}
