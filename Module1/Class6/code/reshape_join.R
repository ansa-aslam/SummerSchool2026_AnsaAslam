# =============================================================
# reshape_join.R  —  Class 5: Data Wrangling & EDA
# Topic: read the WIDE expression matrix + the metadata, then
#        RESHAPE it to long/tidy form with pivot_longer(), and
#        JOIN the sample metadata onto it with left_join().
# -------------------------------------------------------------
# HOW TO RUN:
#   Open this file in RStudio.
#   Set the working directory to this code/ folder:
#     Session > Set Working Directory > To Source File Location
#   Data path is "../../data/<file>".
#
# This is the HEART of today: a wide matrix is hard to group and
# plot; a long/tidy table is easy. We learn to flip between them.
# =============================================================

library(tidyverse)   # loads dplyr, tidyr, readr (and more)


# -------------------------------------------------------------
# 1. READ BOTH FILES  (same data you met on Day 4)
# -------------------------------------------------------------
expr <- read_csv("../../data/gene_expression.csv")
meta <- read_csv("../../data/sample_metadata.csv")

expr   # 20 genes x 7 cols: gene_id + 6 sample columns (WIDE)
meta   # 6 rows: sample, condition, batch, rin


# -------------------------------------------------------------
# 2. WHY RESHAPE?  —  wide vs long/tidy
# -------------------------------------------------------------
# WIDE: one row per gene; each sample is its OWN column.
#   gene_id  control_1  control_2 ... treated_3
# Great for humans to read, but BAD for the computer: the sample
# name is hidden in the COLUMN HEADER, not in a column of its own.
# To group by condition or join with metadata we need the sample
# to be a VALUE in a column. That layout is called LONG / TIDY.
#
# TIDY rules (memorise): 1 row = 1 observation; 1 column = 1 variable.
# Here, one observation is "the count of ONE gene in ONE sample".


# -------------------------------------------------------------
# 3. pivot_longer()  —  WIDE  ->  LONG
# -------------------------------------------------------------
# We collapse the 6 sample columns into TWO new columns:
#   - "sample" holds the old column NAMES   (names_to)
#   - "count"  holds the old cell VALUES    (values_to)
# gene_id is NOT a sample column, so we leave it alone with -gene_id.

expr_long <- expr |>
  pivot_longer(
    cols      = -gene_id,     # everything EXCEPT gene_id gets pivoted
    names_to  = "sample",     # old column headers land here
    values_to = "count"       # the numbers land here
  )

expr_long
# 20 genes x 6 samples = 120 rows, 3 columns (gene_id, sample, count).
dim(expr_long)               # -> 120   3

# Equivalent ways to choose the columns (all give the same result):
#   cols = control_1:treated_3
#   cols = c(control_1, control_2, control_3, treated_1, treated_2, treated_3)
#   cols = starts_with(c("control", "treated"))


# -------------------------------------------------------------
# 4. pivot_wider()  —  LONG  ->  WIDE  (the inverse)
# -------------------------------------------------------------
# Good to see the round-trip: pivot_wider() rebuilds the matrix.
# names_from = which column becomes the new headers,
# values_from = which column fills the cells.

expr_back <- expr_long |>
  pivot_wider(names_from = sample, values_from = count)

expr_back        # identical shape to the original `expr` (20 x 7)
# Knowing BOTH directions means you can always get the shape a
# given tool wants. ggplot2 (Day 6) wants LONG; a heatmap wants WIDE.


# -------------------------------------------------------------
# 5. left_join()  —  attach the metadata
# -------------------------------------------------------------
# expr_long knows the sample NAME but not its condition/batch/RIN.
# meta knows all of that, keyed by the "sample" column. A JOIN
# matches rows by a shared key column and glues the columns together.
#
# left_join(x, y) keeps EVERY row of x (the left table) and adds y's
# columns where the key matches. by = "sample" says "match on sample".

expr_joined <- expr_long |>
  left_join(meta, by = "sample")

expr_joined
# Still 120 rows (the join added columns, not rows), now with
# condition, batch and rin attached to every gene-in-sample count.
dim(expr_joined)             # -> 120   6

# ⚠️ Always re-check the row count after a join. If rows EXPLODE,
#    your key was not unique on one side. Here meta has one row per
#    sample, so each of the 120 rows matches exactly one meta row.


# -------------------------------------------------------------
# 6. SANITY CHECKS  —  did the join do what we think?
# -------------------------------------------------------------
# Every count row should now carry a condition label:
expr_joined |> count(condition)      # -> control 60, treated 60

# No missing keys? (a join miss shows up as NA in the joined columns)
sum(is.na(expr_joined$condition))    # -> 0  (every sample matched)

# Peek at one gene across all 6 samples, now fully annotated:
expr_joined |> filter(gene_id == "recA")


# -------------------------------------------------------------
# 7. SAVE the tidy, joined table for the next scripts
# -------------------------------------------------------------
dir.create("../results", showWarnings = FALSE)
write_csv(expr_joined, "../results/expr_joined_long.csv")
# summarise_group.R and eda_foldchange.R rebuild this same table,
# so you can run any script independently — but it's handy on disk.


# -------------------------------------------------------------
# ✅ You can now: reshape WIDE <-> LONG with pivot_longer /
#    pivot_wider, and attach metadata with left_join(by="sample").
#    NEXT: summarise_group.R groups this tidy table and computes
#    descriptive statistics.
# -------------------------------------------------------------
