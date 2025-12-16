version 1.2

import "bwa_index.wdl" as bwa_index

workflow bwa_index_test {
    input {
        File ref_fasta
        Array[String]? args
        Int memory
        Int num_cpus
        String container
    }

    call bwa_index.bwa_index {
        ref_fasta = ref_fasta,
        args = args,
        memory = memory,
        num_cpus = num_cpus,
        container = container
    }

    output {
        File amb = bwa_index.amb
        File ann = bwa_index.ann
        File bwt = bwa_index.bwt
        File pac = bwa_index.pac
        File sa  = bwa_index.sa
    }
}
