# Class 5 — Exercises
**Data Wrangling & Exploratory Analysis (R / tidyverse)**

Work in RStudio. Open a new script.
Start every script with:
```r
library(tidyverse)
expr <- read_csv("/data/gene_expression.csv")
meta <- read_csv("/data/sample_metadata.csv")
```
Write your answers (the code you used) into a script called `class5_answers.R` as you go. Solutions are in `solutions.md` — **try first, then check**.

---

## Part A — Reshape (pivot_longer / pivot_wider)
1. Reshape `expr` to long form with columns `gene_id`, `sample`, `count`. Save it as `expr_long`. How many rows and columns does it have?
2. Using `expr_long`, show all 6 rows for the gene `crp` (use `filter`).
3. Turn `expr_long` back into the original wide matrix with `pivot_wider()`. Confirm its dimensions match the original `expr`.

## Part B — Join (the key skill)
4. Join `meta` onto `expr_long` by `sample`, creating `expr_joined`. How many rows and columns now?
5. Confirm the join matched every row: count how many rows have a missing (`NA`) `condition`.
6. How many rows are there per `condition`? Per `batch`? (One `count()` call each.)
7. Show every `treated` row for the gene `ompA` (filter on both `gene_id` and `condition`).

## Part C — Group & summarise (descriptive statistics)
8. From `expr_joined`, compute the **mean** and **sd** of `count` for each `condition`. Which condition has the higher mean?
9. Compute, per **gene**, the mean count across all 6 samples, sorted from highest to lowest. Which gene is the most highly expressed? Which is the least?
10. Make a (gene_id × condition) summary of mean counts — one row per gene-and-condition combination. How many rows should it have?
11. Using `count()`, make a cross-tab of `condition` against `batch`. Is the design balanced?

## Part D — Missing data
12. Create `expr_na` from `expr_joined` by setting the `count` for `dnaA` in `control_2` to `NA`. Confirm exactly one value is missing.
13. Compute the mean `count` per condition on `expr_na` **(a)** without `na.rm` and **(b)** with `na.rm = TRUE`. Explain the difference in one sentence.
14. From `expr_na`, drop the row(s) with a missing `count` and report the new row count.
15. From `expr_na`, fill the missing `count` with `0` using `coalesce()`, and confirm no `NA`s remain.

## Part E — EDA: fold-change & responders
16. Build a per-gene table with a `control` mean column and a `treated` mean column (hint: group by gene+condition, summarise, then `pivot_wider`).
17. Add a `log2FC` column using `log2((treated + 1) / (control + 1))` and sort descending. Which gene is the **most up-regulated**?
18. Add a `direction` column ("up"/"down") and rank genes by the **size** of change (`abs(log2FC)`). What are the top 3 biggest changers?
19. Filter to genes with `abs(log2FC) >= 1` (at least 2-fold). How many genes pass? List the up and the down ones.

## 🚀 Challenge (optional)
20. Compute each gene's **standard deviation within the control group only**, then within treated only, and find the gene whose counts are noisiest (largest sd) in treated.
21. The 3 samples differ in **library size** (total counts). Compute the total `count` per `sample`, then add a normalised column `cpm = count / library_size * 1e6` (counts-per-million) to `expr_joined` using a join or `group_by`. (Hint: compute library sizes with `group_by(sample) |> summarise(lib = sum(count))`, then join back.)
22. Using the `cpm` values from Q21, recompute the per-gene control-vs-treated means and log2 fold-change. Does the top up-regulated gene change versus the raw-count answer? Why might normalising matter?

---
### Submit
Save `class5_answers.R` and your `results/` CSVs.
