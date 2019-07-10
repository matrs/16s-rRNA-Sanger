rule blastn:
    input:
        "merged/{name}_merged.fasta"
    output:
        "results/blast/{name, [0-9]{1,2}}_PRJNA33175_333.tsv"
    log: 
        "log/blast/{name}.log"
    params:
        db= config["blast_db"],
        evalue=1e-20
    shell:
        ("blastn -query {input} -db {params.db} -evalue {params.evalue} "
        "-max_target_seqs 100 -max_hsps 1 -outfmt '7 std slen qcovs qcovhsp " 
        "qcovus staxid sscinames' -num_threads 4 > {output} 2> {log}")

rule blast_top:
    input:
        "results/blast/{name}_PRJNA33175_333.tsv"
    output:
        #"results/blast/{name, [0-9]}_PRJNA33175_333-tophits.tsv"
        "results/blast/{name}_PRJNA33175_333-tophits.tsv"
    script:
        "../scripts/blast_top_hits.py"