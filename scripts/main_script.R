# Main Script: Whelk Mark and recapture analysis
# Author: Philip Haupt
# Date: 25/09/2023
#----------------------
# Three components:
#. 1 Mark and recapture
#. 2 Size measurements from marked and recaptured whelks
#. 3 Water temperature data analysis - in situ water logger measurements
#----------------------

# Aims: Under what is happening with the whelk stocks off the North Kent Coast after the collapse in catches and reports of morbind and dead whelks in pots 2022 (Aug - Dec)
# Objectives: Monitor whelk population trends at near and far affected sites over time
# Understand water temperature trends at sea bed at near and far affected site and the correlation between whelk popualtion/catches and water temperature

#---------------------
# Size measurements

## Read in size data (from photogrammetric analysis)
source("./scripts/read_size_data.R")

## Descriptive statistic analysis
source("./scripts/descriptive_size_analysis.R", echo = TRUE)

## Descriptive statistics and plots by date
file.edit("./scripts/descriptive_size_analysis_by_date.R", echo = TRUE)


