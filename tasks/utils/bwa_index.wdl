version 1.2

task bwa_index {
    input {
        File fasta
        Array[String]? args = []
        Int memory = 8
        Int num_cpus = 4
        String container = "biocontainers/bwa:v0.7.17_cv1"
    }

    String prefix = basename(fasta)

    command <<<
        set -e

        # Use baseline bwa to build the index files
        bwa index ~{sep(" ", select_first([args, []]))} ~{fasta}
    >>>

    output {
        # BWA produces .amb, .ann, .bwt, .pac, .sa files next to the FASTA
        File amb = "${fasta}.amb"
        File ann = "${fasta}.ann"
        File bwt = "${fasta}.bwt"
        File pac = "${fasta}.pac"
        File sa  = "${fasta}.sa"
        Array[File] indexFiles = [amb, ann, bwt, pac, sa]
        File fastaFile = fasta
    }

    requirements {
        docker: container
        cpu: num_cpus
        memory: memory
    }

    meta { author: "Gary Burnett (gburnett@nvidia.com)" }

    parameter_meta {
        fasta: "Reference FASTA file to index"
        args: "Optional additional arguments for bwa"
        memory: "Memory in GB"
        num_cpus: "Number of CPU threads"
        container: "Container image URI"
    }
}

struct BwaIndex {
    File fasta
    Array[File] indexFiles
}
