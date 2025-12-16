version 1.2

import "star.wdl" as star_index

workflow star_index_test {
    input {
        File ref_fasta
        File? ref_gtf
        String genome_dir = "star_genome"
        Array[String]? args
        Int memory
        Int num_cpus
        String container
    }

    call star_index.star_index {
        ref_fasta = ref_fasta,
        ref_gtf = ref_gtf,
        genome_dir = genome_dir,
        args = args,
        memory = memory,
        num_cpus = num_cpus,
        container = container
    }

    output {
        File star_genome_tar = star_index.star_genome_tar
    }
}
