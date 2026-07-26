# =============================================================
# summarise_group.R  —  Class 5: Data Wrangling & EDA
# Topic: group_by() + summarise() to compute descriptive
#        statistics (mean, sd, n) per CONDITION and per GENE.
# -------------------------------------------------------------
# HOW TO RUN:
#   Open this file in RStudio.
#   Set the working directory to this code/ folder:
#     Session > Set Working Directory > To Source File Location
#   Data path is "../../data/<file>".
# =============================================================

library(tidyverse)


# -------------------------------------------------------------
# 1. REBUILD the tidy, joined table (from reshape_join.R)
# -------------------------------------------------------------
expr <- read_csv("../../data/gene_expression.csv")
meta <- read_csv("../../data/sample_metadata.csv")

expr_joined <- expr |>
  pivot_longer(cols = -gene_id, names_to = "sample", values_to = "count") |>
  left_join(meta, by = "sample")

expr_joined          # 120 rows: gene_id, sample, count, condition, batch, rin


# -------------------------------------------------------------
# 2. THE BIG IDEA: group_by() + summarise()
# -------------------------------------------------------------
# group_by() does NOT change the data; it just tags rows into
# groups. summarise() then collapses EACH group to ONE row of
# summary numbers. Think of the Bash idiom "sort | uniq -c" from
# Class 1 — same spirit, but with real statistics.
#
# Useful summary functions: mean(), sd(), median(), min(), max(),
# n() (count of rows in the group), sum().


# -------------------------------------------------------------
# 3. SUMMARISE PER CONDITION  —  control vs treated overall
# -------------------------------------------------------------
# "On average, across ALL genes, do treated samples read higher?"

by_condition <- expr_joined |>
  group_by(condition) |>
  summarise(
    n_obs     = n(),              # how many gene-in-sample counts
    mean_count = mean(count),
    sd_count   = sd(count),
    median_count = median(count),
    .groups = "drop"             # ungroup after summarising (tidy habit)
  )

by_condition
# Expect 2 rows. n_obs = 60 each (20 genes x 3 replicates).
#   control: mean ~242.97
#   treated: mean ~273.17
# A small overall lift — but the ACTION is gene-by-gene (next).

# 💡 .groups = "drop" silences a message and returns a plain tibble.
#    Without it, summarise keeps the last grouping and warns you.


# -------------------------------------------------------------
# 4. SUMMARISE PER GENE  —  one row per gene
# -------------------------------------------------------------
# "For each gene, what is its mean and spread across all 6 samples?"

by_gene <- expr_joined |>
  group_by(gene_id) |>
  summarise(
    mean_count = mean(count),
    sd_count   = sd(count),
    min_count  = min(count),
    max_count  = max(count),
    .groups = "drop"
  ) |>
  arrange(desc(mean_count))      # most-expressed gene at the top

by_gene
# 20 rows (one per gene). soxS (~457) / crp / ftsZ sit near the top;
# dnaA (mean ~29.5) is the quietest gene.


# -------------------------------------------------------------
# 5. GROUP BY TWO THINGS  —  gene AND condition
# -------------------------------------------------------------
# This is the table that powers fold-change: each gene's mean in
# control vs its mean in treated. Grouping by two columns makes
# one summary row per (gene, condition) combination.

gene_condition <- expr_joined |>
  group_by(gene_id, condition) |>
  summarise(mean_count = mean(count), .groups = "drop")

gene_condition           # 20 genes x 2 conditions = 40 rows


# -------------------------------------------------------------
# 6. across()  —  apply the SAME summary to MANY columns
# -------------------------------------------------------------
# When you want, say, the mean of several numeric columns at once,
# across() saves repetition. Here we summarise rin by condition.
# (rin is the same value within a sample, so we take its mean.)

expr_joined |>
  group_by(condition) |>
  summarise(across(rin, list(mean = mean, sd = sd)), .groups = "drop")
# across(rin, ...) -> columns rin_mean, rin_sd per condition.
# With more numeric columns you'd write across(c(count, rin), mean).


# -------------------------------------------------------------
# 7. count()  —  the quick tally shortcut
# -------------------------------------------------------------
# count(x) is shorthand for group_by(x) |> summarise(n = n()).
# Great for "how many rows fall in each category?"

expr_joined |> count(condition)          # 60 control, 60 treated
expr_joined |> count(batch)              # how many obs per batch
expr_joined |> count(condition, batch)   # cross-tab of the two


# -------------------------------------------------------------
# 8. SAVE the per-gene summary table
# -------------------------------------------------------------
dir.create("../results", showWarnings = FALSE)
write_csv(by_gene, "../results/per_gene_summary.csv")


# -------------------------------------------------------------
# ✅ You can now: group_by() + summarise() to get mean / sd / n
#    per group, group by two variables, use across() and count().
#    NEXT: missing_data.R shows how to handle NA values safely.
# -------------------------------------------------------------
