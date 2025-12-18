version 1.2

task star_genomegenerate {
    input {
        File fasta
        File? gtf
        String genome_dir = "star_genome"
        Array[String]? args = []
        Int memory = 32
        Int num_cpus = 8
        String container = "biocontainers/rna-star:v2.7.0adfsg-1-deb_cv1" 
    }

    command <<<
        set -e

        mkdir -p ~{genome_dir}
        STAR --runMode genomeGenerate \
             --genomeDir ~{genome_dir} \
             --genomeFastaFiles ~{fasta} \
             --runThreadN ~{num_cpus} \
             ~{if defined(gtf) then "--sjdbGTFfile " + gtf else ""} \
             ~{sep(" ", select_first([args, []]))}

    >>>

    output {
        Directory genome_lib_dir = genome_dir
    }

    requirements {
        docker: container
        cpu: num_cpus
        memory: memory
    }

    meta { 
        author: "Gary Burnett (gburnett@nvidia.com)" 
        description: "Build STAR genome index using baseline STAR" 
        outputs: {
            genome_lib_dir: "STAR genome index directory"
        }
    }

    parameter_meta {
        fasta: "Reference FASTA file to build STAR index"
        gtf: "Optional GTF file to incorporate splice junctions"
        genome_dir: "Output STAR genome directory name"
        args: "Optional additional arguments for STAR"
        memory: "Memory in GB"
        num_cpus: "Number of CPU threads"
        container: "Container image URI"
    }
}