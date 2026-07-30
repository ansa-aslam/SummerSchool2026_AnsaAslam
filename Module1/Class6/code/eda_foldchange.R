# =============================================================
# eda_foldchange.R  —  Class 5: Data Wrangling & EDA
# Topic: the analytical PAYOFF. From the tidy table, compute each
#        gene's mean in control vs treated, the log2 fold-change,
#        and SORT to find the genes that respond to treatment.
# -------------------------------------------------------------
# HOW TO RUN:
#   Open this file in RStudio.
#   Set the working directory to this code/ folder:
#     Session > Set Working Directory > To Source File Location
#   Data path is "../../data/<file>".
#
# 🧬 THE QUESTION we are answering all day:
#    "Which genes turn UP or DOWN when cells are treated?"
# =============================================================

library(tidyverse)


# -------------------------------------------------------------
# 1. REBUILD the tidy, joined table
# -------------------------------------------------------------
expr <- read_csv("../../data/gene_expression.csv")
meta <- read_csv("../../data/sample_metadata.csv")

expr_joined <- expr |>
  pivot_longer(cols = -gene_id, names_to = "sample", values_to = "count") |>
  left_join(meta, by = "sample")


# -------------------------------------------------------------
# 2. PER-GENE means PER CONDITION  (long -> 40 rows)
# -------------------------------------------------------------
gene_means_long <- expr_joined |>
  group_by(gene_id, condition) |>
  summarise(mean_count = mean(count), .groups = "drop")

gene_means_long      # 20 genes x 2 conditions = 40 rows


# -------------------------------------------------------------
# 3. RESHAPE to one row per gene: a control column AND a treated column
# -------------------------------------------------------------
# To compare the two conditions side by side we want them as TWO
# columns. pivot_wider() turns the condition labels into headers.

gene_means <- gene_means_long |>
  pivot_wider(names_from = condition, values_from = mean_count)

gene_means           # gene_id | control | treated   (20 rows)
# This is the "wide for comparison" trick: long is great for
# grouping; wide is great for comparing two groups in arithmetic.


# -------------------------------------------------------------
# 4. log2 FOLD-CHANGE  —  the standard "how much did it change?" metric
# -------------------------------------------------------------
# fold-change = treated / control.
# log2 of it makes the scale symmetric and readable:
#   +1  = doubled (2x UP)        -1 = halved (2x DOWN)
#   +2  = 4x up                  -2 = 4x down       0 = no change
# We add 1 to numerator and denominator ("+1 pseudocount") so we
# never divide by zero and tiny counts don't blow up.

fold_changes <- gene_means |>
  mutate(
    log2FC = log2((treated + 1) / (control + 1)),
    direction = if_else(log2FC > 0, "up", "down")
  ) |>
  arrange(desc(log2FC))        # biggest UP-regulation at the top

print(fold_changes, n = 20)    # show ALL 20 genes
# Top responders UP (positive log2FC, ~):
#   crp  +1.92   ompA +1.64   rpoB +1.62   lacZ +0.89   recA +0.88
# Strongest DOWN (negative log2FC, ~):
#   emrB -2.29   dnaA -1.75   tolC -1.74   marA -0.72   sodA -0.65
# This is the real biological signal the dataset was built to carry.


# -------------------------------------------------------------
# 5. EDA: which genes "respond most"?  (rank by SIZE of change)
# -------------------------------------------------------------
# A responder can go up OR down, so rank by the ABSOLUTE log2FC.
# abs() removes the sign; we keep the sign in `direction` for reading.

top_responders <- fold_changes |>
  mutate(abs_log2FC = abs(log2FC)) |>
  arrange(desc(abs_log2FC)) |>
  slice_head(n = 6)            # the 6 most-changed genes

top_responders |> select(gene_id, control, treated, log2FC, direction)
# Expect (largest absolute change first, ~):
#   emrB (down), crp (up), dnaA (down), tolC (down), ompA (up), rpoB (up)


# -------------------------------------------------------------
# 6. A SIMPLE THRESHOLD  —  call genes "differentially expressed"
# -------------------------------------------------------------
# A common first pass: |log2FC| >= 1 means "at least a 2-fold change".
# (Real DE analysis also needs a p-value — that's a later course. Today
#  we just rank and threshold to build intuition.)

de_genes <- fold_changes |>
  filter(abs(log2FC) >= 1) |>
  arrange(desc(log2FC))

de_genes |> select(gene_id, control, treated, log2FC, direction)
# 6 genes clear the 2-fold bar (|log2FC| >= 1):
#   UP:   crp, ompA, rpoB
#   DOWN: tolC, dnaA, emrB
nrow(de_genes)               # -> 6  (genes passing |log2FC| >= 1)


# -------------------------------------------------------------
# 7. QUICK EDA SUMMARIES  (no plots yet — that is Day 6)
# -------------------------------------------------------------
# How many genes go up vs down overall?
fold_changes |> count(direction)

# Distribution of fold-changes at a glance:
summary(fold_changes$log2FC)          # min / median / max log2FC

# The whole tibble is small enough to eyeball — but on big data these
# ranked tables ARE your exploratory analysis: sort, threshold, count.


# -------------------------------------------------------------
# 8. SAVE the results for Day 6 (we will PLOT these tomorrow)
# -------------------------------------------------------------
dir.create("../results", showWarnings = FALSE)
write_csv(fold_changes, "../results/fold_changes.csv")
write_csv(de_genes,     "../results/de_genes.csv")


# -------------------------------------------------------------
# ✅ You can now: turn a tidy table into a per-gene comparison,
#    compute log2 fold-change, and rank/threshold to find the genes
#    that respond to treatment. That is exploratory data analysis.
#    NEXT (Day 6): visualise these with ggplot2.
# -------------------------------------------------------------
