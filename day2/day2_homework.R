# =============================================================================
# Day 2 - Homework: how does the culture medium affect cell growth?
# Introduction to R for Biologists
# =============================================================================
#
# THE BIOLOGY
# Before choosing which cells to profile with single-cell RNA-seq, our lab
# checks how the culture medium affects growth. Two cell lines were grown in
# three media:
#   - HeLa:    human cervical cancer cells
#   - NIH-3T3: mouse fibroblasts
#   - Control:      standard medium with 10% fetal calf serum
#   - Low serum:    only 1% serum. Serum supplies growth factors and hormones.
#   - High glucose: standard medium with extra glucose (more fuel)
# On days 1, 3, 5 and 7, the cell density (million cells per mL) and the
# viability (% live cells, trypan blue) were measured in three replicate
# flasks. A few measurements are missing (NA).
#
# WHERE TO WORK
# Open this file from your GITHUB REPOSITORY project (intro-to-r-<your name>),
# not from intro_to_R. The data file is in day2/data/ of your repository.
#
# HOW TO ANSWER
#  - Write your code below each task; answer questions as  # Answer: ...
#  - Use what we covered on Days 1 and 2. Load packages only at the top.
#  - At the end, restart R and run the whole script: no errors allowed.
#
# Time: about 1 to 1.5 hours. Stretch tasks are optional.
# =============================================================================


# Packages ----
library(tidyverse)


# Part A - Import and explore ----

# Task A1
# Import day2/data/cell_growth.csv with read_csv() and store it as growth.
# How many rows and columns are there? Use glimpse(): which type does R use
# for each column?


# Task A2
# How many values are missing in the density column, and how many in the
# viability column? Show the rows where density is missing.


# Task A3
# Turn condition into a factor with the levels in this order:
# "Control", "Low serum", "High glucose". Check the levels.
# Then use table() to count the flasks per cell line and condition.
# Is the design balanced (the same number everywhere)?



# Part B - Transform with dplyr ----

# Task B1
# Show the HeLa flasks on day 7: keep only the columns condition, replicate
# and density, and sort from highest to lowest density. Which condition
# reaches the highest densities?


# Task B2
# Add two columns to growth (and store the result as growth again):
#   cells_per_ml = density in cells per mL (density is in MILLION cells/mL)
#   log2_density = log2() of density


# Task B3
# Calculate the mean day-7 density of HeLa cells for EACH of the three
# conditions (one filter + mean per condition; don't forget the NAs).
# Round to 2 decimals. (This is tedious - tomorrow you will learn to do it in
# one step with group_by() and summarise().)


# Task B4
# By how much did HeLa cells in Control medium multiply between day 1 and
# day 7? Calculate mean density on day 7 divided by mean density on day 1.


# Task B5
# Which flasks have a viability below 85%? Use count() to see which cell
# lines and conditions they come from.


# Task B6
# Save your result from Task B1 as day2/data/hela_day7.csv. Also save the
# whole growth table (with the factor from A3 and the columns from B2) as
# day2/data/cell_growth_clean.rds. Note: the .rds file will NOT appear in
# GitHub's Git tab - your .gitignore excludes .rds files on purpose.


# Questions
# Q1. Which medium supports proliferation best, and which worst? Do both
#     cell lines respond in the same way? (Use B3, and filter NIH-3T3 day 7
#     to compare.)
# Answer:
#
# Q2. Low serum reduces both growth and viability. Suggest a biological
#     explanation.
# Answer:
#
# Q3. A colleague suggests replacing the missing densities with 0 "so that
#     the code runs". What would that do to your result in Task B3, and why is
#     it a bad idea?
# Answer:



# Stretch tasks (optional) ----

# Stretch 1 - Doubling time
# During exponential growth, the doubling time is
#   doubling_time = (t2 - t1) * log(2) / log(N2 / N1)
# where N1 and N2 are the densities at times t1 and t2 (log() = natural log).
# Calculate the doubling time (in days) of HeLa and of NIH-3T3 cells in
# Control medium between day 1 and day 7, using mean densities.
# Which cell line divides faster?


# Stretch 2 - Extremes
# Which single flask had the lowest viability (cell line, condition, day)?
# Which flask had the highest density of all?



# Before you finish ----
# 1. Restart R, run the whole script: no errors?
# 2. SAVE this file.
# 3. In the Git tab: stage day2_homework.R and day2/data/hela_day7.csv,
#    COMMIT with a meaningful message (e.g. "Day 2 homework: import,
#    NA handling and dplyr"), and PUSH to GitHub. Check on github.com.
