version 1.2

struct ReferenceFiles {
    File fasta
    File fasta_fai
    Array[File] bwa_index

    meta {
        description: "A bundled structure for reference files"
        author: "Gary Burnett (gburnett@nvidia.com)"
    }

    parameter_meta {
        fasta: "Reference FASTA file"
        fasta_fai: "FASTA index file (.fai)"
        bwa_index: "Array of BWA index files"
    }

}
