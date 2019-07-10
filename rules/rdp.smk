rule seqmatch:
    input:
        "merged/{name}_merged.fasta"
    output:
        "results/seqmatch/{name, [0-9]{1,2}}_merged.tsv"
    params: 
        trainee= config["rdp_trainee"]
    log: 
        "log/seqmatch/{name}.log"
    shell:
        "SequenceMatch seqmatch {params.trainee} {input} > {output}"

rule classifier:
    input:
        "merged/{name,[0-9]}_merged.fasta"
    output:
        "results/classifier/{name, [0-9]{1,2}}_merged-assign.txt",
        "results/classifier/{name, [0-9]{1,2}}_merged-ranks.txt",
        "results/classifier/cnadjusted_{name}_merged-ranks.txt"
    log: 
        "log/classifier/{name}.log"
    shell:
        "classifier classify {input} -o {output[0]} -h {output[1]}"

rule genus_list:
    input:
        expand("results/classifier/cnadjusted_{name}_merged-ranks.txt", name=samples.name)
    output:
        "results/classifier/genus.list"
    shell:#has to pass one by one to cut and tail them. Expand is used because wildcard needed
        "for f in {input};do cut -f 3 $f | tail -n 1  >> {output};done"

rule ncbi_tree:
    input:
        "results/classifier/genus.list"
    output:
        "results/classifier/ncbi_tree.txt"
    script:
        "../scripts/tree_top_seqmatch.py"