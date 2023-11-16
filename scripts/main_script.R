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

## Plot data by pot with errors
file.edit("./scripts/plot_size_by_pot.R")
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
source("./scripts/read_mark_and_recapture_data.R") # START HERE

# Testing assumption:
## 1) Testing if the animals have fully mixed back into the population: proportions of marked to unmarked animals are equal among sub-samples ( i.e. per pot)
#source("./scripts/test_fully_mixed_population.r", echo = TRUE) 
# Suggests the population is only fully mixed by recapture two, unless 1/0 are OK.?


## 2) Testing whether a population is closed: If the population is OPEN (not closed) the number of marked individuals recaptured will decline in successive sampling events.
## Our animals being returned to sea would be open to immigration, emigrations and mortality such as predation (though limited fishing pressure): all reasons that the proportion should decline.
## Proportion of recaptures, Rank values (1 - 10), Calculate Pearson correlation between ranks, then Spearman's rank correlation coefficient (rs). One tailed test - only concerend with declines.
# - NO decline observed - but here is the test
file.edit("./scripts/test_open_closed_population.R")

## Analysis using X, Y or Z formula:
# Lincoln-Peterson
file.edit("./scripts/lincoln-petersen_pop_estimate.R")
# density
file.edit("./scripts/density_estimates.R")

# Jolly-Seber
file.edit("./scripts/jolly-seber_pop_estimate.R")


## Variation in mark and catch rates & correspondence with whelk returns?
file.edit("./scripts/captures_from_mark_recapture.R")

#---------------------------------------------------------------
# Density and biomass calculations from length weight allometry
# Read in whelk allomtreic training data set for developing relationship
source("./scripts/read_allomtreic_data.R")

file.edit("./scripts/length_weight_calculations.R")# see C:/Users/Phillip Haupt/Documents/SUSTAINABLE FISHERIES/whelks/whelk_ogive/allometric_analysis/whelk_allometry/length_weight_cals.R for source

file.edit("./scripts/biomass_estimates.R")

# to get a stock estiamte we now only need a estimation of the total area of whelks - assuming a similar density - we can work it out... from the above calculations which would yield about 35.kg/whelk/500m2