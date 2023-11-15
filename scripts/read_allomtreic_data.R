# model development and testing

#libraries
library(tidyverse)
library(nlme)
library(lattice)
library(mgcv)

#-------------------------
dir_alo <- "C:/Users/Phillip Haupt/Documents/SUSTAINABLE FISHERIES/whelks/whelk_ogive/allometric_analysis/whelk_allometry"
# read in and prepare the the data
dat_essex <-
  read_csv(paste0(dir_alo, "./data/EMFF_whelk_data_Essex2018_2019_master_copy.csv")) %>%
  dplyr::select(
    Sample_ID,
    Location,
    Month,
    Season,
    Sex,
    Maturity,
    Total_weight,
    Shell_length,
    Min_width,
    GSI,
    aGSI,
    Penis_length
  )

dat_kent <-
  read_csv(paste0(dir_alo, "./data/EMF_whelk_data_Kent_2018_2019_clean_two_year_dates.csv")) %>%
  dplyr::mutate(Location = "Kent") %>%
  dplyr::select(
    Sample_ID,
    Location,
    Month,
    Season,
    Sex,
    Maturity,
    Total_weight,
    Shell_length,
    Min_width,
    GSI,
    aGSI,
    Penis_length)

#dropped #body_weight,
#gonad_weight,
#foot_weight, as these are not independent of total weight

dat <- bind_rows(dat_kent, dat_essex)


# make all lower case names
names(dat) <-  tolower(names(dat))


# Specify factors in data set
dat$location <- factor(dat$location, ordered = FALSE)
dat$month<-factor(dat$month,ordered=FALSE) # should this be DATE?
dat$sex <-factor(dat$sex,ordered=FALSE) 
dat$season<-factor(dat$season,levels = c("Spring", "Summer", "Autumn", "Winter"))
str(dat)

# Remove records with no weight, or no shell length
dat <- dat %>% dplyr::filter(!is.na(total_weight) & !is.na(shell_length) & !is.na(sex))

# Add rescaled values - to avoid variance structures with high (>100) values: see later on this will be needed.
dat <- dat %>% mutate(shell_length_cm = shell_length/10,
                      min_width_cm = min_width/10)


#-------------------------------
# TRANSFORMATION
# add log + 1 variables
dat <- dat %>% mutate(shell_length_log = log(shell_length+1),
                      total_weight_log = log(total_weight+1),
                      min_width_log = log(min_width+1))

