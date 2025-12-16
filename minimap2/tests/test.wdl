version 1.2

import "../minimap2.wdl" as minimap2  

workflow minimap2_test {
    input {
        File sample_sheet
        File ref_fasta
        String output_fmt
        Boolean single_ended
        Array[String]? args
        Int memory
        Int num_gpus
        Int num_cpus
        String container
    }

    call minimap2.minimap2 {
        reads = read_lines(sample_sheet),
        ref_fasta = ref_fasta,
        output_fmt = output_fmt,
        single_ended = single_ended,
        args = args,
        memory = memory,
        num_gpus = num_gpus,
        num_cpus = num_cpus,
        container = container
    }

    output {
        File bam = minimap2.bam
        File bai = minimap2.bai
    }
    
    meta { author: "Gary Burnett (gburnett@nvidia.com)" }
}
