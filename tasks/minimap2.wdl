version 1.2

task minimap2 {
    input {
        Array[File] reads
        File ref_fasta
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

    String in_fq_command = if single_ended then 
        sep(" ", prefix("--in-se-fq ", reads))
        else "--in-fq ${sep(" ", reads)}"

    command <<<
        set -e

        pbrun \
            minimap2 \
            --ref ~{ref_fasta} \
            ~{in_fq_command} \
            --out-bam "~{prefix}.~{extension_bam}" \
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
    }
}
