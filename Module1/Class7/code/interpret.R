# =============================================================
# interpret.R  —  Class 6: Data Visualization & Interpretation
# Topic: a short, GUIDED analysis that answers ONE biological
#        question with plots — "Which genes respond to treatment?"
#        Every plot ends with: what does this mean biologically?
# -------------------------------------------------------------
# HOW TO RUN:
#   Open this file in RStudio.
#   Set the working directory to this code/ folder:
#     Session > Set Working Directory > To Source File Location
#   Data path is "../../data/<file>". Plots are saved to plots/.
# =============================================================

library(tidyverse)
dir.create("plots", showWarnings = FALSE)


# -------------------------------------------------------------
# THE QUESTION:  Which genes respond to the treatment, and how?
# -------------------------------------------------------------
# We'll answer it in three figures, each building on the last:
#   (1) RANK every gene by fold-change           -> who responds?
#   (2) ZOOM into the top responders gene-by-gene -> is it real/consistent?
#   (3) A volcano-style MAP of the whole dataset  -> the big picture.


# -------------------------------------------------------------
# 0. PREP: tidy table + per-gene fold-change summary
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
  # a simple "responder?" flag: |log2FC| > 1 means at least a
  # doubling or halving of expression in treated vs control.
  mutate(response = case_when(
    log2FC >  1 ~ "Up in treated",
    log2FC < -1 ~ "Down in treated",
    TRUE        ~ "No change"
  )) |>
  select(gene_id, mean_control, mean_treated, log2FC, response)

gene_summary |> arrange(desc(log2FC))   # eyeball the ranking first


# -------------------------------------------------------------
# FIGURE 1 — Rank every gene by fold-change (a bar plot)
# -------------------------------------------------------------
fig1 <- ggplot(gene_summary,
               aes(x = reorder(gene_id, log2FC), y = log2FC, fill = response)) +
  geom_col() +
  coord_flip() +
  geom_hline(yintercept = c(-1, 1), linetype = "dashed", colour = "grey50") +
  scale_fill_manual(values = c("Up in treated"   = "#C44E52",
                               "Down in treated" = "#4C72B0",
                               "No change"        = "grey75")) +
  labs(
    title = "Which genes respond to treatment?",
    subtitle = "Dashed lines = 2-fold change threshold",
    x = "Gene", y = "log2(treated / control)", fill = "Response"
  ) +
  theme_bw(base_size = 12)

fig1
ggsave("plots/interpret_1_ranked_log2fc.png", fig1,
       width = 6.5, height = 5, dpi = 300)
# 🧬 INTERPRETATION: three genes clear the +1 line (crp, ompA,
# rpoB = UP at least 2-fold in treated); three clear the -1 line
# (emrB, dnaA, tolC = DOWN at least 2-fold). The rest sit between
# the dashed lines: essentially unresponsive. ANSWER (part 1):
# the treatment has a focused effect on ~6 of 20 genes, not a
# global one.


# -------------------------------------------------------------
# FIGURE 2 — Zoom into the responders (faceted, replicate-level)
# -------------------------------------------------------------
# A fold-change can be driven by one fluky replicate. Plot the
# INDIVIDUAL replicate counts per condition for the responders to
# check the effect is consistent, not a single outlier.
responders <- gene_summary |> filter(response != "No change") |> pull(gene_id)

resp_data <- expr_tidy |> filter(gene_id %in% responders)

fig2 <- ggplot(resp_data, aes(x = condition, y = count, colour = condition)) +
  geom_point(size = 2.5, position = position_jitter(width = 0.08)) +
  facet_wrap(~ gene_id, scales = "free_y") +   # free_y: each gene its own scale
  scale_colour_manual(values = c(control = "#4C72B0", treated = "#DD8452")) +
  labs(
    title = "Are the responders consistent across replicates?",
    x = "Condition", y = "Raw count (each point = one replicate)",
    colour = "Condition"
  ) +
  theme_bw(base_size = 12)

fig2
ggsave("plots/interpret_2_responders_replicates.png", fig2,
       width = 7.5, height = 5, dpi = 300)
# 🧬 INTERPRETATION: in each panel all three treated points sit
# clearly above (crp/ompA/rpoB) or below (emrB/tolC/dnaA) all
# three control points — the separation is CLEAN, not driven by a
# single outlier. ANSWER (part 2): the responses are reproducible
# across replicates, so we trust them.


# -------------------------------------------------------------
# FIGURE 3 — The whole-dataset map (scatter, control vs treated)
# -------------------------------------------------------------
# One picture of every gene at once: control mean (x) vs treated
# mean (y), with the y = x "no-change" diagonal and responders
# labelled. This is the figure that summarises the whole question.
fig3 <- ggplot(gene_summary, aes(x = mean_control, y = mean_treated)) +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed", colour = "grey50") +
  geom_point(aes(colour = response), size = 3) +
  geom_text(data = filter(gene_summary, response != "No change"),
            aes(label = gene_id), vjust = -0.8, size = 3) +
  scale_colour_manual(values = c("Up in treated"   = "#C44E52",
                                 "Down in treated" = "#4C72B0",
                                 "No change"        = "grey70")) +
  labs(
    title = "Treated vs control expression, per gene",
    subtitle = "Off-diagonal = responsive; above = up, below = down",
    x = "Mean count (control)", y = "Mean count (treated)", colour = "Response"
  ) +
  theme_bw(base_size = 12)

fig3
ggsave("plots/interpret_3_scatter_map.png", fig3,
       width = 6.5, height = 5, dpi = 300)
# 🧬 INTERPRETATION: the grey cloud hugs the diagonal — most genes
# are unchanged. The red points (crp, ompA, rpoB) float above; the
# blue points (emrB, tolC, dnaA) sink below. ANSWER (final): the
# treatment UP-regulates crp/ompA/rpoB and DOWN-regulates
# emrB/tolC/dnaA, while leaving the other 14 genes unchanged.


# -------------------------------------------------------------
# SAVE THE EVIDENCE TABLE TOO
# -------------------------------------------------------------
# Good practice: the figures and the numbers behind them travel
# together, so a reviewer can reproduce every plot.
dir.create("../results", showWarnings = FALSE)
write_csv(arrange(gene_summary, desc(log2FC)),
          "../results/treatment_response.csv")


# -------------------------------------------------------------
# ✅ THE PAYOFF OF THE WHOLE WEEK:
#    tidy data (Day 5) -> the right plot (Day 6) -> a clear,
#    defensible BIOLOGICAL conclusion. You did not just draw
#    pictures; you answered a research question with figures.
# -------------------------------------------------------------
