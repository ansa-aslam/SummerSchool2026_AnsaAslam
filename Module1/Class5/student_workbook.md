# Class 5 — Data Wrangling & Exploratory Analysis
## Student Workbook
**Theme: From a messy matrix to the genes that respond — tidy, join, summarise, explore.**

> 📖 **How to use this workbook.** Read along and **type every `⌨️` block yourself** in RStudio — don't just watch. First thing each session: **Session > Set Working Directory > To Source File Location** so the `/data` paths work. Keep this file; you'll reuse these patterns in every R analysis. Symbols: 💡 idea · 🧬 biology · ⌨️ type this · ⚠️ watch out · ✅ check yourself · 🚀 optional extra.

---

## Today you will learn to
- Understand **tidy data** and reshape a **wide** matrix into **long/tidy** form.
- **Join** two tables together on a shared key column.
- **Group** rows and **summarise** them into statistics (mean, sd, n).
- Handle **missing values** (`NA`) without lying about your data.
- Run your first **exploratory data analysis**: find the genes that respond to treatment.

🎯 **The question we answer all day:** *Which genes turn UP or DOWN when cells are treated?*

---

## 0. Warm-up — load the data (recap of Day 4)

The pipe `|>` feeds the left side into the function on the right. The four verbs from yesterday: `select` (columns), `filter` (rows), `arrange` (sort), `mutate` (new columns).

⌨️
```r
library(tidyverse)
expr <- read_csv("/data/gene_expression.csv")
meta <- read_csv("/data/sample_metadata.csv")
expr      # 20 genes x 7 columns (gene_id + 6 samples)
meta      # 6 samples x 4 columns (sample, condition, batch, rin)
```
✅ You see a 20×7 table (`expr`) and a 6×4 table (`meta`).

💡 **Tidy data** means: **1 row = 1 observation, 1 column = 1 variable.** Our `expr` is *wide* — each sample is its own column, so the sample name is stuck in the header. We want it as a value in a column. That tidy shape is what every tidyverse tool loves.

---

## 1. Reshape: WIDE → LONG with `pivot_longer()`  ·  `code/reshape_join.R`

We fold the 6 sample columns into two new columns: one for the sample **name**, one for the **count**.

⌨️
```r
expr_long <- expr |>
  pivot_longer(
    cols      = -gene_id,     # pivot every column EXCEPT gene_id
    names_to  = "sample",     # old column NAMES go here
    values_to = "count"       # old cell VALUES go here
  )
expr_long
dim(expr_long)               # 120  3
```
💡 20 genes × 6 samples = **120 rows**. The numbers didn't change — the *shape* did. Now `sample` is a real column we can group and join on.

⚠️ `names_to` and `values_to` are **new names you invent**, so they're in quotes: `"sample"`, `"count"`. `cols = -gene_id` means "everything except gene_id".

### The inverse: LONG → WIDE with `pivot_wider()`
⌨️
```r
expr_long |> pivot_wider(names_from = sample, values_from = count)   # back to 20 x 7
```
💡 `pivot_longer` and `pivot_wider` are opposites. Whatever shape a tool needs, you can make it.

---

## 2. Join: attach the metadata with `left_join()`

`expr_long` knows the sample's **name** but not its condition/batch/RIN. `meta` does. A **join** glues them by the shared `sample` column.

⌨️
```r
expr_joined <- expr_long |>
  left_join(meta, by = "sample")
expr_joined
dim(expr_joined)             # 120  6   <- still 120 rows!
```
💡 `left_join(x, y)` keeps **every row of the left table** and adds y's columns where the key matches. `by = "sample"` says "match on the sample column".

⚠️ **Always re-check the row count after a join** with `dim()`. If rows suddenly multiply, your key wasn't unique. Here it stays 120 — good.

### Check your join (do this every time)
⌨️
```r
expr_joined |> count(condition)        # 60 control, 60 treated
sum(is.na(expr_joined$condition))      # 0  -> every sample matched
```
✅ You have `expr_joined`: **120 rows, 6 columns** (`gene_id, sample, count, condition, batch, rin`).

---

## 3. Group & summarise: descriptive statistics  ·  `code/summarise_group.R`

💡 `group_by()` tags rows into groups (changes nothing you see). `summarise()` collapses **each group to one row** of numbers. (It's the `sort | uniq -c` tally from Class 1 — but with real statistics.)

### Per condition — control vs treated overall
⌨️
```r
expr_joined |>
  group_by(condition) |>
  summarise(
    n_obs        = n(),
    mean_count   = mean(count),
    sd_count     = sd(count),
    median_count = median(count),
    .groups = "drop"
  )
```
💡 2 rows, 60 observations each. control mean ≈ **243**, treated ≈ **273**. The overall average barely moves — **averages can hide everything**. The real story is gene-by-gene.

### Per gene — one row per gene
⌨️
```r
by_gene <- expr_joined |>
  group_by(gene_id) |>
  summarise(
    mean_count = mean(count),
    sd_count   = sd(count),
    min_count  = min(count),
    max_count  = max(count),
    .groups = "drop"
  ) |>
  arrange(desc(mean_count))
by_gene
```
💡 20 rows. `soxS`, `crp`, `ftsZ` are loud; `dnaA` is the quietest gene.

⚠️ `.groups = "drop"` ungroups the result and silences a message. Make it a habit.

### Handy shortcuts
⌨️
```r
expr_joined |> count(condition, batch)     # quick cross-tab
expr_joined |>
  group_by(gene_id, condition) |>
  summarise(mean_count = mean(count), .groups = "drop")   # 40 rows (used after lunch)
```

---

## 4. Missing data (`NA`)  ·  `code/missing_data.R`

🧬 Real data has holes — a failed well, a dropped sample. A missing value is **not zero**; it means "unknown". R marks it `NA` and refuses to guess.

⌨️
```r
x <- c(10, 20, NA, 40)
mean(x)          # NA   <- one missing value poisons the result
is.na(x)         # FALSE FALSE TRUE FALSE
sum(is.na(x))    # 1    <- counts the NAs
mean(x, na.rm = TRUE)   # 23.33  <- "na.rm" = remove NAs, compute on the rest
```
⚠️ **Never test `x == NA`** — it returns `NA`, not TRUE. Always use `is.na(x)`.

### Inject a missing value and fix it
⌨️
```r
expr_na <- expr_joined |>
  mutate(count = if_else(gene_id == "lacZ" & sample == "treated_1",
                         NA_real_, count))
sum(is.na(expr_na$count))                 # 1

# Without na.rm the treated mean becomes NA:
expr_na |> group_by(condition) |>
  summarise(mean_count = mean(count), .groups = "drop")

# With na.rm, and REPORT how many were missing:
expr_na |> group_by(condition) |>
  summarise(mean_count = mean(count, na.rm = TRUE),
            n_missing  = sum(is.na(count)), .groups = "drop")
```
💡 Don't just hide NAs — **count and report** them.

⌨️ Two more tools:
```r
expr_na |> drop_na(count)                 # delete rows with a missing count
expr_na |> mutate(count = coalesce(count, 0))   # fill NA with 0
```
⚠️ Filling with 0 is a **decision**: a missing measurement is not a measured zero. For one cell, `na.rm = TRUE` is usually the honest choice.

---

## 5. Guided lab — EDA: find the responders 🎉  ·  `code/eda_foldchange.R`

🎯 Answer the day's question: *which genes go UP or DOWN under treatment?*

### Step 1 — per-gene means per condition, reshaped for comparison
⌨️
```r
gene_means <- expr_joined |>
  group_by(gene_id, condition) |>
  summarise(mean_count = mean(count), .groups = "drop") |>
  pivot_wider(names_from = condition, values_from = mean_count)
gene_means        # gene_id | control | treated   (20 rows)
```

### Step 2 — log2 fold-change
💡 fold-change = `treated / control`. **log2** makes it readable: **+1 = 2× up, −1 = 2× down, 0 = no change.** The `+1` avoids dividing by zero.
⌨️
```r
fold_changes <- gene_means |>
  mutate(log2FC = log2((treated + 1) / (control + 1)),
         direction = if_else(log2FC > 0, "up", "down")) |>
  arrange(desc(log2FC))
print(fold_changes, n = 20)
```
💡 Most **UP**: `crp` (+1.9), `ompA`, `rpoB`. Most **DOWN**: `emrB` (−2.3), `dnaA`, `tolC`. Real biological signal!

### Step 3 — rank responders and threshold
⌨️
```r
fold_changes |>
  mutate(abs_log2FC = abs(log2FC)) |>
  arrange(desc(abs_log2FC)) |>
  slice_head(n = 6)                          # the 6 biggest changers

fold_changes |> filter(abs(log2FC) >= 1)     # |log2FC| >= 1 = at least 2-fold
```
💡 A responder can go up OR down, so rank by `abs(log2FC)`. `|log2FC| ≥ 1` is a common "2-fold" first pass — 6 genes clear it (UP: crp, ompA, rpoB; DOWN: tolC, dnaA, emrB).

⚠️ Real differential-expression also needs a p-value (a later course). Today is ranking + thresholding to build intuition.

---

## ✅ End-of-class self-check
Tick these before you leave:
- [ ] I reshaped the wide matrix to long with `pivot_longer()` (120 rows).
- [ ] I attached the metadata with `left_join(meta, by = "sample")` and checked it stayed 120 rows.
- [ ] I made per-condition and per-gene summaries with `group_by()` + `summarise()`.
- [ ] I handled an `NA` with `is.na()`, `na.rm = TRUE`, `drop_na()`, and `coalesce()`.
- [ ] I built a `fold_changes` table and can name the most up- and down-regulated gene.

## 🚀 Go further (optional, if you finish early)
- Add `sd` to `gene_means` per condition and find the gene with the noisiest counts.
- Use `inner_join` instead of `left_join` and confirm the result is identical here (why?).
- Compute fold-change *without* the `+1` pseudocount and see which gene now misbehaves.

## One-line summary to remember
**read → tidy (`pivot_longer`) → join → group/summarise → handle NA → explore (fold-change).** That's data wrangling and Exploratory Data Analysis (EDA) in R.

➡️ Now do `exercises/exercises.md`.
