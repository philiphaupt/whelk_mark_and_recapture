# aim read in size data

library("tidyverse")


# Read in Excel table data: source data
#size_dat <- readxl::read_xlsx("C:/Users/Phillip Haupt/Documents/SUSTAINABLE FISHERIES/whelks/whelk__mark_and_recapture_2023/size_measurements/whelk_photo_measurement_data_margate_hook_june-august_2023_compiled_20230824.xlsx") 

# modified using

## Assign recapture event numbers
#source("./scripts/assign_mark_recapture_event_numbers.r")

# and re-written as :"whelk_pot_data_logger_water_temperature_20230502-20230809_copy_20231011.csv"
# which includes event ID numbers!

# SKIP TO HERE (and keep original code)
size_dat <- read_csv("whelk_pot_data_logger_water_temperature_20230502-20230809_copy_20231011.csv")

                              