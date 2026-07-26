# =============================================================
# plot_gallery.R  —  Class 6: Data Visualization & Interpretation
# Topic: the FOUR core plot types on the expression data —
#        histogram, boxplot, bar plot, scatter plot — each one
#        SAVED to a plots/ folder and INTERPRETED biologically.
# -------------------------------------------------------------
# HOW TO RUN:
#   Open this file in RStudio.
#   Set the working directory to this code/ folder:
#     Session > Set Working Directory > To Source File Location
#   Data path is "../../data/<file>". Plots are written into a
#   plots/ subfolder next to this script (created automatically).
# =============================================================

library(tidyverse)

# Make a folder for the figures we save (no error if it exists).
dir.create("plots", showWarnings = FALSE)


# -------------------------------------------------------------
# 1. REBUILD THE TIDY, JOINED TABLE (same as ggplot_intro.R)
# -------------------------------------------------------------
expr <- read_csv("../../data/gene_expression.csv")
meta <- read_csv("../../data/sample_metadata.csv")

expr_tidy <- expr |>
  pivot_longer(cols = -gene_id, names_to = "sample", values_to = "count") |>
  left_join(meta, by = "sample")

# We also build a PER-GENE summary table (one row per gene) for the
# bar and scatter plots. mean_control / mean_treated are the average
# of the 3 control / 3 treated counts; log2FC is the classic
# treated-vs-control fold change (Day 4/5 already met this).
gene_summary <- expr |>
  mutate(
    mean_control = (control_1 + control_2 + control_3) / 3,
    mean_treated = (treated_1 + treated_2 + treated_3) / 3,
    log2FC       = log2((mean_treated + 1) / (mean_control + 1))
  ) |>
  select(gene_id, mean_control, mean_treated, log2FC)

gene_summary


# =============================================================
# PLOT 1 of 4 — HISTOGRAM  (a distribution)
# =============================================================
# Question: what does the spread of raw counts look like?
hist_plot <- ggplot(expr_tidy, aes(x = count)) +
  geom_histogram(bins = 25, fill = "steelblue", colour = "white") +
  labs(
    title = "Distribution of raw expression counts",
    x = "Raw count", y = "Number of gene-sample measurements"
  )

hist_plot
ggsave("plots/01_histogram_counts.png", hist_plot,
       width = 6, height = 4, dpi = 300)
# 🧬 INTERPRETATION: counts are right-skewed — a big pile of
# low/medium values and a thin tail of highly expressed genes.
# This is the signature shape of expression data and the reason
# we reach for log scales and rank-based comparisons.


# =============================================================
# PLOT 2 of 4 — BOXPLOT  (a group comparison)
# =============================================================
# Question: do control and treated samples differ overall? And
# does the BATCH (A/B) — a technical, non-biological grouping —
# create an unwanted shift?
box_condition <- ggplot(expr_tidy, aes(x = condition, y = count, fill = condition)) +
  geom_boxplot() +
  labs(
    title = "Counts by condition",
    x = "Condition", y = "Raw count"
  )

box_condition
ggsave("plots/02_boxplot_condition.png", box_condition,
       width = 6, height = 4, dpi = 300)
# 🧬 INTERPRETATION: the two boxes overlap heavily. The treatment
# does NOT raise or lower expression across the board — overall
# library sizes are comparable. The real signal is gene-specific,
# which the bar and scatter plots below expose.

# Same idea, grouped by batch (a quality-control check):
box_batch <- ggplot(expr_tidy, aes(x = batch, y = count, fill = batch)) +
  geom_boxplot() +
  labs(title = "Counts by batch (QC check)", x = "Batch", y = "Raw count")

box_batch
ggsave("plots/02b_boxplot_batch.png", box_batch,
       width = 6, height = 4, dpi = 300)
# 🧬 INTERPRETATION: batch A and B look similar -> no obvious
# "batch effect" swamping the biology. Always run this check:
# if batches differed wildly, your "treatment effect" might just
# be a machine/day artefact.


# =============================================================
# PLOT 3 of 4 — BAR PLOT  (a value per category)
# =============================================================
# Question: which genes are most strongly UP in treated? A bar
# plot of log2FC, one bar per gene, ranked, makes this obvious.
#
# 💡 geom_col() draws a bar whose HEIGHT is a value you supply
# (here log2FC). (geom_bar() instead COUNTS rows — we don't want
# counting here, we already have the height.)
# reorder() sorts the bars by log2FC so the plot tells a story.

bar_fc <- ggplot(gene_summary,
                 aes(x = reorder(gene_id, log2FC), y = log2FC,
                     fill = log2FC > 0)) +
  geom_col() +
  coord_flip() +                       # flip so gene names read left-to-right
  labs(
    title = "Treatment response per gene (log2 fold-change)",
    x = "Gene", y = "log2(treated / control)",
    fill = "Up in treated?"
  )

bar_fc
ggsave("plots/03_barplot_log2fc.png", bar_fc,
       width = 6, height = 5, dpi = 300)
# 🧬 INTERPRETATION: bars to the RIGHT (positive) are UP-regulated
# in treatment — crp, ompA, rpoB lead. Bars to the LEFT (negative)
# are DOWN-regulated — emrB, dnaA, tolC fall hardest. Genes near
# zero barely respond. This single plot ranks every gene's
# response and is the heart of a differential-expression story.

# A simpler bar plot for beginners: mean count of the 6 highest
# genes (geom_col of a value per gene).
top6 <- gene_summary |>
  mutate(mean_overall = (mean_control + mean_treated) / 2) |>
  arrange(desc(mean_overall)) |>
  slice_head(n = 6)

bar_top6 <- ggplot(top6, aes(x = reorder(gene_id, mean_overall),
                             y = mean_overall)) +
  geom_col(fill = "darkgreen") +
  coord_flip() +
  labs(title = "Six most highly expressed genes",
       x = "Gene", y = "Mean count (all samples)")

bar_top6
ggsave("plots/03b_barplot_top6.png", bar_top6,
       width = 6, height = 4, dpi = 300)
# 🧬 INTERPRETATION: these are the "loudest" genes overall. High
# expression alone does NOT mean treatment-responsive — note many
# of these (soxS, ftsZ, fur) had near-zero log2FC above. Abundance
# and responsiveness are different questions; never conflate them.


# =============================================================
# PLOT 4 of 4 — SCATTER PLOT  (relationship between two numbers)
# =============================================================
# Question: for each gene, how does its control mean compare to
# its treated mean? Plot mean_control (x) vs mean_treated (y),
# one point per gene, and draw the y = x "no change" line.
#
# 💡 Points ON the line  -> unchanged by treatment.
#    Points ABOVE the line -> higher in treated (up-regulated).
#    Points BELOW the line -> lower in treated (down-regulated).

# Label only the strong responders so the plot isn't cluttered:
responders <- gene_summary |> filter(abs(log2FC) > 1)

scatter_plot <- ggplot(gene_summary,
                       aes(x = mean_control, y = mean_treated)) +
  geom_point(aes(colour = log2FC > 0), size = 3) +
  geom_abline(slope = 1, intercept = 0,           # the y = x line
              linetype = "dashed", colour = "grey40") +
  geom_text(data = responders, aes(label = gene_id),
            vjust = -0.8, size = 3) +              # name the responders
  labs(
    title = "Mean expression: treated vs control",
    subtitle = "Dashed line = no change (y = x); labelled genes respond strongly",
    x = "Mean count (control)", y = "Mean count (treated)",
    colour = "Up in treated?"
  )

scatter_plot
ggsave("plots/04_scatter_control_vs_treated.png", scatter_plot,
       width = 6.5, height = 5, dpi = 300)
# 🧬 INTERPRETATION: most points hug the dashed line (unchanged),
# confirming the boxplot's message that treatment is gene-specific.
# The clear responders sit far off the line: crp, ompA, rpoB float
# ABOVE (up-regulated); emrB, tolC, dnaA sink BELOW (down-
# regulated). This scatter is the visual definition of "which
# genes respond to treatment?".


# -------------------------------------------------------------
# ✅ You built and SAVED all four core plot types, and read each
#    one biologically. Check the plots/ folder for five PNGs.
#    NEXT: customize_publication.R makes them publication-quality
#    (themes, labels, colours, faceting, 300 dpi).
# -------------------------------------------------------------
