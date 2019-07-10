rule reverse_complement:
    input:
        "trimmed/{name}_{primer}.fastq"
    output:
        "trimmed/{name,[0-9]{1,2}}_{primer, .+[R]}-rev-comp.fastq"
    shell:
        "seqtk seq -r  {input} > {output}"

rule merge_fastq:
    input:
        sample=get_fq
    output:
        merged="merged/{name}.merger",
        consensus="merged/{name}_merged.fasta"
    log: "log/merger/{name}_merger.log"
    shell:
        ("merger  {input}  -outfile "
        "{output.merged} -outseq {output.consensus} 2> {log}")
