# Class 6 — Data Visualization & Interpretation
## Student Workbook
**Theme: From Data Tables to Biological Insight → to Publication-Quality Figures**

> 📖 **How to use this workbook.** Read along and **type every `⌨️` block yourself** in RStudio — don't just watch. After each plot, **say (or write) one sentence about what it means biologically** — that interpretation is the real skill today. Symbols: 💡 idea · 🧬 biology · ⌨️ type this · ⚠️ watch out · ✅ check yourself · 🚀 optional extra.
>
> **Before you start each script:** Set your working directory. Go to RStudio menu → **Session → Set Working Directory → To your Input Files Location.** Data can downloaded from GitHub repo: `"Module1/data/gene_expression.csv"`.

---

## Today you will learn to
- Use the **grammar of graphics**: every plot = **data + `aes()` + geom**.
- Build the four core plots: **histogram, boxplot, bar plot, scatter plot**.
- Visualize **distributions** and **compare groups** (control vs treated).
- Polish for publication: titles, themes, colours, **faceting**, and saving at 300 dpi.
- **Interpret** each figure — answer *"which genes respond to the treatment?"*

---

## 1. Why make figures? (the 4 principles)

A table of 120 numbers hides its story. One good plot reveals it instantly. Keep these on your desk all day:

1. **One message per plot.** If you can't say the point in a sentence, split the plot.
2. **Label everything** — axis titles in plain words, a title, a legend. Never raw column names.
3. **Don't distort.** Honest scales. Styling makes the message *clearer*, never *different*.
4. **Match the geom to the question:**

| Your question | The geom |
|---|---|
| What values are common? (a distribution) | **histogram** — `geom_histogram()` |
| Do these groups differ? | **boxplot** — `geom_boxplot()` |
| One value per category? | **bar** — `geom_col()` |
| How do two numbers relate? | **scatter** — `geom_point()` |

> 🧬 Every figure in a paper is an **argument**. A boxplot argues "these groups differ"; a scatter argues "these two things track each other." Choosing the wrong plot is like choosing the wrong word.

---

## 2. Set up (script: `ggplot_intro.R`)

⌨️
```r
library(tidyverse)   # loads ggplot2, dplyr, tidyr, readr at once
```
✅ No error? You're ready. (If it says *"there is no package called 'tidyverse'"*, run once: `install.packages("tidyverse")`.)

---

## 3. Rebuild the tidy table (just like Day 5)

ggplot wants **tidy** data: one row per measurement. Our file is **wide** (one column per sample), so we `pivot_longer` then `left_join` the metadata.

⌨️
```r
expr <- read_csv("gene_expression.csv")   # wide: gene_id + 6 samples
meta <- read_csv("sample_metadata.csv")   # sample, condition, batch, rin

expr_tidy <- expr |>
  pivot_longer(cols = -gene_id, names_to = "sample", values_to = "count") |>
  left_join(meta, by = "sample")

expr_tidy        # 120 rows = 20 genes x 6 samples
```
💡 Now every count carries its `condition` and `batch`. **This one table feeds every plot today.**

> ⚠️ Don't try to plot the wide `expr` directly — ggplot can't map "three treated columns" to one channel. Always tidy first.

---

## 4. The grammar of graphics (the one big idea)

Every ggplot is three pieces glued with **`+`**:
```
ggplot( DATA , aes( x = , y = , fill = / colour = ) )  +  geom_*()
         |          |                                       |
       tidy df   which column -> which visual channel    the shape that draws it
```
Read it as a sentence: *"take this data, map these columns to x/y/colour, then draw it with this geom."*

💡 Two rules to remember forever:
- Layers join with **`+`**, NOT the pipe `|>`.
- Anything **inside `aes()`** varies *with the data* (e.g. `fill = condition`). A **fixed** look (one colour for all) goes **outside** `aes()` (e.g. `fill = "steelblue"`).

⌨️ The empty skeleton — axes appear, but nothing is drawn until you add a geom:
```r
ggplot(expr_tidy, aes(x = count))
```

---

## 5. Plot 1 — Histogram (a distribution)

⌨️
```r
ggplot(expr_tidy, aes(x = count)) +
  geom_histogram(bins = 30)
```
🧬 **Interpret (write it!):** most counts pile up LOW with a thin tail to the right — a **right-skew**. That's the signature of expression data: many quiet genes, a few loud ones.

⌨️ Same data on a log axis — the skew straightens out:
```r
ggplot(expr_tidy, aes(x = count)) +
  geom_histogram(bins = 30) + scale_x_log10()
```
✅ You made a distribution plot and explained its shape.

---

## 6. Plot 2 — Boxplot (compare groups)

A boxplot = **box** (middle 50%), **line** (median), **whiskers** (spread), **dots** (outliers).

⌨️
```r
ggplot(expr_tidy, aes(x = condition, y = count, fill = condition)) +
  geom_boxplot()
```
🧬 **Interpret:** the two boxes overlap a lot → overall expression is *similar* in treated vs control. So the treatment is **not** a blanket shift — its effect must live in **specific genes**. (We hunt them next.)

💡 Notice `fill = condition` is *inside* `aes()`, so colour follows the data.

⌨️ A quick quality check — group by batch instead of condition:
```r
ggplot(expr_tidy, aes(x = batch, y = count, fill = batch)) + geom_boxplot()
```
🧬 **Interpret:** batches A and B look similar → no nasty "batch effect" faking our biology.

---

## 7. Plot 3 — Bar plot (a value per gene) (script: `plot_gallery.R`)

First build a one-row-per-gene summary with the fold-change:
⌨️
```r
gene_summary <- expr |>
  mutate(mean_control = (control_1 + control_2 + control_3) / 3,
         mean_treated = (treated_1 + treated_2 + treated_3) / 3,
         log2FC       = log2((mean_treated + 1) / (mean_control + 1))) |>
  select(gene_id, mean_control, mean_treated, log2FC)
```
💡 `log2FC`: **+1 = doubled in treated, −1 = halved.** This number *is* the response.

⌨️
```r
ggplot(gene_summary,
       aes(x = reorder(gene_id, log2FC), y = log2FC, fill = log2FC > 0)) +
  geom_col() + coord_flip()
```
💡 **`geom_col()`** draws a bar at a HEIGHT you give it. (`geom_bar()` instead *counts rows* — a classic mix-up.) **`reorder()`** sorts bars into a story; **`coord_flip()`** makes gene names readable.

🧬 **Interpret:** bars to the **right** (positive) are **UP** in treatment — **crp, ompA, rpoB** lead. Bars to the **left** are **DOWN** — **emrB, dnaA, tolC** fall hardest. Genes near zero barely move.

> ⚠️ **Loud ≠ responsive.** The most highly expressed genes (soxS, ftsZ, fur) barely change. Abundance and responsiveness are different questions.

---

## 8. Plot 4 — Scatter plot (relationship)

⌨️
```r
responders <- gene_summary |> filter(abs(log2FC) > 1)

ggplot(gene_summary, aes(x = mean_control, y = mean_treated)) +
  geom_point(aes(colour = log2FC > 0), size = 3) +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed", colour = "grey40") +
  geom_text(data = responders, aes(label = gene_id), vjust = -0.8, size = 3)
```
💡 The dashed **`geom_abline(slope = 1)`** is the **"no change" line**: on it = unchanged, **above** = up in treated, **below** = down. We label only the strong responders (label the few, not the many).

🧬 **Interpret:** most points hug the diagonal (unchanged). The genes far OFF the line are the answer — crp/ompA/rpoB above, emrB/tolC/dnaA below. This scatter *is* the visual definition of "which genes respond?"

✅ You have now built all four core plot types.

---

## 9. Make it publication-quality (script: `customize_publication.R`)

Polish a boxplot one step at a time:
⌨️
```r
base <- ggplot(expr_tidy, aes(x = condition, y = count, fill = condition)) +
  geom_boxplot()

base +
  labs(title = "Treatment does not shift overall expression",
       x = "Condition", y = "Raw count", fill = "Condition") +   # plain labels
  theme_bw(base_size = 13) +                                      # the "paper" look
  scale_fill_manual(values = c(control = "#4C72B0",              # your own colours
                               treated = "#DD8452"))
```
💡 The four polish tools:
- **`labs()`** — title, axis titles, legend title. *Never ship raw column names.*
- **`theme_bw()` / `theme_minimal()` / `theme_classic()`** — try all three, pick the cleanest.
- **`scale_fill_manual(values = c(...))`** — your own, colour-blind-friendly hues; the names must match the data values (`control`, `treated`).

---

## 10. Faceting — "small multiples" (the most powerful idea today)

`facet_wrap(~column)` splits one plot into a grid, one mini-plot per category.

⌨️
```r
goi <- c("crp","ompA","rpoB","emrB","tolC","dnaA")

expr_tidy |>
  filter(gene_id %in% goi) |>
  ggplot(aes(x = condition, y = count, fill = condition)) +
  geom_boxplot() +
  facet_wrap(~ gene_id) +
  scale_fill_manual(values = c(control = "#4C72B0", treated = "#DD8452")) +
  theme_bw()
```
🧬 **Interpret:** now the biology leaps out — treated boxes sit clearly ABOVE control for crp/ompA/rpoB and clearly BELOW for emrB/tolC/dnaA. Faceting turned a muddy whole-dataset boxplot into six crisp gene-level verdicts. **This is a results-section figure.**

---

## 11. Save your figure at publication resolution

⌨️
```r
dir.create("plots", showWarnings = FALSE)   # make a folder for figures

my_plot <- expr_tidy |>
  filter(gene_id %in% goi) |>
  ggplot(aes(x = condition, y = count, fill = condition)) +
  geom_boxplot() + facet_wrap(~ gene_id) + theme_bw()

ggsave("plots/my_figure.png", my_plot, width = 7, height = 5, dpi = 300)
```
💡 `width`/`height` are in **inches** (the final printed size); **`dpi = 300`** = print quality; a `.pdf` extension gives a vector file (infinitely sharp).

> ⚠️ If you call `ggsave()` with no plot, it saves whatever was drawn *last* — which may be the wrong figure. **Always pass your plot object** (`my_plot`) explicitly.

---

## ✅ End-of-class self-check
Tick these before you leave:
- [ ] I rebuilt the tidy table with `pivot_longer` + `left_join`.
- [ ] I can recite the grammar: **data + `aes()` + geom**, joined with `+`.
- [ ] I built a histogram, a boxplot, a bar plot (`geom_col`), and a scatter.
- [ ] I customized one plot with `labs()`, `theme_bw()`, and `scale_fill_manual()`.
- [ ] I made a **faceted** figure and saved it at `dpi = 300`.
- [ ] I wrote a **one-sentence biological interpretation** under each plot.

## 🚀 Go further (optional, if you finish early)
- Try `theme_minimal()` and `theme_classic()` and decide which you like.
- Colour the histogram by `condition` and add `facet_wrap(~condition)`.
- Build a **volcano-style** plot: `log2FC` on x, `-log10` of a made-up p-value on y (see the challenge exercise).
- Save one figure as `.pdf` and open it — notice it stays sharp when you zoom.

## One-line summary to remember
**question → tidy data → choose geom → label → INTERPRET.** A figure is an honest, clear argument about biology.

➡️ Now do `exercise/exercises.md`.
