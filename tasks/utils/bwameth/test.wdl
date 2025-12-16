version 1.2

import "bwameth.wdl" as bwameth_index

workflow bwameth_index_test {
    input {
        File ref_fasta
        Array[String]? args
        Int memory
        Int num_cpus
        String container
    }

    call bwameth_index.bwameth_index {
        ref_fasta = ref_fasta,
        args = args,
        memory = memory,
        num_cpus = num_cpus,
        container = container
    }

    output {
        File amb = bwameth_index.amb
        File ann = bwameth_index.ann
        File bwt = bwameth_index.bwt
        File pac = bwameth_index.pac
        File sa  = bwameth_index.sa
    }
}
