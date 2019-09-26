#! /usr/bin/env bash

echo "Please enter the number of cores to be used by snakemake"
read -p 'Number of cores: ' cores

snakemake -pr -j $cores
#snakemake --detailed-summary|awk -F '\t' '$7!~/^-/ {print $7}' > snake_cmds.txt
snakemake --rulegraph | dot -Tsvg > dag_rules.svg
snakemake --dag | dot -Tsvg > dag.svg
