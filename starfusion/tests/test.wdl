version 1.2

import "../starfusion.wdl" as starfusion
import "../../rnafq2bam/rnafq2bam.wdl" as rnafq2bam
import "../../shared/bwa_index.wdl" as bwa_index
import "../../shared/samtools_faidx.wdl" as samtools_faidx
import "../../shared/starfusion_build.wdl" as starfusion_build
import "../../shared/star_genomegenerate.wdl" as star_genomegenerate

workflow starfusion_test {
    input {
        File sample_sheet
        File fasta
        File gtf
        String output_fmt
        Boolean single_ended
        Boolean qc_metrics_bool
        Boolean duplicate_metrics_bool
        String prefix
        File fusion_annot_lib
        String pfam_db
        String dfam_db
        String annot_filter_url
        Int memory
        Int num_gpus
        Int num_cpus
        String container
    }

    call star_genomegenerate.star_genomegenerate {
        fasta = fasta, 
        gtf = gtf,
        genome_lib_dir_name = "STAR"
    }

    call samtools_faidx.samtools_faidx {
        fasta = fasta
    }

    call bwa_index.bwa_index {
        fasta = fasta
    }

    call rnafq2bam.rnafq2bam {
        reads = read_lines(sample_sheet),
        ref = ReferenceFiles { 
            fasta: fasta, 
            fasta_fai: samtools_faidx.fai,
            bwa_index: bwa_index.index_files 
        },
        genome_lib_dir = star_genomegenerate.genome_lib_dir,
        output_fmt = output_fmt,
        single_ended = single_ended,
        qc_metrics_bool = qc_metrics_bool,
        duplicate_metrics_bool = duplicate_metrics_bool,
        prefix = prefix,
        args = ["--read-files-command zcat", "--out-chim-type Junctions", "--min-chim-segment 15"],
        memory = memory,
        num_gpus = num_gpus,
        num_cpus = num_cpus,
        container = container
    }

    call starfusion_build.starfusion_build {
        fasta = fasta,
        gtf = gtf,
        genome_lib_dir_name = "STAR-Fusion",
        fusion_annot_lib = fusion_annot_lib,
        pfam_db = pfam_db,
        dfam_db = dfam_db,
        annot_filter_url = annot_filter_url,
        memory = memory,
        num_cpus = num_cpus
    }

    call starfusion.starfusion {
        chimeric_junction = select_first([rnafq2bam.junction]),
        genome_lib_dir = starfusion_build.genome_lib_dir,
        prefix = prefix,
        memory = memory,
        num_gpus = num_gpus,
        num_cpus = num_cpus,
        container = container
    }

    output { 
        Directory out_dir = starfusion.out_dir 
    }
}
