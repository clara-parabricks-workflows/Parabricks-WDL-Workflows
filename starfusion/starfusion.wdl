version 1.2

task starfusion {
    input {
        File sample_sheet
        File ref_fasta
        String prefix
        Array[String]? args
        Int memory
        Int num_gpus
        Int num_cpus
        String container
    }

    command <<<
        set -e

        pbrun \
            starfusion \
            --ref ~{ref_fasta} \
            --sample-sheet ~{sample_sheet} \
            --out-prefix "~{prefix}" \
            --num-gpus ~{num_gpus} \
            ~{sep(" ", select_first([args, []]))}
    >>>

    output {
        File fusion_report = "${prefix}.star-fusion.fusion_candidates.final"
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
        description: "NVIDIA Parabricks GPU accelerated StarFusion for fusion detection"
    }
}