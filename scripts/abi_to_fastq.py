from Bio import SeqIO, Seq
from pathlib import Path

for abi in snakemake.input:
    abi_name=Path(abi).name
    out_fastq= "{0}/{1}".format("fastq", abi_name.replace("ab1", "fastq"))
    SeqIO.convert(abi, "abi", out_fastq, "fastq")
