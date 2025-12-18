version 1.2

import "../mutectcaller.wdl" as mutectcaller
import "../../shared/bwa_index.wdl" as bwa_index
import "../../shared/samtools_faidx.wdl" as samtools_faidx

workflow mutectcaller_test {
    input {
        File fasta
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

    call samtools_faidx.samtools_faidx {
        fasta = fasta
    }

    call bwa_index.bwa_index {
        fasta = fasta
    }

    call mutectcaller.mutectcaller {
        ref = ReferenceFiles { 
            fasta: fasta, 
            fasta_fai: samtools_faidx.fai,
            bwa_index: bwa_index.index_files 
        },
        tumor_bam = tumor_bam,
        tumor_name = tumor_name,
        tumor_recal = tumor_recal,
        normal_bam = normal_bam,
        normal_name = normal_name,
        normal_recal = normal_recal,
        interval_file = interval_file,
        pon = pon,
        mutect_germline_resource = mutect_germline_resource,
        mutect_f1r2_tar_gz = mutect_f1r2_tar_gz,
        mutect_alleles = mutect_alleles,
        prefix = prefix,
        args = args,
        memory = memory,
        num_gpus = num_gpus,
        num_cpus = num_cpus,
        container = container
    }

    output { 
        File vcf = mutectcaller.vcf 
    }
    
    meta { 
        author: "Gary Burnett (gburnett@nvidia.com)" 
        description: "Mutectcaller test workflow"
        outputs: {
            vcf: "VCF output from Mutectcaller"
        }
    }

    parameter_meta {
        ref: "Reference files for the workflow"
        tumor_bam: "Tumor BAM file"
        tumor_name: "Name of the tumor sample"
        tumor_recal: "Tumor recalibration file"
        normal_bam: "Normal BAM file"
        normal_name: "Name of the normal sample"
        normal_recal: "Normal recalibration file"
        interval_file: "Interval file for the workflow"
        pon: "Panel of normals file"
        mutect_germline_resource: "Mutect germline resource file"
        mutect_f1r2_tar_gz: "Mutect F1R2 tar.gz file"
        mutect_alleles: "Mutect alleles file"
        prefix: "Prefix for the output files"
        args: "Array of additional arguments for the workflow"
        memory: "Memory allocation for the workflow"
        num_gpus: "Number of GPUs for the workflow"
        num_cpus: "Number of CPUs for the workflow"
        container: "Docker container for the workflow"
    }

}
