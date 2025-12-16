version 1.2

import "../../tasks/fq2bammeth.wdl" as fq2bammeth

workflow fq2bammeth_test {
    input {
        File sample_sheet
        ReferenceFiles ref
        Array[File]? interval_file
        Array[File]? known_sites
        String output_fmt
        Boolean single_ended
        Array[String]? args
        Int memory
        Int num_gpus
        Int num_cpus
        String container
    }

    call fq2bammeth.fq2bammeth {
        reads = read_lines(sample_sheet),
        ref = ref,
        interval_file = interval_file,
        known_sites = known_sites,
        output_fmt = output_fmt,
        single_ended = single_ended,
        args = args,
        memory = memory,
        num_gpus = num_gpus,
        num_cpus = num_cpus,
        container = container
    }

    output {
        File bam = fq2bammeth.bam
        File bai = fq2bammeth.bai
        File? meth_metrics = fq2bammeth.meth_metrics
    }

    meta { author: "Gary Burnett (gburnett@nvidia.com)" }
}
