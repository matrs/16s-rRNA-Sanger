
from ete3 import NCBITaxa

#The first time this will download the taxonomic NCBI database and save a parsed version
#of it in  `~/.etetoolkit/taxa.sqlite`.May take some minutes
ncbi = NCBITaxa()
print("ncbi.dbfile", ncbi.dbfile)

with open(snakemake.input[0], 'r', encoding='utf8') as fh:
    genus_list = fh.read().strip().split('\n')

genus_to_taxid = ncbi.get_name_translator(genus_list)
tax_id_vals = genus_to_taxid.values()

tree = ncbi.get_topology([genus_id for subls in tax_id_vals for genus_id in subls], intermediate_nodes=True)

# `get_ascii()` has a bug, prints the taxons before to genus without any separation between them, so a way to avoid that is using extra attribues, `dist` seems to be less invasive. Also, numbers from 'dist' are replaced
with open(snakemake.output[0], mode='w', encoding='utf8') as fh:
    print(tree.get_ascii(attributes=["dist", "sci_name"]).replace('1.0,','-'), file=fh)
