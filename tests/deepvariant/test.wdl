version 1.2

import "../../tasks/deepvariant.wdl" as deepvariant

workflow deepvariant_test {

    input {
        File bam
        ReferenceFiles ref
        Array[File]? interval_file
        File? pb_model_file
        File? proposed_variants
        Array[String]? args
        Int memory
        Int num_gpus
        Int num_cpus
        String container
    }

    call deepvariant.deepvariant {
        bam = bam,
        ref = ref, 
        interval_file = interval_file,
        pb_model_file = pb_model_file,
        proposed_variants = proposed_variants,
        args = args, 
        memory = memory, 
        num_gpus = num_gpus, 
        num_cpus = num_cpus, 
        container = container
    }

    output {
        File vcf = deepvariant.vcf
        File? gvcf = deepvariant.gvcf
    }

    meta {
        author: "Gary Burnett (gburnett@nvidia.com)"
        description: "NVIDIA Parabricks GPU Accelerated DeepVariant"
    }

    parameter_meta {
        # inputs 
        bam: "The input BAM file"
        bwaIndex: "Reference genome FASTA file"
        interval_file: "Optional interval file for targeted regions (can be used multiple times)"
        pb_model_file: "Optional Parabricks model file for DeepVariant"
        proposed_variants: "Optional proposed variants file (*.vcf.gz) for the make examples stage"
        args: "Optional additional arguments for pbrun"
        memory: "Memory in GB"
        num_gpus: "Number of GPUs to use"
        num_cpus: "Number of CPU threads"
        container: "Container image URI"

        # outputs
        vcf: "vcf file created with deepvariant"
        gvcf: "bgzipped gvcf created with deepvariant"
    }

}
