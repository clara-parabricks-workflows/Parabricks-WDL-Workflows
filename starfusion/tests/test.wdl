version 1.2

import "../starfusion.wdl" as starfusion

workflow starfusion_test {
    input {
        File sample_sheet
        File ref_fasta
        String prefix
        Array[String]? args
        Int memory
        Int num_gpus
        Int num_cpus
        String container
    }

    call starfusion.starfusion {
        sample_sheet = sample_sheet,
        ref_fasta = ref_fasta,
        prefix = prefix,
        args = args,
        memory = memory,
        num_gpus = num_gpus,
        num_cpus = num_cpus,
        container = container
    }

    output { File fusion_report = starfusion.fusion_report }
}
