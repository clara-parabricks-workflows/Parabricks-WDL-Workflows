version 1.2

task mutectcaller {
    input {
        File tumor_bam
        File normal_bam
        BwaIndex bwaIndex
        Array[File]? known_sites
        Array[String]? args
        Int memory
        Int num_gpus
        Int num_cpus
        String container
    }

    String prefix = "test"
    String known_sites_command = if defined(known_sites) then
        sep(" ", prefix("--knownSites ", select_first([known_sites, []])))
        else ""

    command <<<
        set -e

        pbrun \
            mutectcaller \
            --ref ~{bwaIndex.fasta} \
            --tumor-bam ~{tumor_bam} \
            --normal-bam ~{normal_bam} \
            --out-variants "~{prefix}.vcf" \
            ~{known_sites_command} \
            --num-gpus ~{num_gpus} \
            ~{sep(" ", select_first([args, []]))}
    >>>

    output { File vcf = "${prefix}.vcf" }

    requirements {
        docker: container
        cpu: num_cpus
        memory: memory
        gpu: true
    }
    hints { gpu: num_gpus }

    meta { author: "Gary Burnett (gburnett@nvidia.com)" }
}

struct BwaIndex {
    File fasta
    File fasta_fai
    Array[File] indexFiles
}