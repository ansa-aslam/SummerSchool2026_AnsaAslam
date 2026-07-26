# R & tidyverse Cheat Sheet — Module 1
*For data wrangling & visualization. Print and keep.*

## Setup (once per session)
```r
library(tidyverse)     # loads readr, dplyr, tidyr, ggplot2
# In RStudio: Session > Set Working Directory > To Source File Location
```

## Vectors & basics
```r
x <- c(2, 4, 6, 8)     # <- is "assign"
mean(x); sd(x); sum(x); length(x)
x[1]                   # first element (R counts from 1!)
x[x > 4]               # elements greater than 4
seq(1, 10, by = 2)     # 1 3 5 7 9
```

## Read & inspect data
```r
expr <- read_csv("../../data/gene_expression.csv")
meta <- read_csv("../../data/sample_metadata.csv")
head(expr)      # first rows
glimpse(expr)   # structure (columns + types)
dim(expr)       # rows, cols
summary(expr)   # quick stats
colnames(expr)  # column names
```

## dplyr verbs (the pipe |> sends data into the next step)
```r
expr |> select(gene_id, treated_1)        # pick columns
expr |> filter(control_1 > 100)           # keep matching rows
expr |> arrange(desc(control_1))          # sort
expr |> mutate(mean_ctrl = (control_1+control_2+control_3)/3)  # new column
expr |> summarise(avg = mean(control_1))  # collapse to a summary
```

## Reshape (tidyr) — wide ⇄ long
```r
long <- expr |>
  pivot_longer(cols = -gene_id,           # all columns except gene_id
               names_to = "sample",
               values_to = "count")
# long has columns: gene_id, sample, count
```

## Join datasets
```r
joined <- long |> left_join(meta, by = "sample")
# now each row also has condition, batch, rin
```

## Group & summarise
```r
joined |>
  group_by(condition) |>
  summarise(mean_count = mean(count), sd = sd(count), n = n())

joined |>
  group_by(gene_id, condition) |>
  summarise(mean_count = mean(count), .groups = "drop")
```

## Missing data
```r
mean(x, na.rm = TRUE)      # ignore NA
df |> drop_na()            # remove rows with NA
df |> filter(!is.na(rin))  # keep rows where rin is present
```

## Write a function
```r
mean_expression <- function(counts) {
  mean(counts, na.rm = TRUE)
}
```

## ggplot2 — grammar: data + aes + geom
```r
ggplot(joined, aes(x = condition, y = count)) +
  geom_boxplot()

ggplot(joined, aes(x = count)) +
  geom_histogram(bins = 20)

ggplot(summary_df, aes(x = gene_id, y = mean_count, fill = condition)) +
  geom_col(position = "dodge")            # bar plot

ggplot(scatter_df, aes(x = mean_ctrl, y = mean_trt)) +
  geom_point() +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed")
```

## Customize & save
```r
p <- ggplot(joined, aes(condition, count, fill = condition)) +
  geom_boxplot() +
  labs(title = "Expression by condition", x = "Condition", y = "Count") +
  theme_bw()

ggsave("figures/boxplot.png", p, width = 6, height = 4, dpi = 300)
```
> ⚠️ Top mistakes: R indexes from **1** (not 0) · ggplot layers join with **`+`**, pipes use **`|>`** · `=` inside `aes()` but `<-` to assign objects · quote column **names** in `read_csv` but not inside `aes()`.
