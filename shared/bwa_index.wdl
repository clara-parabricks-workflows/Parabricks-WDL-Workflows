version 1.2

task bwa_index {
    input {
        File fasta
        Array[String]? args = []
        Int memory = 8
        Int num_cpus = 4
        String container = "biocontainers/bwa:v0.7.17_cv1"
    }
    
    # Use a local symlink to avoid writing into the read-only input mount
    String local = basename(fasta)

    command <<<
        set -e

        # Create or update a symlink in the task working dir and index that
        ln -sf "~{fasta}" "~{local}"
        bwa index ~{sep(" ", select_first([args, []]))} "~{local}"
    >>>

    output {
        # BWA produces .amb, .ann, .bwt, .pac, .sa files next to the local symlink
        File amb = "${local}.amb"
        File ann = "${local}.ann"
        File bwt = "${local}.bwt"
        File pac = "${local}.pac"
        File sa  = "${local}.sa"
        Array[File] index_files = [amb, ann, bwt, pac, sa]
    }

    requirements {
        docker: container
        cpu: num_cpus
        memory: memory
    }

    meta { 
        author: "Gary Burnett (gburnett@nvidia.com)" 
        description: "Creates BWA index files for a reference FASTA using bwa index"
        outputs: {
            amb: "BWA index .amb file",
            ann: "BWA index .ann file",
            bwt: "BWA index .bwt file",
            pac: "BWA index .pac file",
            sa:  "BWA index .sa file",
            index_files: "Array of BWA index files"
        }
    }

    parameter_meta {
        fasta: "Reference FASTA file to index"
        args: "Optional additional arguments for bwa"
        memory: "Memory in GB"
        num_cpus: "Number of CPU threads"
        container: "Container image URI"
    }
}
