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

## Read in size data (from photometric analysis)
source("./scripts/read_size_data.R")

## Descriptive statistic analysis
source("./scripts/descriptive_size_analysis.R", echo = TRUE)

## Descriptive statistics and plots by date
source("./scripts/descriptive_size_analysis_by_date.R", echo = TRUE)

#--------------------
# Water temperature at depth (Seabed in situ loggers) analysis
# In Situ Temp and Depth measurement data
source("./scripts/read_TD_data.R")

# plots - time series
source("./scripts/plot_temp.r")

# plot temperature at days
source("./scripts/number_days_at_temperature_plots.R", echo = TRUE)

#-------------------
# Mark and recapture populations assessment
## Read and clean mark recapture data set.
source(("./scripts/read_mark_and_recapture_data.R")) # START HERE

## Construct data in required input format for ... analysis
## planning on using Jolly-Seber analysis if possible because Suspect the population to be open.
library("mra")

# Testing assumption:
## 1) Testing if the animals have fully mixed back into the population: proportions of marked to unmarked animals are equal among sub-samples ( i.e. per pot)
file.edit("./scripts/")


## 2) Testing whether a population is closed: If the population is OPEN (not closed) the number of marked individuals recaptured will decline in successive sampling events.
## Our animals being returned to sea would be open to immigration, emigrations and mortality such as predation (though limited fishing pressure): all reasons that the proportion should decline.
## Proportion of recaptures, Rank values (1 - 10), Calculate Pearson correlation between ranks, then Spearman's rank correlation coefficient (rs). One tailed test - only oncerend with declines.

## Analysis using X, Y or Z formula:
