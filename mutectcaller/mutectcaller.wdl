version 1.2

import "../shared/ref_struct.wdl" as ref_struct

task mutectcaller {
    input {
        ReferenceFiles ref
        File tumor_bam
        String tumor_name
        File? tumor_recal
        File? normal_bam
        String? normal_name
        File? normal_recal
        Array[File]? interval_file
        File? pon
        File? mutect_germline_resource   
        File? mutect_f1r2_tar_gz  
        File? mutect_alleles   
        String prefix
        Array[String]? args
        Int memory
        Int num_gpus
        Int num_cpus
        String container
    }

    String tumor_recal_command = if defined(tumor_recal) then
        "--in-tumor-recal ${tumor_recal}"
        else ""

    String normal_bam_command = if defined(normal_bam) then
        "--in-normal-bam ${normal_bam}"
        else ""

    String normal_name_command = if defined(normal_name) then
        "--normal-name ${normal_name}"
        else ""

    String normal_recal_command = if defined(normal_recal) then 
        "--in-normal-recal ${normal_recal}"
        else ""

    String interval_file_command = if defined(interval_file) then
        sep(" ", prefix("--interval-file ", select_first([interval_file, []])))
        else ""

    String mutect_germline_resource_command = if defined(mutect_germline_resource) then
        "--mutect-germline-resource ${mutect_germline_resource}"
        else ""

    String mutect_f1r2_tar_gz_command = if defined(mutect_f1r2_tar_gz) then
        "--mutect-f1r2-tar-gz ${mutect_f1r2_tar_gz}"
        else ""

    String mutect_alleles_command = if defined(mutect_alleles) then
        "--mutect-alleles ${mutect_alleles}"    
        else ""

    String pon_command = if defined(pon) then
        "--pon ${pon}"
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
            mutectcaller \
            --ref ~{ref.fasta} \
            --in-tumor-bam ~{tumor_bam} \
            --tumor-name ~{tumor_name} \
            ~{tumor_recal_command} \
            ~{normal_bam_command} \
            ~{normal_name_command} \
            ~{normal_recal_command} \
            ~{interval_file_command} \
            ~{mutect_germline_resource_command} \
            ~{mutect_f1r2_tar_gz_command} \
            ~{mutect_alleles_command} \
            ~{pon_command} \
            --out-vcf "~{prefix}.vcf" \
            --num-gpus ~{num_gpus} \
            ~{sep(" ", select_first([args, []]))}
    >>>

    output { 
        File vcf = "${prefix}.vcf" 
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
        description: "NVIDIA Parabricks GPU accelerated MutectCaller"
        outputs: {
            vcf: "Output VCF file containing detected mutations"
        }
    }
    
    parameter_meta {
        ref: "Reference genome files"
        tumor_bam: "Input tumor BAM file"
        tumor_name: "Name of the tumor sample"
        tumor_recal: "Input tumor recalibration file"
        normal_bam: "Input normal BAM file"
        normal_name: "Name of the normal sample"
        normal_recal: "Input normal recalibration file"
        interval_file: "Optional interval files to restrict analysis"
        pon: "Panel of normals file"
        mutect_germline_resource: "Mutect germline resource file"
        mutect_f1r2_tar_gz: "Mutect F1R2 tar.gz file"
        mutect_alleles: "Mutect alleles file"
        prefix: "Prefix for output files"
        args: "Additional command line arguments to pass to mutectcaller"
        memory: "Amount of memory to allocate to the task"
        num_gpus: "Number of GPUs to allocate to the task"
        num_cpus: "Number of CPU cores to allocate to the task"
        container: "Docker container image to use for the task"
    }
}
