version 1.2

import "../../tasks/rnafq2bam.wdl" as rnafq2bam

workflow rnafq2bam_test {
    input {
        File sample_sheet
        ReferenceFiles ref
        Array[File]? interval_file
        Array[String]? args
        Int memory
        Int num_gpus
        Int num_cpus
        String container
    }

    call rnafq2bam.rnafq2bam {
        reads = read_lines(sample_sheet),
        ref = ref,
        interval_file = interval_file,
        args = args,
        memory = memory,
        num_gpus = num_gpus,
        num_cpus = num_cpus,
        container = container
    }

    output {
        File bam = rnafq2bam.bam
        File bai = rnafq2bam.bai
    }
}
