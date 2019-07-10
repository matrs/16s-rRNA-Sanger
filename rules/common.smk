import pandas as pd
#pd.set_option("max_colwidth",200, 'max_columns', 20)

#load configuration file 
configfile: "config.yaml"
samples_file = config["samples"]
#print(samples_file)
#This is used to name so, blast
samples = pd.read_csv(samples_file, sep='\t').set_index("name", drop=False).dropna()
##print("samples df:", samples, sep='\n')
samples.index = [str(i) for i in samples.index] # enforce str in index
#print(samples)


#### Helpers ####

def get_abi(wildcards):
    #print("my wildcards are", repr(wildcards), sep=' ||| ')
    return samples.loc[(wildcards.name), ["read1", "read2"]].dropna()

def get_fq(wildcards):
    #print("my wildcards:", wildcards)
    return expand("trimmed/{name}_{group}.fastq", 
                  group=["27F", "1492R-rev-comp"], **wildcards)