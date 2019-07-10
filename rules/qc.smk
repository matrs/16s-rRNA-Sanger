rule fastqc_pre:
    input:
        "fastq/{name}_{primer}.fastq"
    output:
        html="qc/fastqc/pre/{name, [0-9]{1,2}}_{primer, .+[F-R]}_fastqc.html",
        zip="qc/fastqc/pre/{name,[0-9]{1,2}}_{primer, .+[F-R]}_fastqc.zip"
    wrapper:
        "0.35.1/bio/fastqc"

rule qual_trim:#quality trim and mask to N below phred 13
        input:
            "fastq/{name}_{primer}.fastq"
        output:
            "trimmed/{name}_{primer,.+[F-R]}.fastq"
        #priority:50
        shell:
            "seqtk trimfq -q 0.05 {input} | seqtk  seq -q 13 -n N > {output}"

rule fastqc_post:
    input:
        "trimmed/{name}_{primer}.fastq"
    output:
        html="qc/fastqc/post/{name,[0-9]{1,2}}_{primer, .+[F-R]}_fastqc.html",
        zip="qc/fastqc/post/{name,[0-9]{1,2}}_{primer, .+[F-R]}_fastqc.zip"
    wrapper:
        "0.35.1/bio/fastqc"

rule multiqc:
    input:
        expand(["qc/fastqc/pre/{sample}_{primer}_fastqc.zip",
                "qc/fastqc/post/{sample}_{primer}_fastqc.zip"],
               sample=samples.name, primer=["27F", "1492R"])
    output:
        "qc/multiqc.html"
    log:
        "log/multiqc.log"
    params: "--dirs"
    wrapper:
        "0.35.1/bio/multiqc"

rule merger_quality:
    input:
        expand("merged/{name}.merger", name=samples.name)
    output:
        "qc/merger-quality.png"
    log:
        "log/merger_qc.log"
    script:
        "../scripts/merger_qc_plot.py"