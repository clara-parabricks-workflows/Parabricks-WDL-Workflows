version 1.2

import "../../tasks/haplotypecaller.wdl" as haplotypecaller

workflow haplotypecaller_test {

    input {
        File bam
        ReferenceFiles ref
        Array[File]? interval_file
        Array[File]? known_sites
        Array[String]? args
        Int memory
        Int num_gpus
        Int num_cpus
        String container
    }

    call haplotypecaller.haplotypecaller {
        bam = bam,
        ref = ref,
        interval_file = interval_file,
        known_sites = known_sites,
        args = args,
        memory = memory,
        num_gpus = num_gpus,
        num_cpus = num_cpus,
        container = container
    }

    output {
        File vcf = haplotypecaller.vcf
    }

    meta {
        author: "Gary Burnett (gburnett@nvidia.com)"
        description: "NVIDIA Parabricks GPU Accelerated HaplotypeCaller"
    }

    parameter_meta {
        # inputs
        bam: "The input BAM file"
        bwaIndex: "Reference genome FASTA file"
        interval_file: "Optional interval file for targeted regions (can be used multiple times)"
        known_sites: "Optional array of known variant sites for BQSR (can be used multiple times)"
        args: "Optional additional arguments for pbrun"
        memory: "Memory in GB"
        num_gpus: "Number of GPUs to use"
        num_cpus: "Number of CPU threads"
        container: "Container image URI"

        # outputs
        vcf: "VCF file produced by HaplotypeCaller"
    }

}
