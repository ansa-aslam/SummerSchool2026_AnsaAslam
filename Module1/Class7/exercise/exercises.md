# Class 6 — Exercises
**Data Visualization & Interpretation (R / ggplot2)**

Work in RStudio. Open a new script `class6_answers.R` in the `code/` folder and **Session → Set Working Directory → To Source File Location**. Use these starter lines at the top of your script:
```r
library(tidyverse)
dir.create("plots", showWarnings = FALSE)

expr <- read_csv("../../data/gene_expression.csv")
meta <- read_csv("../../data/sample_metadata.csv")

expr_tidy <- expr |>
  pivot_longer(cols = -gene_id, names_to = "sample", values_to = "count") |>
  left_join(meta, by = "sample")

gene_summary <- expr |>
  mutate(mean_control = (control_1 + control_2 + control_3) / 3,
         mean_treated = (treated_1 + treated_2 + treated_3) / 3,
         log2FC       = log2((mean_treated + 1) / (mean_control + 1))) |>
  select(gene_id, mean_control, mean_treated, log2FC)
```

> **For every plotting question, also write a one-sentence biological interpretation** as a `#` comment under your code. The interpretation is graded as much as the code. Solutions are in `solutions.md` — try first, then check.

---

## Part A — Grammar of graphics (warm-up)
1. Without running it, write down the three pieces of any ggplot and what each does. Then write the *shortest* ggplot line that draws axes for `count` but no data.
2. Make a histogram of `count` with 20 bins. Add a one-sentence interpretation of the distribution's shape.
3. Take your histogram from Q2 and add `scale_x_log10()`. In one sentence, say what changed and why a log scale helps here.

## Part B — Distributions & group comparisons
4. Make a boxplot of `count` by `condition`, filled by `condition`. Interpret: do the groups differ overall?
5. Make a boxplot of `count` by `batch`. Interpret: is there a worrying batch effect?
6. Make a histogram of `count` faceted by `condition` (`facet_wrap(~ condition)`). Interpret whether the two conditions have similar overall distributions.
7. The `rin` values live in `meta`. Make a bar plot (`geom_col`) of `rin` per `sample`. Interpret: do all samples meet a quality bar of RIN ≥ 7?

## Part C — Bar & scatter plots (the response story)
8. Using `gene_summary`, make a bar plot of `log2FC` per gene, sorted with `reorder()` and flipped with `coord_flip()`. Colour by whether `log2FC > 0`. Interpret: name the top 3 up- and top 3 down-regulated genes.
9. Make a scatter plot of `mean_control` (x) vs `mean_treated` (y), one point per gene. Add the `y = x` line with `geom_abline(slope = 1, intercept = 0)`. Interpret what a point above vs below the line means.
10. Extend Q9: colour points by `log2FC > 0`, and label only genes with `abs(log2FC) > 1` using `geom_text()`. Interpret which genes are the clear responders.
11. Make a bar plot of the **mean overall count** of the 5 most highly expressed genes. Interpret: are the most-expressed genes the same as the most-responsive ones? (Compare with Q8.)

## Part D — Customize for publication
12. Take your boxplot from Q4 and add: a `labs()` with a real title and axis labels, `theme_bw()`, and `scale_fill_manual()` with two colours of your choice. Save it with `ggsave()` at `dpi = 300` into `plots/`.
13. Build a faceted boxplot (`facet_wrap(~ gene_id)`) for these six genes: `crp, ompA, rpoB, emrB, tolC, dnaA`. Theme it and save at 300 dpi. Interpret what the facets show about each gene's response.
14. Re-save your Q13 figure as a **PDF** as well. In one sentence, say why a journal might prefer the PDF (vector) version.

## Part E — Interpretation focus
15. Look at your scatter plot (Q10). In 2–3 sentences, answer the question *"which genes respond to treatment, and in which direction?"* as you would in a paper's results section.
16. A colleague shows you a boxplot of `count` by `condition` (Q4) and concludes "the treatment had no effect." Using your other plots, explain in 2 sentences why that conclusion is wrong.

## 🚀 Challenge (optional)
17. **Volcano-style plot.** Real volcano plots put `log2FC` on x and statistical significance (`-log10(p)`) on y. We have no p-values, so *simulate* a stand-in: add a column `signif = abs(log2FC)` (bigger change = "more significant" for this toy). Plot `log2FC` (x) vs `signif` (y) with `geom_point()`, colour points by `response` (`Up` / `Down` / `No change` using `case_when` with a |log2FC|>1 cutoff), label the responders, and theme it for publication. Interpret which "corner" of the plot holds the most interesting genes.
18. **Replicate consistency.** For the six responder genes, plot individual replicate counts as points (`geom_point` with a little `position_jitter`) faceted by gene with `scales = "free_y"`, coloured by condition. Interpret: are the responses driven by all three replicates, or could a single outlier be fooling us?

---
### Submit
Save `class6_answers.R` and your `plots/` folder. Make sure **every plotting answer has an interpretation comment**. These feed directly into the Week 2 capstone, where you'll visualize your own pipeline's output.
