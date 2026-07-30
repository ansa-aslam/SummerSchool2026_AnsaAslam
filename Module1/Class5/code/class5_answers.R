setwd('//wsl.localhost/Ubuntu/home/aaslam123/SummerSchool2026-main/Module1/Class5/code')

library(tidyverse)
library(dplyr)

expr <- read_csv("//wsl.localhost/Ubuntu/home/aaslam123/SummerSchool2026-main/Module1/data/gene_expression.csv")
head(expr)

meta <- read_csv("//wsl.localhost/Ubuntu/home/aaslam123/SummerSchool2026-main/Module1/data/sample_metadata.csv")
head(meta)

#-----------PART(A)------------
#--------------1---------------
expr_long <- expr %>%
  pivot_longer(
    cols = -gene_id,
    names_to = "sample",
    values_to = "count"
  )

dim(expr_long)

#--------------2---------------
expr_long %>%
  filter(gene_id == "crp")

#--------------3---------------
expr_wide <- expr_long %>%
  pivot_wider(
    names_from = sample,
    values_from = count
  )

dim(expr_wide)
dim(expr)

all(dim(expr_wide) == dim(expr))

#-----------PART(A)------------
#--------------4---------------
expr_joined <- expr_long %>%
  left_join(meta, by = "sample")


dim(expr_joined)

#--------------5---------------
expr_joined %>%
  filter(is.na(condition)) %>%
  nrow()

#--------------6---------------
expr_joined %>%
  count(condition)

expr_joined %>%
  count(batch)

#--------------7---------------
expr_joined %>%
  filter(gene_id == "ompA", condition == "treated")

#-----------PART(C)------------
#--------------8---------------
expr_joined %>%
  group_by(condition) %>%
  summarise(
    mean_count = mean(count),
    sd_count = sd(count)
  )

#--------------9---------------
gene_summary <- expr_joined %>%
  group_by(gene_id) %>%
  summarise(mean_count = mean(count)) %>%
  arrange(desc(mean_count))

gene_summary

#--------------10---------------
gene_condition_summary <- expr_joined %>%
  group_by(gene_id, condition) %>%
  summarise(mean_count = mean(count), .groups = "drop")

gene_condition_summary

nrow(gene_condition_summary)
#--------------11---------------
expr_joined %>%
  count(condition, batch)

#-----------PART(D)------------
#--------------12---------------
expr_na <- expr_joined %>%
  mutate(
    count = if_else(
      gene_id == "dnaA" & sample == "control_2",
      NA_real_,
      count
    )
  )

# Confirming exactly one missing value
sum(is.na(expr_na$count))

#--------------13---------------
#--------------(a)--------------
expr_na %>%
  group_by(condition) %>%
  summarise(mean_count = mean(count))

#--------------(b)--------------
expr_na %>%
  group_by(condition) %>%
  summarise(mean_count = mean(count, na.rm = TRUE))

#--------------14---------------
expr_no_na <- expr_na %>%
  drop_na(count)

nrow(expr_no_na)

#--------------15---------------
expr_filled <- expr_na %>%
  mutate(count = coalesce(count, 0))

sum(is.na(expr_filled$count))

#-----------PART(E)------------
#--------------16---------------
gene_means <- expr_joined %>%
  group_by(gene_id, condition) %>%
  summarise(mean_count = mean(count), .groups = "drop") %>%
  pivot_wider(
    names_from = condition,
    values_from = mean_count
  )

gene_means

#--------------17---------------
gene_fc <- gene_means %>%
  mutate(log2FC = log2((treated + 1) / (control + 1))) %>%
  arrange(desc(log2FC))

gene_fc

#--------------18---------------
gene_fc <- gene_fc %>%
  mutate(
    direction = if_else(log2FC > 0, "up", "down"),
    abs_log2FC = abs(log2FC)
  ) %>%
  arrange(desc(abs_log2FC))

gene_fc %>%
  slice_head(n = 3)

#--------------19---------------
significant_genes <- gene_fc %>%
  filter(abs(log2FC) >= 1)

# Number of genes
nrow(significant_genes)

# Up-regulated genes
significant_genes %>%
  filter(direction == "up")

# Down-regulated genes
significant_genes %>%
  filter(direction == "down")

#-----------CHALLENGE-----------
#--------------20---------------
gene_sd <- expr_joined %>%
  group_by(gene_id, condition) %>%
  summarise(sd_count = sd(count), .groups = "drop")

gene_sd

# Noisiest gene in treated
gene_sd %>%
  filter(condition == "treated") %>%
  arrange(desc(sd_count)) %>%
  slice(1)

#--------------21---------------
library_sizes <- expr_joined %>%
  group_by(sample) %>%
  summarise(lib = sum(count), .groups = "drop")

expr_cpm <- expr_joined %>%
  left_join(library_sizes, by = "sample") %>%
  mutate(cpm = count / lib * 1e6)

expr_cpm

#--------------22---------------
gene_cpm <- expr_cpm %>%
  group_by(gene_id, condition) %>%
  summarise(mean_cpm = mean(cpm), .groups = "drop") %>%
  pivot_wider(
    names_from = condition,
    values_from = mean_cpm
  ) %>%
  mutate(log2FC = log2((treated + 1) / (control + 1))) %>%
  arrange(desc(log2FC))

gene_cpm

#---------SAVING RESULTS--------
dir.create("results", showWarnings = FALSE)

write_csv(expr_long, "//wsl.localhost/Ubuntu/home/aaslam123/SummerSchool2026-main/Module1/Class5/code/results/expr_long.csv")
write_csv(expr_joined, "//wsl.localhost/Ubuntu/home/aaslam123/SummerSchool2026-main/Module1/Class5/code/results/expr_joined.csv")
write_csv(gene_summary, "//wsl.localhost/Ubuntu/home/aaslam123/SummerSchool2026-main/Module1/Class5/code/results/gene_summary.csv")
write_csv(gene_condition_summary, "//wsl.localhost/Ubuntu/home/aaslam123/SummerSchool2026-main/Module1/Class5/code/results/gene_condition_summary.csv")
write_csv(gene_fc, "//wsl.localhost/Ubuntu/home/aaslam123/SummerSchool2026-main/Module1/Class5/code/results/gene_fc.csv")
write_csv(gene_cpm, "//wsl.localhost/Ubuntu/home/aaslam123/SummerSchool2026-main/Module1/Class5/code/results/gene_cpm.csv")

write_csv(gene_sd, "//wsl.localhost/Ubuntu/home/aaslam123/SummerSchool2026-main/Module1/Class5/code/results/gene_sd.csv")
write_csv(library_sizes, "//wsl.localhost/Ubuntu/home/aaslam123/SummerSchool2026-main/Module1/Class5/code/results/library_sizes.csv")
write_csv(significant_genes, "//wsl.localhost/Ubuntu/home/aaslam123/SummerSchool2026-main/Module1/Class5/code/results/significant_genes.csv")