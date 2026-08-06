#__________________STEP 3_________________
setwd('//wsl.localhost/Ubuntu/home/aaslam123/SummerSchool2026/Module1/Project/scripts')

library(tidyverse)

expression <- read_csv("//wsl.localhost/Ubuntu/home/aaslam123/SummerSchool2026/Module1/Project/raw/gene_expression.csv")
head(expression)

metadata <- read_csv("//wsl.localhost/Ubuntu/home/aaslam123/SummerSchool2026/Module1/Project/raw/sample_metadata.csv")
head(metadata)

#__________________STEP 4_________________
#__________Convert wide → long____________
expression_long <- expression %>%
  pivot_longer(
    cols = -gene_id,
    names_to = "sample",
    values_to = "count"
  )
head(expression_long)
dim(expression_long)

#______________Join metadata_____________
joined <- left_join(
  expression_long,
  metadata,
  by="sample"
)
head(joined)

#_______________Mean and SD______________
summary_table <- joined %>%
  group_by(gene_id, condition) %>%
  summarise(
    Mean = mean(count),
    SD = sd(count)
  )
summary_table


#_______________Fold Change______________
fc <- summary_table %>%
  select(gene_id,condition,Mean) %>%
  pivot_wider(
    names_from=condition,
    values_from=Mean
  )
fc

fc$log2FC <- log2(
  (fc$treated+1)/(fc$control+1)
)
fc$log2FC

fc <- fc %>%
  arrange(desc(abs(log2FC)))
fc

write_csv(fc,"//wsl.localhost/Ubuntu/home/aaslam123/SummerSchool2026/Module1/Project/results/fold_change.csv")

#__________________STEP 5_________________
library(ggplot2)

#__________________Boxplot_________________
ggplot(joined,
       aes(condition,count,fill=condition))+
  geom_boxplot()+
  theme_classic()

ggsave("//wsl.localhost/Ubuntu/home/aaslam123/SummerSchool2026/Module1/Project/figures/boxplot.png",
       dpi=300)

#__________________Histogram_________________
ggplot(fc,
       aes(log2FC))+
  geom_histogram(
    bins=20,
    fill="steelblue"
  )

ggsave("//wsl.localhost/Ubuntu/home/aaslam123/SummerSchool2026/Module1/Project/figures/histogram.png",
       dpi=300)

#__________________Bar plot_________________
top <- fc %>%
  slice(1:10)

ggplot(top,
       aes(reorder(gene_id,log2FC),
           log2FC,
           fill=log2FC>0))+
  geom_col()+
  coord_flip()

ggsave("//wsl.localhost/Ubuntu/home/aaslam123/SummerSchool2026/Module1/Project/figures/barplot.png",
       dpi=300)

#_______________Scatter plot_______________
ggplot(fc,
       aes(control,
           treated))+
  geom_point(
    size=3,
    color="blue"
  )+
  geom_abline(
    slope=1,
    intercept=0,
    linetype=2
  )

ggsave(
  "//wsl.localhost/Ubuntu/home/aaslam123/SummerSchool2026/Module1/Project/figures/scatter.png",
  dpi=300)

#_______________STEP 6_______________
#BIOLOGICAL INTERPRETATION

#Box plot-Treated samples show a slightly higher median and a wider spread than control, meaning most genes stay steady while a subset responds strongly. Biologically, this points to the treatment switching specific genes on or off rather than shifting the whole genome equally.

#Histogram-Most genes cluster near a log2FC of zero (expression levels remain relatively unchanged after treatment), showing little real change, while a small group shows strong positive or negative shifts. This is a targeted response, not a global one — likely genes tied to stress, adaptation, or metabolism.

#Bar plot-crp, ompA, rpoB, lacZ, and recA are the strongest upregulated genes; emrB, dnaA, tolC, marA, and sodA are the strongest downregulated ones. These are the treatment's clearest responders — upregulated genes may support protective/regulatory pathways, downregulated ones may mark processes suppressed by treatment.

#Scatter plot-Most genes sit close to the y=x line, meaning treated and control expression are similar. A few genes (ompA, crp) sit well above it and others (emrB, tolC) sit well below it, visually confirming the up/down calls from the bar plot.
