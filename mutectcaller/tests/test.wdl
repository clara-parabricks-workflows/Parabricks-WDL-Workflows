version 1.2

import "../mutectcaller.wdl" as mutectcaller

workflow mutectcaller_test {
    input {
        File tumor_bam
        File normal_bam
        ReferenceFiles ref
        Array[File]? known_sites
        Array[String]? args
        Int memory
        Int num_gpus
        Int num_cpus
        String container
    }

    call mutectcaller.mutectcaller {
        tumor_bam = tumor_bam,
        normal_bam = normal_bam,
        ref = ref,
        known_sites = known_sites,
        args = args,
        memory = memory,
        num_gpus = num_gpus,
        num_cpus = num_cpus,
        container = container
    }

    output { File vcf = mutectcaller.vcf }
    meta { author: "Gary Burnett (gburnett@nvidia.com)" }
}
