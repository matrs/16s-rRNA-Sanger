import re
from collections import defaultdict
import pandas as pd
import sys
import matplotlib
matplotlib.use("agg")
import matplotlib.pyplot as plt
from pathlib import Path
import seaborn as sns

# matplotlib.use("agg")
sys.stdout = open(snakemake.log[0], 'w')
print("pandas version:", pd.__version__)
merger_files =snakemake.input #glob("*[1-9]*.merger")
pat = re.compile(r'([0-9]+\.[0-9]+)%')
parse_dic = defaultdict(list)

for f in merger_files:
    print("merger_files", repr(f))
    with open(f, mode='r', encoding='utf8') as fh:
        for line in fh:
            match = re.search(pat, line)
            if match:
                idx_name = Path(f).name
                parse_dic[idx_name].append(match.group(1)) 
print(parse_dic)
df = pd.DataFrame.from_dict(parse_dic, orient='index',columns=["Identity %","Similarity %","number of Gaps"]).astype(float)
print(df)
# fig, ax = plt.subplots(figsize=(8,6))
# plot = df.plot(rot=60, alpha=0.5, ax=ax, title="Phred quality")
# ax.set_xlabel("Merged reads")
# #fig = plot.get_figure()
# locs, labels = plt.xticks()
# plt.setp(labels, rotation=50)

fig, ax = plt.subplots(figsize=(8,6))
sns.lineplot(data=df, sort=False, alpha=0.6)
locs, labels = plt.xticks()
plt.setp(labels, rotation=50)
plt.tight_layout()
fig.savefig(snakemake.output[0])
