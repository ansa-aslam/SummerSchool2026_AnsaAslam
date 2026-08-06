## Gene Expression Workflow (Control vs Treated)

Module 1 capstone. This is my end-to-end pipeline that takes the raw files from`Module1/data/` all the way to a ranked list of genes that respond to treatment,plus the figures and interpretation I used for the presentation.

The short version: Bash organizes and stages the data, Python parses thesupporting sequence/annotation files, and R does the actual analysis and plotting.

## Folder structure

```
Project/
├── raw/          # untouched input files (copied here by set.sh, never edited)
├── scripts/      # set.sh, parse.py, analysis.R
├── results/      # summary tables produced by parse.py + analysis.R
├── figures/      # the 4 ggplot2 figures, saved at 300 dpi
└── README.md     
```

## Data

- `gene_expression.csv` — 20 genes x 6 samples (3 control, 3 treated), raw counts
- `sample_metadata.csv` — sample, condition, batch, RIN
- `genes.fasta`, `sample_reads.fastq`, `annotations.gff3`, `variants.vcf` — supporting files

## How to reproduce this (run in order)
(**Note:** Modify the file paths in `set.sh`, `parse.py`, and `analysis.R` to match your own directory structure before running the workflow.)

```bash
# 1. Set up project folders and stage the raw data
bash scripts/set.sh

# 2. Parse the FASTA/FASTQ/GFF3/VCF files into summary tables
python parse.py
# (needs biopython + pandas: pip install biopython pandas)

# 3-5. Import, wrangle, and plot in R
Rscript analysis.R
# (needs tidyverse: install.packages("tidyverse"))
```

That's it — `results/` and `figures/` get regenerated from scratch each time.
I kept `raw/` separate and never edit it directly, so re-running is safe.

## What each script does

**`scripts/set.sh`** — makes the `raw/ scripts/ results/ figures/` folders, copies the raw data in from the course data directory, and prints a quick summary (file list + count) so I can sanity-check the copy worked before moving on.

**`scripts/parse.py`** — goes through the four supporting files one at a time:
- FASTA → counts sequences and computes average GC%
- FASTQ → counts reads, mean Phred quality, and how many reads pass Q30
- GFF3 → counts each feature type (gene/mRNA/exon)
- VCF → counts variant records

Each one gets saved as its own CSV in `results/` (`fasta_summary.csv`, `fastq_summary.csv`, `gff_summary.csv`, `vcf_summary.csv`).

**`scripts/analysis.R`** — the main analysis:
1. Reads in the expression matrix and metadata with `read_csv()`
2. `pivot_longer()`s the expression matrix from wide to tidy/long
3. `left_join()`s it to the metadata on `sample`
4. Groups by gene + condition and gets mean/SD
5. Computes log2 fold-change per gene: `log2((mean_treated + 1) / (mean_control + 1))` — the `+1` is just a pseudocount so genes with low/zero counts don't blow up
6. Ranks genes by `abs(log2FC)` and writes `results/fold_change.csv`
7. Makes 4 plots with ggplot2 and saves each to `figures/` at 300 dpi:
   - `boxplot.png` — count distribution by condition
   - `histogram.png` — log2FC distribution across all 20 genes
   - `barplot.png` — genes ranked by log2FC (color = up/down)
   - `scatter.png` — mean control vs mean treated, with a y=x reference line

## Results summary

Parsing summary (from `results/`):

| File | Result |
|---|---|
| `genes.fasta` | 8 sequences, average GC content 51.5% |
| `sample_reads.fastq` | 2,000 reads, mean quality 29.93, 1,711 passed QC (Q≥30) |
| `annotations.gff3` | 32 features total — 8 gene, 8 mRNA, 16 exon |
| `variants.vcf` | 20 variants |

Top responders by fold-change (from `results/fold_change.csv`):

| Up in treated | log2FC | Down in treated | log2FC |
|---|---|---|---|
| crp | +1.92 | emrB | -2.29 |
| ompA | +1.64 | dnaA | -1.75 |
| rpoB | +1.62 | tolC | -1.74 |
| lacZ | +0.89 | marA | -0.72 |
| recA | +0.88 | sodA | -0.65 |

## Interpretation (Step 6)

**Figure 1: Boxplot of expression by condition.**Treated samples show a slightly higher median and a wider spread than control, meaning most genes stay steady while a subset responds strongly. Biologically, this points to the treatment switching specific genes on or off rather than shifting the whole genome equally.

**Figure 2: Histogram of log2 fold-change.** Most genes cluster close to a log2FC of zero, meaning their expression barely changes after treatment. A small number of genes show strong  positive or negative fold-changes instead. Biologically, this is the signature of a targeted response rather than a global one — likely genes tied to stress response, adaptation, or metabolism rather than the whole transcriptome reacting at once.

**Figure 3: Bar plot of top responding genes.**crp, ompA, rpoB, lacZ, and recA are the strongest upregulated genes; emrB, dnaA, tolC, marA, and sodA are the strongest downregulated ones. These are the treatment's clearest responders — upregulated genes may support protective/regulatory pathways, downregulated ones may mark processes suppressed by treatment.

**Figure 4: Scatter plot of control vs treated.**Most genes sit close to the y=x line, meaning treated and control expression are similar. A few genes (ompA, crp) sit well above it and others (emrB, tolC) sit well below it, visually confirming the up/down calls from the bar plot.

**Overall conclusion.** The treatment produces a targeted transcriptional
response rather than a uniform shift across the genome. Most genes show
little to no change, but a consistent subset shows clear upregulation or
downregulation across figures — these are the strongest candidate genes for
involvement in the cellular response to treatment.


## Author

[Ansa Aslam] — Module 1 Project, [05-08-2026]