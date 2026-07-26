# Capstone Project — Integrated Computational Foundations
## End-to-End Bash → Python → R Biological Data Workflow
**Project Type: · Individual · Submit it before 1st August 2026.**

This is the finale of Module 1. You will combine **everything** — Linux, Python, and R — into one reproducible workflow that takes raw biological data all the way to interpreted, publication-quality figures, and you will **present your findings**.

> 🎯 **Goal:** independently complete an end-to-end data-handling and visualization workflow spanning **Linux, Python, and R**, then present the workflow and biological conclusions in a short talk.

---

## The story you are telling
You have a small gene-expression experiment: cells in two conditions: **`control`** vs **`treated`** - measured across replicates, plus raw sequence/annotation files. Your job: process the data, find which genes respond to the treatment, visualize it, and explain what it means.

## Datasets (in  `Module1/data/`)
- `gene_expression.csv` — 20 genes × 6 samples (3 control, 3 treated) raw counts
- `sample_metadata.csv` — sample, condition, batch, RIN
- `genes.fasta`, `annotations.gff3`, `sample_reads.fastq`, `variants.vcf` — supporting sequence/feature/variant files
*(Your instructor may give you a fresh dataset of the same shape — the workflow is identical.)*

---

## Required workflow (7 steps)

### Step 1 — Organize & preprocess with Linux/Bash
Build a clean set of project directories (`raw/ scripts/ results/ figures/ README.md`) with a master directory. Download the raw data from Module 1 directoy on the GitHub repo and move it to your working directory. Write a Bash script that sets this up and reports a summary of the inputs.

### Step 2 — Parse & extract with Python
Use Python to parse the supporting files and produce summary tables/text, e.g.:
- FASTA: sequence counts + GC%; FASTQ: read count + mean quality + QC pass count;
- GFF3: feature counts; (optional) VCF: variant counts.
Save outputs into `results/`.

### Step 3 — Import the processed data into R
In RStudio, read `gene_expression.csv` and `sample_metadata.csv` (and any Python-produced summary you want) with `readr::read_csv`.

### Step 4 — Wrangle & explore in R
- Reshape the wide expression matrix to **tidy/long** form (`pivot_longer`).
- **Join** with the metadata on `sample`.
- Compute grouped summaries (Find the mean and standard deviation per condition and per gene).
- Compute a **log2 fold-change** (treated vs control) per gene and rank the top responders.

### Step 5 — Visualize with ggplot2
Produce at least **four** publication-quality figures, such as:
- a **boxplot** of expression by condition,
- a **histogram** of a distribution (e.g. counts or fold-changes),
- a **bar plot** of mean expression for the top responding genes,
- a **scatter plot** of mean control vs mean treated (with a y = x reference line, top genes labelled).
Save them to `figures/` with `ggsave()` at 300 dpi.

### Step 6 — Interpret in biological context
For each figure, write 1–2 sentences: *what does it show, and what does it mean biologically?* Identify which genes respond to treatment and whether the effect looks real (consistent across replicates).

### Step 7 — Present
Prepare a **5–7 slides** presentation (slides) summarizing your workflow and findings. Use the template in `presentation_template.md`.

---

## Deliverables (submit the whole project folder + slides)
- [ ] **Bash/Python scripts** that organize and preprocess the data (`scripts/`)
- [ ] **R script or R Markdown notebook** with all wrangling + visualization code
- [ ] **A set of generated plots** (`figures/`, ≥4, publication quality)
- [ ] **README.md** documenting how to reproduce the workflow end to end
- [ ] **Final presentation** (5–7 slides) summarizing workflow and findings

---

## Grading rubric (100 points)

| Criterion | Pts | What we look for |
|---|---|---|
| **Linux/Bash preprocessing** | 12 | Clean project structure; reproducible setup script; raw data preserved |
| **Python parsing/extraction** | 15 | Correct parsing; useful summaries saved to `results/` |
| **Data import & integration into R** | 10 | Data read correctly; pieces connect across languages |
| **Wrangling (reshape + join + summarise)** | 18 | Correct tidy reshape, join on sample, grouped summaries, fold-change |
| **Visualization quality** | 18 | ≥4 correct, well-chosen plots; labelled, themed, saved at 300 dpi |
| **Biological interpretation** | 12 | Sound, specific conclusions tied to the figures |
| **Reproducibility & documentation** | 8 | README lets someone re-run it; comments; sensible naming |
| **Presentation** | 7 | Clear story: question → workflow → findings → conclusion, on time |

**Total: 100.** *(Late/partial workflows are graded on what runs — a smaller workflow that fully works beats a big one that doesn't.)*

---

## Tips for success
- **Build incrementally and test each stage** before moving on — exactly like the daily classes.
- When a plot surprises you, that's the interesting part — investigate and explain it.
- A clear, honest 5-minute story beats a rushed tour of 20 slides.
- **You can use the AI, for resolving any issue!**

> 🧬 **Remember the through-line of the whole module:** *raw files → Linux organizes → Python parses → R analyses & visualizes → you interpret → you present.* That is the bioinformatics workflow you'll use for the rest of your career.
