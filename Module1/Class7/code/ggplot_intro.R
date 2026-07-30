# =============================================================
# ggplot_intro.R  —  Class 6: Data Visualization & Interpretation
# Topic: the GRAMMAR OF GRAPHICS (data + aes + geom), built up
#        slowly, ending in your first histogram and boxplot.
# -------------------------------------------------------------
# HOW TO RUN:
#   Open this file in RStudio.
#   Set the working directory to this code/ folder:
#     Session > Set Working Directory > To Source File Location
#   The data lives two folders up, in data/, so we use the
#   relative path "../../data/<file>".
#   Run line-by-line with Ctrl+Enter (Cmd+Enter on Mac).
# =============================================================


# -------------------------------------------------------------
# 1. LOAD THE TIDYVERSE  (ggplot2 lives inside it)
# -------------------------------------------------------------
# ggplot2 is the plotting package; dplyr/tidyr reshape the data;
# readr reads the CSV. All come with the tidyverse.
library(tidyverse)


# -------------------------------------------------------------
# 2. REBUILD DAY 5's TIDY, JOINED TABLE
# -------------------------------------------------------------
# Day 6 plots the SAME data Day 5 wrangled. The expression file is
# WIDE (one column per sample). ggplot wants LONG/TIDY data: one
# row per measurement. So we pivot_longer, then left_join the
# sample metadata so each count also knows its condition & batch.

expr <- read_csv("../../data/gene_expression.csv")   # wide: gene_id + 6 samples
meta <- read_csv("../../data/sample_metadata.csv")   # sample, condition, batch, rin

# pivot_longer: gather the 6 sample columns into 2 columns
#   sample = the old column name (control_1, treated_2, ...)
#   count  = the value that was in that cell
expr_long <- expr |>
  pivot_longer(
    cols      = -gene_id,        # everything EXCEPT gene_id becomes long
    names_to  = "sample",        # new column holding the old column names
    values_to = "count"          # new column holding the counts
  )

expr_long          # 120 rows = 20 genes x 6 samples

# left_join: glue each row's metadata on by the shared "sample" key
expr_tidy <- expr_long |>
  left_join(meta, by = "sample")

expr_tidy          # now every count carries its condition, batch, rin
# THIS tidy table is what every plot below maps onto.


# -------------------------------------------------------------
# 3. THE GRAMMAR OF GRAPHICS  —  the one big idea
# -------------------------------------------------------------
# Every ggplot is three pieces stacked with the "+" sign:
#
#   ggplot(DATA, aes(...)) + GEOM()
#    |        |               |
#    |        |               +-- the SHAPE that draws the data
#    |        |                   (geom_histogram, geom_boxplot, geom_point...)
#    |        +-- aes() = AESTHETIC MAP: which column -> x, y, colour, fill?
#    +-- the tidy data frame
#
# Read it as a sentence: "take this DATA, MAP these columns to
# x/y/colour, then DRAW it with this geom."
#
# Note: layers are joined with "+", NOT the pipe |>. (ggplot2
# predates the pipe; inside a plot we use "+".)


# --- 3a. The emptiest possible plot: data + aes, no geom ------
# This draws the axes but nothing on them — there is no geom yet
# to say HOW to draw the data. Useful to see the skeleton.
ggplot(expr_tidy, aes(x = count))
# An empty panel with a "count" x-axis. Add a geom to fill it.


# -------------------------------------------------------------
# 4. YOUR FIRST PLOT  —  a HISTOGRAM (a distribution)
# -------------------------------------------------------------
# 💡 A histogram answers "what values are common?" It chops the
# number line into bins and draws a bar for how many values fall
# in each bin. Perfect for ONE numeric column (here: count).

ggplot(expr_tidy, aes(x = count)) +
  geom_histogram(bins = 30)
# 🧬 Read it biologically: most counts pile up at the LOW end
# (a few hundred), with a thin tail stretching right to the
# high-expression genes. That right-skew is utterly typical of
# RNA-seq count data: many genes are quietly expressed, a few
# are loud. This shape is WHY we often log-transform counts.

# Same data, log10 x-axis — the skew straightens out:
ggplot(expr_tidy, aes(x = count)) +
  geom_histogram(bins = 30) +
  scale_x_log10()
# 🧬 On a log scale the lump becomes a more symmetric hump.
# Interpretation: expression spans orders of magnitude, so a log
# scale is the honest way to view and compare it.


# -------------------------------------------------------------
# 5. YOUR SECOND PLOT  —  a BOXPLOT (a group comparison)
# -------------------------------------------------------------
# 💡 A boxplot summarises a distribution as a box (the middle 50%
# of values), a line (the median), and whiskers (the spread).
# Put a CATEGORY on x and a NUMBER on y to compare groups.
# Here: does the count distribution differ control vs treated?

ggplot(expr_tidy, aes(x = condition, y = count)) +
  geom_boxplot()
# 🧬 Interpretation: the two boxes overlap heavily — OVERALL,
# treated and control samples have similar total expression
# (good: sequencing depth is comparable). The treatment effect
# is NOT a blanket shift in every gene; it lives in SPECIFIC
# genes. We hunt those down in plot_gallery.R and interpret.R.

# Add colour by condition so groups pop (fill = the box interior):
ggplot(expr_tidy, aes(x = condition, y = count, fill = condition)) +
  geom_boxplot()
# 💡 Notice: putting "fill = condition" INSIDE aes() ties the
# colour to the data. (A fixed colour like fill = "steelblue"
# goes OUTSIDE aes — see customize_publication.R.)


# -------------------------------------------------------------
# ✅ You can now: build the tidy/joined table, and read the
#    grammar of graphics (data + aes + geom). You made a
#    histogram (distribution) and a boxplot (group comparison).
#    NEXT: plot_gallery.R builds all four required plot types
#    (bar, scatter, histogram, boxplot) and interprets each.
# -------------------------------------------------------------
