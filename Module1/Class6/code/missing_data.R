# =============================================================
# missing_data.R  —  Class 5: Data Wrangling & EDA
# Topic: handling MISSING values (NA) — the single most common
#        real-data headache. We INJECT an NA on purpose, watch it
#        break a calculation, then fix it the tidyverse way.
# -------------------------------------------------------------
# HOW TO RUN:
#   Open this file in RStudio.
#   Set the working directory to this code/ folder:
#     Session > Set Working Directory > To Source File Location
#   Data path is "../../data/<file>".
# =============================================================

library(tidyverse)


# -------------------------------------------------------------
# 1. WHAT IS NA?
# -------------------------------------------------------------
# NA = "Not Available" = a value we DON'T have. It is NOT zero and
# NOT an empty string — it means "unknown / missing". Real datasets
# are full of NAs: a failed well, a dropped sample, a blank cell.
#
# 🧬 Biology link: a sequencer might fail to measure one gene in one
#    sample. That cell is genuinely missing — pretending it is 0
#    would LIE about the biology, so R marks it NA instead.


# -------------------------------------------------------------
# 2. THE GOLDEN RULE: NA is "contagious"
# -------------------------------------------------------------
# Any arithmetic that touches an NA returns NA. R refuses to guess.

x <- c(10, 20, NA, 40)
mean(x)        # -> NA   (one missing value poisons the whole result)
sum(x)         # -> NA

# Detect missing values with is.na() (returns TRUE/FALSE per element):
is.na(x)       # -> FALSE FALSE  TRUE FALSE
sum(is.na(x))  # -> 1     (TRUE counts as 1, so this COUNTS the NAs)

# ⚠️ NEVER test with == NA. It does NOT work:
NA == NA       # -> NA  (!), not TRUE. Always use is.na().


# -------------------------------------------------------------
# 3. na.rm = TRUE  —  "remove NAs before computing"
# -------------------------------------------------------------
# Most summary functions accept na.rm = TRUE to skip the NAs.

mean(x, na.rm = TRUE)   # -> 23.33  (mean of 10, 20, 40)
sum(x,  na.rm = TRUE)   # -> 70
sd(x,   na.rm = TRUE)   # spread of the non-missing values


# -------------------------------------------------------------
# 4. BUILD the tidy table, then INJECT a missing value
# -------------------------------------------------------------
expr <- read_csv("../../data/gene_expression.csv")
meta <- read_csv("../../data/sample_metadata.csv")

expr_long <- expr |>
  pivot_longer(cols = -gene_id, names_to = "sample", values_to = "count") |>
  left_join(meta, by = "sample")

# Simulate a failed measurement: blank out lacZ in treated_1.
# (Normally NAs are ALREADY in your file; here we create one to practise.)
expr_na <- expr_long |>
  mutate(count = if_else(gene_id == "lacZ" & sample == "treated_1",
                         NA_real_, count))     # NA_real_ = a numeric NA

# Confirm exactly one value is now missing:
sum(is.na(expr_na$count))     # -> 1


# -------------------------------------------------------------
# 5. WATCH the NA break a grouped summary, then FIX it
# -------------------------------------------------------------
# Without na.rm, the treated group's mean becomes NA:
expr_na |>
  group_by(condition) |>
  summarise(mean_count = mean(count), .groups = "drop")
#   treated -> NA   (the single missing lacZ count poisoned it)

# Add na.rm = TRUE to compute on the values we DO have:
expr_na |>
  group_by(condition) |>
  summarise(
    mean_count = mean(count, na.rm = TRUE),
    n_missing  = sum(is.na(count)),     # always REPORT how many were missing
    .groups = "drop"
  )
#   treated mean now computes; n_missing = 1 documents the gap.

# 💡 Good practice: don't just silence NAs — COUNT and report them.


# -------------------------------------------------------------
# 6. drop_na()  —  delete rows that contain an NA
# -------------------------------------------------------------
# Sometimes the right call is to remove incomplete rows entirely.
# tidyr::drop_na() drops any row with an NA (optionally in named cols).

expr_clean <- expr_na |> drop_na(count)   # remove rows with missing count
nrow(expr_na)       # -> 120
nrow(expr_clean)    # -> 119  (the one lacZ/treated_1 row is gone)

# ⚠️ Dropping rows changes your sample sizes. Only drop when missing
#    data is rare and you can justify it. For one cell out of 120,
#    na.rm = TRUE (keep the row, skip the value) is usually kinder.


# -------------------------------------------------------------
# 7. coalesce()  —  fill NAs with a chosen fallback value
# -------------------------------------------------------------
# coalesce(a, b) returns a where it is present, else b. Handy to
# substitute a default. Here we fill missing counts with 0.
# ⚠️ Filling counts with 0 is a DATA DECISION, not a default — a
#    missing measurement is not the same as a measured zero. Only do
#    this when 0 is biologically the right stand-in.

expr_filled <- expr_na |>
  mutate(count = coalesce(count, 0))
sum(is.na(expr_filled$count))     # -> 0  (the NA became 0)

# A safer "fill" is the group's own mean (impute), e.g.:
expr_imputed <- expr_na |>
  group_by(gene_id) |>
  mutate(count = if_else(is.na(count),
                         mean(count, na.rm = TRUE), count)) |>
  ungroup()
# lacZ's missing treated_1 is replaced by lacZ's mean of its other counts.


# -------------------------------------------------------------
# 8. A QUICK "missingness audit" of any table
# -------------------------------------------------------------
# How many NAs in EACH column? across() + sum(is.na()) does it in one go.
expr_na |>
  summarise(across(everything(), ~ sum(is.na(.))))
# Every column 0 except count = 1. Run this on every new dataset.


# -------------------------------------------------------------
# ✅ You can now: detect NAs (is.na), count them (sum(is.na())),
#    skip them (na.rm = TRUE), drop rows (drop_na), and fill them
#    (coalesce / impute). NEXT: eda_foldchange.R finds the genes
#    that respond to treatment.
# -------------------------------------------------------------
