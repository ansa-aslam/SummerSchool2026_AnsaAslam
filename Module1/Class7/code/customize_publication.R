# =============================================================
# customize_publication.R  —  Class 6: Data Visualization
# Topic: turn a rough plot into a PUBLICATION-QUALITY figure —
#        titles & labels, themes, custom colours, faceting, and
#        saving at 300 dpi with ggsave().
# -------------------------------------------------------------
# HOW TO RUN:
#   Open this file in RStudio.
#   Set the working directory to this code/ folder:
#     Session > Set Working Directory > To Source File Location
#   Data path is "../../data/<file>". Figures are written into a
#   plots/ subfolder next to this script (created automatically).
# =============================================================

library(tidyverse)
dir.create("plots", showWarnings = FALSE)


# -------------------------------------------------------------
# 1. REBUILD THE TIDY TABLE + a per-gene summary
# -------------------------------------------------------------
expr <- read_csv("../../data/gene_expression.csv")
meta <- read_csv("../../data/sample_metadata.csv")

expr_tidy <- expr |>
  pivot_longer(cols = -gene_id, names_to = "sample", values_to = "count") |>
  left_join(meta, by = "sample")

gene_summary <- expr |>
  mutate(
    mean_control = (control_1 + control_2 + control_3) / 3,
    mean_treated = (treated_1 + treated_2 + treated_3) / 3,
    log2FC       = log2((mean_treated + 1) / (mean_control + 1))
  ) |>
  select(gene_id, mean_control, mean_treated, log2FC)


# -------------------------------------------------------------
# 2. START ROUGH, THEN POLISH ONE STEP AT A TIME
# -------------------------------------------------------------
# 💡 The workflow: get the data/aes/geom right FIRST, then layer
# on polish. We build a base plot and improve it line by line so
# you can see exactly what each customisation does.

# The base: counts by condition, coloured by condition.
base <- ggplot(expr_tidy, aes(x = condition, y = count, fill = condition)) +
  geom_boxplot()
base   # functional but plain — grey background, code-y axis labels


# --- 2a. labs(): human-readable title, axes, legend, caption ----
# 💡 NEVER ship a figure with raw column names as axis labels.
# labs() is where a plot becomes communication.
p <- base +
  labs(
    title    = "Treatment does not shift overall expression",
    subtitle = "Per-sample raw counts, 20 genes x 6 samples",
    x = "Condition",
    y = "Raw count",
    fill = "Condition",
    caption = "Teaching data — OmicsNexus Module 1"
  )
p


# --- 2b. theme_*(): the overall look ---------------------------
# 💡 A "theme" controls the non-data ink: background, grid lines,
# fonts. The defaults look like a draft; theme_bw() / theme_minimal()
# look like a paper. Compare them:
p + theme_bw()        # white background, thin border + gridlines
p + theme_minimal()   # white background, no border, faint grid
p + theme_classic()   # white background, axis lines only (very clean)

# We'll commit to theme_bw() and bump the base font size up so the
# figure stays legible when shrunk into a manuscript column.
p <- p + theme_bw(base_size = 13)
p


# --- 2c. scale_fill_manual(): choose your OWN colours ----------
# 💡 The default colours are fine, but journals (and colour-blind
# readers) often want specific, distinguishable hues. Map each
# condition to a chosen colour by NAME. The names must match the
# values in the data ("control", "treated").
condition_colours <- c(control = "#4C72B0",   # a calm blue
                        treated = "#DD8452")   # a warm orange

p_final <- p + scale_fill_manual(values = condition_colours)
p_final
# 🧬 INTERPRETATION (unchanged by styling!): the boxes still
# overlap — styling makes the message CLEARER, never different.
# Honest visualisation: polish communication, not conclusions.

# Save this finished figure at publication resolution.
ggsave("plots/pub_boxplot_condition.png", p_final,
       width = 6, height = 4, dpi = 300)


# -------------------------------------------------------------
# 3. FACETING  —  "small multiples", one mini-plot per group
# -------------------------------------------------------------
# 💡 facet_wrap(~column) splits ONE plot into a grid of little
# plots, one per category. It is the most powerful idea in this
# whole class for biological data: it lets you compare a pattern
# across many genes at once, on a shared scale.

# Pick a handful of interesting genes: 3 strong up, 3 strong down.
genes_of_interest <- c("crp", "ompA", "rpoB",     # up in treated
                       "emrB", "tolC", "dnaA")    # down in treated

facet_data <- expr_tidy |> filter(gene_id %in% genes_of_interest)

facet_plot <- ggplot(facet_data, aes(x = condition, y = count, fill = condition)) +
  geom_boxplot() +
  facet_wrap(~ gene_id) +              # one panel per gene
  scale_fill_manual(values = condition_colours) +
  labs(
    title = "Per-gene treatment response",
    subtitle = "Top row up-regulated, bottom row down-regulated in treated",
    x = "Condition", y = "Raw count", fill = "Condition"
  ) +
  theme_bw(base_size = 12)

facet_plot
ggsave("plots/pub_facet_genes.png", facet_plot,
       width = 7, height = 5, dpi = 300)
# 🧬 INTERPRETATION: NOW the biology leaps out. crp/ompA/rpoB
# panels show treated boxes sitting clearly ABOVE control; emrB/
# tolC/dnaA show treated boxes clearly BELOW. Faceting turned a
# muddy whole-dataset boxplot into six crisp, gene-level verdicts.
# This is exactly the figure you'd put in a results section.

# 🚀 Go further: facet by batch as a QC small-multiple. If the
# treated-vs-control gap looks the same in both batches, the
# effect is biological, not a batch artefact.
facet_batch <- facet_plot + facet_grid(batch ~ gene_id)
facet_batch
ggsave("plots/pub_facet_gene_by_batch.png", facet_batch,
       width = 9, height = 5, dpi = 300)


# -------------------------------------------------------------
# 4. ggsave()  —  saving figures the right way
# -------------------------------------------------------------
# 💡 ggsave() saves the LAST plot (or one you name) to a file.
# Key arguments:
#   filename : extension sets the format (.png raster, .pdf vector)
#   plot     : which plot object to save (defaults to the last one)
#   width/height : in INCHES (set the real printed size here)
#   dpi      : dots per inch. 300 = print/publication quality.
#
# Tip: set width/height to the figure's FINAL size in the document.
# Designing at final size keeps text proportionate — don't draw
# big then shrink, or the fonts turn tiny.

# PNG for slides/web, PDF (vector, infinitely sharp) for the paper:
ggsave("plots/pub_facet_genes_300dpi.png", facet_plot,
       width = 7, height = 5, dpi = 300)
ggsave("plots/pub_facet_genes.pdf", facet_plot,
       width = 7, height = 5)            # PDF is vector; dpi not needed

# ⚠️ Common mistake: calling ggsave() with no plot saves whatever
# was drawn LAST in the Plots pane — which may not be the figure
# you meant. Pass the plot object explicitly (as above) to be safe.


# -------------------------------------------------------------
# ✅ You can now: label with labs(), restyle with theme_*(),
#    recolour with scale_fill_manual(), break a plot into
#    small-multiples with facet_wrap()/facet_grid(), and export
#    at 300 dpi with ggsave(). NEXT: interpret.R answers a real
#    biological question end-to-end.
# -------------------------------------------------------------
