# =============================================================================
# Day 1 - Homework: from a DNA sequence to a qPCR result
# Introduction to R for Biologists
# =============================================================================
#
# THE BIOLOGY
# When a virus infects a cell, the cell releases interferons: signalling
# proteins that warn neighbouring cells. Cells that receive the signal switch
# on hundreds of "interferon-stimulated genes" (ISGs). One of the most
# strongly induced is ISG15. Over this week we follow an imaginary lab that
# studies this interferon response. On Day 4 you will analyse a small
# single-cell dataset from the same lab, and in Week 2 the real thing.
#
# Today the lab starts small: with one gene.
#  - Part A: a short (made-up) DNA fragment from the coding sequence of an
#    ISG. You will count nucleotides and calculate the GC content.
#  - Part B: a qPCR experiment. Blood immune cells (PBMCs) were left
#    untreated or stimulated with interferon-beta (IFN-b) for 6 hours.
#    ISG15 expression was measured relative to the reference gene GAPDH.
#  - Part C: set up Git and GitHub, so that from tomorrow you can hand in
#    your homework through your own GitHub repository.
#
# WHERE TO WORK
# Today, work on this file inside the intro_to_R project (day1 folder).
# Tomorrow in class you will copy it into your GitHub repository.
#
# HOW TO ANSWER
#  - Write your code directly below each task.
#  - Write answers to the questions as comments starting with  # Answer:
#  - Use only what we covered today (Lectures 1 and 2).
#  - Before you finish, restart R (Session > Restart R), select everything
#    (Ctrl+A / Cmd+A) and run it (Ctrl+Enter / Cmd+Return). The whole script
#    should run without errors.
#
# Time: about 1 to 1.5 hours for Parts A-C. The stretch tasks are optional.
# =============================================================================


# Part A - A DNA fragment ----

# A made-up 60-base fragment from the coding sequence of an
# interferon-stimulated gene, written as one piece of text:
dna_string <- "ATGGGCTGCGACCTGACGGTGAAGATGCTGGCGGGCAACGAATTCCAGGTGTCCCTGTAA"

# The next line splits the text into single letters, so that every base
# becomes one element of a character vector. Just run it; strsplit() and the
# [[1]] at the end will make sense on Day 4.
dna <- strsplit(dna_string, split = "")[[1]]
dna[1:10]          # the first ten bases, one per element

# Task A1
# How many bases long is the fragment?
length(dna)

# Task A2
# Count how often each base (A, C, G, T) occurs. Hint: a comparison such as
# dna == "A" gives one TRUE/FALSE per base, and sum() counts the TRUEs.
# Store the four counts in a NAMED vector called base_counts, with the names
# A, C, G and T, for example: c(A = ..., C = ..., G = ..., T = ...)
# Then check that the four counts add up to the length from Task A1.
base_counts <- c(A = sum(dna == "A"), T = sum(dna == "T"), G = sum(dna == "G"), C = sum(dna == "C"))
base_counts

# Task A3
# Express each count as a percentage of all bases, rounded to 1 decimal
# place. (One line of vectorised code is enough.)
A3 <- round(base_counts / sum(base_counts) * 100, 1)
A3

# Task A4
# Calculate the GC content: the percentage of bases that are G or C.
# Round to 1 decimal place. Hint: %in% can test for two letters at once.

A4 <- round(sum(base_counts[3:4]) / sum(base_counts) * 100, 1)
A4

# Task A5
# Show the first three bases (the start codon) and the last three bases
# (the stop codon). Use length() so that your code would also work for a
# fragment of a different length. Then use paste() with collapse = "" to
# show each codon as one word.

start_codon <- paste(dna[1:3], collapse = "")
stop_codon <- paste(dna[58:60], collapse = "")

stop_codon <- paste(dna[(length(dna)-2):length(dna)], collapse = "")
stop_codon

# Task A6
# Use which() to find the positions of all G bases. At which position is
# the first G?
which(dna == "G")
# Answer: first G is at position 3

# Question A
# The human genome as a whole has a GC content of about 41%. Is this
# fragment GC-richer or GC-poorer than that? In the lab, GC content matters
# for PCR primer design: why could a very GC-rich primer cause problems?
# Answer: This fragment is GC-richer than the human genome. GC-rich primer creates greater stability in DNA, requiring a higher Tm that can cause polymerase to denature = inefficient PCR. 
A4 >= 41



# Part B - qPCR: does interferon switch on ISG15? ----

# Ct ("cycle threshold") = the PCR cycle at which the fluorescence of a
# sample crosses a set threshold. The more mRNA a sample started with, the
# EARLIER it crosses, so a LOWER Ct means MORE starting material. Each cycle
# roughly doubles the DNA, so 1 Ct difference is about a 2-fold difference.
#
# To compare samples fairly, every Ct is first corrected with a reference
# gene (GAPDH) that should not change between conditions. This is the
# "delta-delta-Ct" method:
#   delta_ct       = Ct(target gene) - Ct(reference gene)       per sample
#   delta_delta_ct = delta_ct(sample) - mean delta_ct(control samples)
#   fold change    = 2^(-delta_delta_ct)
#
# Ct values from three biological replicates per condition:
ct_isg15_control <- c(27.8, 28.1, 27.9)   # ISG15, untreated
ct_gapdh_control <- c(18.2, 18.4, 18.3)   # GAPDH, untreated
ct_isg15_ifn <- c(22.4, 22.1, 22.6)       # ISG15, IFN-b stimulated
ct_gapdh_ifn <- c(18.3, 18.1, 18.4)       # GAPDH, IFN-b stimulated
# (Within each condition, the three vectors are in the same sample order.)

# Task B1
# Calculate delta_ct for each sample: one vector called delta_ct_control and
# one called delta_ct_ifn. (Vectorised subtraction - no need to do it sample
# by sample.)
delta_ct_control <- ct_isg15_control - ct_gapdh_control
delta_ct_ifn <- ct_isg15_ifn - ct_gapdh_ifn
delta_ct_control
delta_ct_ifn

# Task B2
# Calculate the mean delta_ct of the control samples. Store it as
# mean_delta_ct_control. This is the baseline everything is compared with.
mean_delta_ct_control <- mean(delta_ct_control)
mean_delta_ct_ifn <- mean(delta_ct_ifn)
mean_delta_ct_control
mean_delta_ct_ifn

# Task B3
# Calculate delta_delta_ct for each IFN-b sample (delta_ct_ifn minus the
# control mean), and then the fold change 2^(-delta_delta_ct). Store the fold
# changes as fold_change_ifn and show them rounded to 1 decimal place.
# Finally, calculate the mean fold change.
delta_delta_ct_ifn <- delta_ct_ifn - mean_delta_ct_control
fold_change_ifn <- round(2^(-delta_delta_ct_ifn), 1)
fold_change_ifn

# Task B4
# Sanity check: repeat Task B3 for the CONTROL samples (their delta_ct minus
# their own mean). What values do you expect, and what do you get?
# Answer: I expect the values to be - since they are the control, so fold change = 1.
delta_delta_ct_control <- delta_ct_control - mean_delta_ct_control
fold_change_control <- round(2^(-delta_delta_ct_control), 1)
fold_change_control

# Task B5
# In which replicates (positions) is ISG15 induced more than 45-fold, and how
# many replicates is that? Use a comparison together with which() and sum().
which(fold_change_ifn > 45) # Position of replicates with fold change > 45-fold
sum(fold_change_ifn > 45) # Number of replicates with fold change > 45-fold 

# Task B6
# Gene expression studies (including single-cell RNA-seq) usually report the
# log2 fold change. Calculate log2() of fold_change_ifn and compare it with
# the delta_delta_ct values from Task B3. What do you notice?
log2(fold_change_ifn)
log2(fold_change_control)
# Answer: the delta_delta_ct_ifn values and log2() of fold_change_ifn are the same because log2(fold_change_ifn) = 2^(-delta_delta_ct_ifn)

# Question B
# (a) Is ISG15 switched on or off by interferon-beta, and by roughly how much?
# (b) Why do we subtract the GAPDH Ct instead of comparing ISG15 Ct values
#     directly? What could go wrong without a reference gene?
# Answer:
# (a) ISG15 is switched on by roughly 5 fold.
# (b) Without a reference gene, you cannot prove your genes increased in expression as there is no baseline fold change to compare it to.


# Part C - Set up Git and GitHub (about 20-30 minutes) ----

# Follow sections 3 to 6 of 00_setup/github_guide.md. You will:
#   [X] create your course repository from the template on GitHub
#   [X] add your instructor as a collaborator and send them the link
#   [X] tell Git your name and email
#   [X] create a personal access token (PAT) and store it with gitcreds
#
# Type the commands from the guide in the CONSOLE, not in this script.
# NEVER paste your token into this file or any other file: a token works
# like a password.
#
# If something goes wrong, note the exact error message here and bring it
# to class tomorrow - we start Day 2 by fixing GitHub problems.
# Problems / error messages:



# Stretch tasks (optional) ----

# Stretch 1 - Reverse complement
# DNA is double-stranded. The other strand is the REVERSE COMPLEMENT: each
# base is swapped for its partner (A<->T, G<->C), and the order is reversed.
# This named vector works as a lookup table:
complement_of <- c(A = "T", T = "A", G = "C", C = "G")
# Indexing it with the dna vector, complement_of[dna], returns the partner of
# every base (each element is still named after the original base).
# Build the reverse complement and show it as one string. Useful functions:
# unname() (removes the names), rev() (reverses a vector) and
# paste(..., collapse = ""). Check: it should start with "TTA".


# Stretch 2 - Melting temperature of a primer
# A forward PCR primer often matches the first ~20 bases of the target. A
# rough estimate of its melting temperature (the Wallace rule) is:
#   Tm = 2 x (number of A + T) + 4 x (number of G + C)     in degrees C
# Calculate the Tm of a primer made of the first 20 bases. Many protocols aim
# for a Tm of roughly 52-65 C. Is this primer inside that range? Which
# property of the sequence explains your result?



# Before you finish ----
# 1. Restart R and run the whole script once more: no errors?
# 2. SAVE this file (Ctrl+S / Cmd+S).
# 3. Tomorrow in class, copy it into the day1 folder of your GitHub
#    repository, COMMIT it with a meaningful message (for example
#    "Add Day 1 homework: DNA and qPCR analysis") and PUSH it to GitHub.
#    From Day 2 on, you will save, commit and push at the end of every
#    homework.
