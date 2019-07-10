include: "rules/common.smk"
include: "rules/abi_to_fastq.smk"
include: "rules/qc.smk"
include: "rules/merge.smk"
include: "rules/blast.smk"
include: "rules/rdp.smk"

rule all:
    input:
        "qc/multiqc.html",
        "qc/merger-quality.png",
        expand("results/blast/{name}_{project_name}-tophits.tsv", name=samples.name, project_name = config["project_name"]),
        expand("results/seqmatch/{name}_merged.tsv", name=samples.name),
        "qc/merger-quality.png",
        expand("results/classifier/{name}_merged-assign.txt",name=samples.name),
        expand("results/classifier/{name}_merged-ranks.txt",name=samples.name),
        "results/classifier/ncbi_tree.txt"
