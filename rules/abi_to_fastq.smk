rule abi_to_fastq:
    input:
        get_abi
    output:
        "fastq/{name, [0-9]{1,2}}_{primer, .+[F-R]}.fastq"
    script:
        "../scripts/abi_to_fastq.py"