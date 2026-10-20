# =============================================================================
# Day 3 - Homework: a fluorescence time course
# Introduction to R for Biologists
# =============================================================================
#
# THE BIOLOGY
# Our lab built a reporter cell line: cells carry the gene for GFP (green
# fluorescent protein) behind a stress-responsive promoter, so the cells glow
# when that stress pathway is switched on. Cells were treated with a drug at
# 1 uM or 10 uM, or left untreated (control), and green fluorescence was read
# in a plate reader at 0, 6, 12 and 24 hours, three wells per condition.
# Three "blank" wells contain medium only: their signal is background (the
# medium and the plate glow a little, too).
# The plate reader exports WIDE data: one row per well, one column per time
# point (day3/data/fluorescence_timecourse.csv).
#
# WHERE TO WORK
# In your GITHUB REPOSITORY project. Plots go into day3/figures/.
#
# BEFORE YOU START: PART 0 TAKES A WHILE - START IT FIRST
# Part 0 installs the packages for Weeks 2-4 (Seurat, Bioconductor packages,
# ...). It downloads a lot and takes 20-40 minutes.
#
# HOW TO ANSWER
#  - Code below each task; answers as  # Answer: ...
#  - Restart R and run everything at the end: no errors allowed.
#
# Time: about 1.5 hours plus the installation. Stretch tasks are optional.
# =============================================================================


# Part 0 - Install the packages for Weeks 2-4 ----

# Option A (recommended): run the installation in the BACKGROUND, so you can
# keep working on Parts A-C meanwhile.
#   1. Open 00_setup/00_install_week2_packages.R from the intro_to_R folder
#      (File > Open File...).
#   2. Click the small arrow next to the "Source" button > "Source as
#      Background Job..." > Start. Progress appears in the "Background Jobs"
#      tab next to the Console.
# Option B: open the script and click Source, then wait until it finishes.
#
# When it is done, look at the SUMMARY at the end of the output and copy it
# below (or write "all OK"). Problems will be fixed at the start of Day 4.
# Installation summary:



# Packages ----
library(tidyverse)
library(patchwork)


# Part A - From wide to long ----

# Task A1
# Import day3/data/fluorescence_timecourse.csv as fluo_wide. How many wells
# are there, and how many per condition? (count())


# Task A2
# Reshape fluo_wide into long format (fluo_long) with one row per well and
# time point: put the column names into a column called time and the values
# into a column called signal. Then add a numeric column time_h with
# parse_number(). Check: how many rows should fluo_long have?



# Part B - Background correction, summaries and plots ----

# Task B1
# Write a function subtract_background(signal, background) that returns the
# signal minus the background.


# Task B2
# Calculate the background: the mean signal of all blank wells (all time
# points together). Store it as background.


# Task B3
# Create fluo_corrected from fluo_long: remove the blank wells and add a
# column signal_corrected using your function from B1.


# Task B4
# For each condition and time point, calculate n, the mean and the SD of
# signal_corrected (group_by + summarise). Store the result as fluo_summary.


# Task B5
# Plot fluo_summary: time on the x axis, mean corrected signal on the y axis,
# one coloured line (with points) per condition, and error bars of +/- 1 SD.
# Add axis labels with units. Save the plot as
# day3/figures/fluorescence_timecourse.png.


# Task B6
# Make a second plot showing every individual well (one line per well:
# group = well) with one panel per condition (facet_wrap). Combine both plots
# with patchwork (side by side, panels labelled A and B) and save the
# combined figure as day3/figures/fluorescence_combined.png.



# Part C - Functions, loops and decisions ----

# Task C1
# Write a function percent_change(value, baseline) that returns the change
# from baseline in percent: (value - baseline) / baseline * 100.
# Test it: percent_change(15, 10) should give 50.


# Task C2
# Using fluo_summary, loop over the three conditions. For each condition,
# store the percent change of the mean corrected signal from 0 h to 24 h in
# a pre-allocated named numeric vector called change_24h.


# Task C3
# Loop over change_24h and use if/else to label each condition as
# "responder" if its change is above 20%, otherwise "no response". Store the
# labels in a named character vector and print it.


# Task C4
# Back in fluo_corrected: which single well shows the largest corrected
# signal at 24 h? (filter + slice_max)


# Questions
# Q1. Describe the response over time and between doses. Is the effect
#     dose-dependent? When does the 10 uM signal clearly separate from the
#     control?
# Answer:
#
# Q2. Why subtract the background before calculating percent changes? Use
#     the numbers: what happens to the percent change of the 10 uM condition
#     if you forget the background correction?
# Answer:
#
# Q3. Your plot in B5 shows mean +/- SD. Would SE error bars look bigger or
#     smaller, and what would they tell the reader instead?
# Answer:



# Stretch tasks (optional) ----

# Stretch 1
# Write a function plot_condition(data, condition_name) that returns a plot
# of the individual wells of one condition. Loop over the three conditions
# and print() each plot.

# Stretch 2
# Use sapply() with your percent_change() function to calculate, for every
# well in fluo_wide (blanks excluded), the change from 0 h to 24 h after
# background correction. (Hint: give sapply() the row numbers.)



# Before you finish ----
# 1. Restart R, run the whole script: no errors?
# 2. SAVE. In the Git tab, stage the script AND the two PNG files in
#    day3/figures/, COMMIT ("Day 3 homework: fluorescence time course"),
#    PUSH, and check on github.com that the figures are there.
