version 1.2

task bwameth_index {
    input {
        File ref_fasta
        Array[String]? args = []
        Int memory = 8
        Int num_cpus = 4
        String container = "josousa/bwa-meth:0.2.7"
    }

    command <<<
        set -e

        bwameth.py index ~{ref_fasta} ~{sep(" ", select_first([args, []]))}
    >>>

    output {
        File amb = "${ref_fasta}.amb"
        File ann = "${ref_fasta}.ann"
        File bwt = "${ref_fasta}.bwt"
        File pac = "${ref_fasta}.pac"
        File sa  = "${ref_fasta}.sa"
        Array[File] indexFiles = [amb, ann, bwt, pac, sa]
        File fastaFile = ref_fasta
    }

    requirements {
        docker: container
        cpu: num_cpus
        memory: memory
    }

    meta { 
        author: "Gary Burnett (gburnett@nvidia.com)"
        description: "Creates index files for use with bwa-meth or BWA" 
    }

    parameter_meta {
        ref_fasta: "Reference FASTA file to index"
        args: "Optional additional arguments for indexing tool"
        memory: "Memory in GB"
        num_cpus: "Number of CPU threads"
        container: "Container image URI"
    }
}

struct BwaIndex {
    File fasta
    File fasta_fai
    Array[File] indexFiles
}

workflow bwameth_index_workflow {
    input {
        File ref_fasta
        Array[String]? args
        Int memory
        Int num_cpus
        String container
    }

    call bwameth_index {
        ref_fasta = ref_fasta,
        args = args,
        memory = memory,
        num_cpus = num_cpus,
        container = container
    }

    output {
        
    }

    meta { author: "Gary Burnett (gburnett@nvidia.com)" }
}
