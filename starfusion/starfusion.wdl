version 1.2

task starfusion {
    input {
        File chimeric_junction
        Directory genome_lib_dir
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
            --chimeric-junction ~{chimeric_junction} \
            --genome-lib-dir ~{genome_lib_dir} \
            --output-dir ~{prefix} \
            ~{sep(" ", select_first([args, []]))}
    >>>

    output {
        Directory out_dir = "${prefix}"
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
        outputs: {
            out_dir: "Directory containing the output files from StarFusion"
        }
    }

    parameter_meta {
        chimeric_junction: "Path to the chimeric junction file"
        genome_lib_dir: "Path to the genome library directory"
        prefix: "Prefix for the output directory"
        args: "Additional arguments for StarFusion"
        memory: "Memory requirement for the task"
        num_gpus: "Number of GPUs required for the task"
        num_cpus: "Number of CPUs required for the task"
        container: "Docker container to use for the task"
    }

}