version 1.2

task star_index {
    input {
        File ref_fasta
        File? ref_gtf
        String genome_dir = "star_genome"
        Array[String]? args = []
        Int memory = 32
        Int num_cpus = 8
        String container = "docker://quay.io/biocontainers/star:2.7.10a--0"
    }

    String prefix = genome_dir

    command <<<
        set -e

        mkdir -p ~{genome_dir}
        STAR --runMode genomeGenerate \
             --genomeDir ~{genome_dir} \
             --genomeFastaFiles ~{ref_fasta} \
             --runThreadN ~{num_cpus} \
             ~{if defined(ref_gtf) then "--sjdbGTFfile " + ref_gtf else ""} \
             ~{sep(" ", select_first([args, []]))}

    >>>

    output {
        Directory star_genome_dir = genome_dir
    }

    requirements {
        docker: container
        cpu: num_cpus
        memory: memory
    }

    meta { 
        author: "Gary Burnett (gburnett@nvidia.com)" 
        description: "Build STAR genome index using baseline STAR" 
    }

    parameter_meta {
        ref_fasta: "Reference FASTA file to build STAR index"
        ref_gtf: "Optional GTF file to incorporate splice junctions"
        genome_dir: "Output STAR genome directory name"
        args: "Optional additional arguments for STAR"
        memory: "Memory in GB"
        num_cpus: "Number of CPU threads"
        container: "Container image URI"
    }
}