# Assign event numbers

library(tidyverse)
library(data.table)


# Creates MArk and recapture event ids./grps

size_dat <- size_dat %>%
  mutate(event_type = if_else(date %in% c("2023-06-13", "2023-06-14"), "M", "R")) %>%
  #group_by(date) %>%
  mutate(event_number = group_indices(., date)) %>%
  #dplyr::ungroup() %>%
  mutate(
    event_code = if_else(
      event_type %in% c("M"),
      paste0(event_type),
      paste0(event_type, event_number - 2)
      )
    ) %>%
      relocate(unique_id,
               date,
               event_type,
               event_number, event_code
      )


write.csv(size_dat, "whelk_pot_data_logger_water_temperature_20230502-20230809_copy_20231011.csv")


