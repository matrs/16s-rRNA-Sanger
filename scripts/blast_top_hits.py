def Read_blast(blast_tab):
    import pandas as pd
    
    blast_table = pd.read_csv(blast_tab, sep="\t", comment="#", names=['QAcc', 'SubAcc',
    'Perc_ident', 'Align_len', 'Num_mis','Num_gaps','Q_start', 'Q_stop', 'Sub_start', 'Sub_end', 'Evalue','Bitscore', 'Sub_len','Q_cov', 'Q_covhsp', 'Q_covus','S_taxid', 'S_sci_names'])
    
    return blast_table

table_name = snakemake.output[0]
df = Read_blast(snakemake.input[0])
print("table {} already read".format(table_name))
df.sort_values(by=['Bitscore','Q_cov','Perc_ident','Align_len'], axis=0,
               ascending=False).head(10).to_csv(path_or_buf=table_name, sep='\t',index=False,float_format = "%.3f")