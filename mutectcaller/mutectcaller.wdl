version 1.2

import "../shared/ref_struct.wdl" as ref_struct

task mutectcaller {
    input {
        File tumor_bam
        File? tumor_recal
        File? normal_bam
        File? normal_recal
        ReferenceFiles ref
        Array[File]? interval_file
        File? pon
        File? mutect_germline_resource   
        File? mutect_f1r2_tar_gz  
        File? mutect_alleles   
        Array[File]? known_sites
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

    command <<<
        set -e

        pbrun \
            mutectcaller \
            --ref ~{ref.fasta} \
            --tumor-bam ~{tumor_bam} \
            --normal-bam ~{normal_bam} \
            --out-vcf "~{prefix}.vcf" \
            ~{interval_file_command} \
            --num-gpus ~{num_gpus} \
            ~{sep(" ", select_first([args, []]))}
    >>>

    output { File vcf = "${prefix}.vcf" }

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
        description: "NVIDIA Parabricks GPU accelerated MutectCaller"
    }
    
    parameter_meta {
        tumor_bam: "Input tumor BAM file"
        normal_bam: "Input normal BAM file"
        ref: "Reference genome files"
        interval_file: "Optional interval files to restrict analysis"
        prefix: "Prefix for output files"
        args: "Additional command line arguments to pass to mutectcaller"
        memory: "Amount of memory to allocate to the task"
        num_gpus: "Number of GPUs to allocate to the task"
        num_cpus: "Number of CPU cores to allocate to the task"
        container: "Docker container image to use for the task"
    }
}
