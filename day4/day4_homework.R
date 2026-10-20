# =============================================================================
# Day 4 - Homework: your first (tiny) single-cell analysis
# Introduction to R for Biologists
# =============================================================================
#
# THE BIOLOGY
# This is where the week's story arrives. On Day 1 you measured ONE
# interferon-stimulated gene (ISG15) by qPCR in a whole population of blood
# cells. Single-cell RNA-seq measures EVERY gene in EVERY cell separately, so
# we can ask: which cell types respond to interferon, and which genes mark
# each cell type?
# Our lab profiled blood immune cells (PBMCs) from an untreated sample and
# from a sample stimulated with interferon-beta (IFN-b). To keep things
# small, the dataset below has only 32 genes and 160 cells (80 T cells and 80
# CD14 monocytes). A real dataset has ~20,000 genes and thousands of cells -
# and in Week 2, Seurat will run the same steps you program here by hand:
# quality control, normalisation, and marker-gene testing.
#
# WHERE TO WORK
# In your GITHUB REPOSITORY project. The data are simulated by the script.
#
# HOW TO ANSWER
#  - Code below each task; answers as  # Answer: ...
#  - Restart R and run everything at the end: no errors allowed.
#
# Time: about 1.5-2 hours. Due before Week 2. Stretch tasks are optional.
# =============================================================================


# Packages ----
library(tidyverse)
library(patchwork)


# Part 0 - Create the dataset (run this block as it is) ----

# A simulated single-cell experiment: 32 genes x 160 cells from human blood
# (80 T cells and 80 CD14 monocytes). Half of the cells come from a sample
# stimulated with interferon-beta (IFN-b), half from an untreated control.
# Like any real experiment, it contains some damaged cells.
# You don't need to understand every line, but you will recognise most of it.
set.seed(2026)
genes <- c("CD3E", "CD3D", "IL7R", "CD8A",                  # T-cell markers
           "CD14", "LYZ", "S100A8", "FCGR3A",               # monocyte markers
           "MS4A1", "CD79A", "GNLY", "NKG7", "PPBP", "FCER1A",  # B, NK, platelet, DC
           "ISG15", "IFI6", "MX1", "IFIT3",                 # interferon-stimulated genes
           "ACTB", "GAPDH", "B2M", "MALAT1", "TMSB4X", "EEF1A1",  # highly expressed
           "MT-CO1", "MT-ND1", "MT-ATP6", "MT-CYB",         # mitochondrial
           "RPL13", "RPS27", "RPL32", "RPS18")              # ribosomal
# Average counts per gene in a typical T cell and in a typical monocyte:
mean_t <- c(6, 5, 4, 2, 0.2, 0.6, 0.4, 0.1, 0.1, 0.1, 0.5, 0.6, 0.05, 0.05,
            1, 0.8, 0.6, 0.4, 25, 6, 30, 15, 20, 18, 3, 2, 2, 1.5, 12, 15, 10, 9)
mean_mono <- c(0.2, 0.2, 0.3, 0.1, 7, 30, 18, 1.5, 0.1, 0.1, 0.3, 0.4, 0.1, 0.3,
               1.5, 1.2, 0.9, 0.6, 35, 9, 30, 12, 25, 16, 3, 2, 2, 1.5, 9, 11, 8, 7)
is_isg <- genes %in% c("ISG15", "IFI6", "MX1", "IFIT3")
is_mt <- grepl("^MT-", genes)

n_cells <- 160
cell_type <- rep(c("T cell", "Monocyte"), each = 80)
condition <- rep(rep(c("control", "IFN-b"), each = 40), times = 2)
depth <- runif(n_cells, min = 0.6, max = 1.4)   # sequencing depth varies per cell
damaged <- sample(1:n_cells, 12)                # 12 randomly chosen damaged cells

counts <- matrix(0, nrow = length(genes), ncol = n_cells,
                 dimnames = list(genes, paste0("cell_", 1:n_cells)))
for (j in 1:n_cells) {
  lambda <- if (cell_type[j] == "T cell") mean_t else mean_mono
  if (condition[j] == "IFN-b") lambda <- lambda * if_else(is_isg, 8, 1)   # ISGs up 8x
  if (j %in% damaged) lambda <- lambda * if_else(is_mt, 6, 0.3)          # leaky cell
  counts[, j] <- rpois(length(genes), lambda * depth[j])                  # random counts
}

# Information about each cell (the "metadata"):
cell_info <- tibble(cell = colnames(counts),
                    cell_type = cell_type,
                    condition = condition)


# Part A - The count matrix ----

# Task A1
# How many genes and cells does counts have? Show the first 5 genes in the
# first 5 cells.


# Task A2
# Which 5 genes have the most counts in total (summed over all cells)?
# Hint: rowSums() and sort(..., decreasing = TRUE).


# Task A3
# What fraction of all entries in counts are zero?



# Part B - Quality control ----

# Task B1
# Add four columns to cell_info (the columns of counts are in the same order
# as the rows of cell_info, so you can use matrix results directly in
# mutate()):
#   n_count      = total counts per cell                 (Seurat: nCount_RNA)
#   n_feature    = number of genes detected per cell     (Seurat: nFeature_RNA)
#   percent_mt   = % of counts from genes starting with "MT-"   (percent.mt)
#   percent_ribo = % of counts from genes starting with "RPL" or "RPS"


# Task B2
# Plot histograms of n_feature and of percent_mt. Add a dashed vertical line
# at the thresholds we will use (n_feature 15, percent_mt 20) with
# geom_vline(xintercept = ..., linetype = "dashed"). Combine both plots with
# patchwork and save the figure as day4/qc_histograms.png.


# Task B3
# Add a column keep to cell_info that is TRUE for cells with percent_mt < 20
# AND n_feature >= 15. How many cells are kept? From which cell types and
# conditions do the removed cells come (count())?
# Then create counts_qc (only the kept cells) and info_qc (the matching rows
# of cell_info).



# Part C - Normalisation ----

# Task C1
# Normalise counts_qc exactly like Seurat's NormalizeData(): divide each cell
# (column) by its total counts, multiply by 10,000, then take log1p().
# Store the scaled values (before log1p) as normalised and the final values
# as log_norm. Check that every column of normalised sums to 10,000.



# Part D - One gene at a time ----

# Task D1
# Write a function log2_fc(group1, group2) that returns
#   log2(mean(group1) + 1) - log2(mean(group2) + 1)
# (positive = higher in group1; the +1 is a "pseudocount" that avoids log(0)).


# Task D2
# CD14: compare monocytes with T cells. Make a boxplot with jittered points
# of log_norm CD14 values per cell type. Then run a Wilcoxon test
# (exact = FALSE) on the log_norm values, and calculate the log2 fold change
# (monocytes vs T cells) on the normalised values with your function.


# Task D3
# ISG15: within MONOCYTES only, compare IFN-b-stimulated with control cells
# (Wilcoxon test + log2 fold change, IFN-b vs control).



# Part E - Every gene: marker genes and multiple testing ----

# Task E1
# Loop over all genes. For each gene, compare monocytes with T cells: store
# the Wilcoxon p-value (exact = FALSE, on log_norm) and the log2 fold change
# (monocytes vs T cells, on normalised) in two pre-allocated vectors. Then
# build a tibble called markers with the columns
#   gene, p_val, avg_log2FC,
#   p_val_adj = Bonferroni-adjusted p-values (this is what Seurat reports)
#   p_val_bh  = Benjamini-Hochberg-adjusted p-values


# Task E2
# How many genes are significant (< 0.05) using the raw p-values, the BH
# values and the Bonferroni values?


# Task E3
# Among the genes with p_val_adj < 0.05, show the 5 strongest monocyte
# markers (largest avg_log2FC; slice_max) and the 5 strongest T-cell markers
# (most negative avg_log2FC; slice_min).


# Questions
# Q1. Why do we remove cells with a high percentage of mitochondrial counts?
#     What could go wrong in later steps if we kept them?
# Answer:
#
# Q2. Why must counts be normalised before comparing a gene between cells?
#     Use the depth differences in this dataset in your argument.
# Answer:
#
# Q3. Interpret your results for CD14 (D2) and ISG15 (D3): what do the
#     p-values and log2 fold changes tell you, biologically?
# Answer:
#
# Q4. You tested 32 genes. A real dataset has about 20,000. If NO gene truly
#     differed, how many genes would you expect below p = 0.05 by chance?
#     Why does Seurat report Bonferroni-adjusted p-values, and how does that
#     differ from BH?
# Answer:



# Stretch tasks (optional) ----

# Stretch 1 - Volcano plot
# Plot avg_log2FC (x) against -log10(p_val_adj) (y), colour the genes with
# p_val_adj < 0.05, and label them with geom_text(aes(label = gene)).

# Stretch 2 - Did the composition change?
# After QC, are T cells and monocytes equally represented in both conditions?
# Make a table of cell_type by condition (info_qc) and run chisq.test().



# Before you finish ----
# 1. Restart R, run the whole script: no errors?
# 2. SAVE. Stage the script and day4/qc_histograms.png, COMMIT ("Day 4
#    homework: QC, normalisation and marker genes"), PUSH. Check github.com.
# 3. Well done - that's the end of Introduction to R. See you in Week 2 with Seurat!
