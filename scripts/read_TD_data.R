# Read Temperature Depth log data
library(tidyverse)
library(httr)
library(readxl)

#NOT RUN: This solution will not work if you are using OneDrive for Business and your admin has disabled the use of public file sharing via links
# url1<-"https://keifca-my.sharepoint.com/personal/philip_haupt_kentandessex-ifca_gov_uk/Documents/whelk_pot_data_logger_water_temperature_20230502-20230809.xlsx?web=1"
# 
# 
# GET(url1, write_disk(tf <- tempfile(fileext = ".xlsx")))
# td_dat <- read_excel(tf, 1L)
# getwd()


td_dat_early_compiled <- readxl::read_xlsx("./data/whelk_pot_data_logger_water_temperature_20230502-20230809_copy_20231011.xlsx") %>% 
  select(pkey_td_log_id,
         fkey_record_on_deployment,
         dates = date_correct_all...11,
         times = time,
         date_time =date_time,
         temperature = temperature_degrees_celsius,
         depth = water_depth_meter,
         status = `...16`,
         logger_id = Logger_id,
         location) %>% 
  mutate(dates = format(as.POSIXct(date_time), "%Y-%m-%d"),
         times = format(as.POSIXct(date_time), "%H:%M")) %>% 
  group_by(dates) %>% 
  mutate(status = ifelse(abs(depth - lag(depth, default = first(depth))) > 0.5| abs(depth - lag(depth, default = first(depth))) < -0.5, 
                         "emerged", 
                         "submerged"),
         temp_change = abs(temperature - lag(temperature, default = first(temperature))),
         temp_change_status = ifelse(temp_change > 1, "remove", "keep")
) %>% 
  filter(status == "submerged" & temp_change_status == "keep") %>% 
  ungroup()






td_add_on <- read_table("./data/20231002 - 20231106_studhill_data.txt", skip = 14, 
                        col_names = FALSE
) %>% 
  rename(fkey_record_on_deployment = X1, 
         dates = X2,
         times = X3,
         temperature = X4,
         depth = X5) %>% 
  mutate(dates = dmy(dates),  # Parse the date using lubridate
         dates = format(dates, "%Y-%m-%d"),  # Reformat the date
         times = format(as.POSIXct(times), "%H:%M"),
         status = ifelse(abs(depth - lag(depth, default = first(depth))) > 0.5 | 
                           abs(depth - lag(depth, default = first(depth))) < -0.5, 
                         "emerged", 
                         "submerged"),
         temp_change = abs(temperature - lag(temperature, default = first(temperature))),
         temp_change_status = ifelse(temp_change > 1, "remove", "keep")
  ) %>% 
  filter(status == "submerged" & temp_change_status == "keep")


# Location
# Extract location from the file name
filename <- "20231002 - 20231106_studhill_data.txt"
location_name <- str_match(filename, "_(?i)([a-z]+)(?=_data)")[, 2] %>% 
  tools::toTitleCase()


# Read logger ID from the original text file
logger_id <- read_table("./data/20231002 - 20231106_studhill_data.txt", n_max = 13, col_names = FALSE) %>%
  slice(13) %>%
  pull(X3) %>% 
  str_extract("C.*(?=DAT)")

# # Add logger_id column to td_dat
# td_dat <- td_dat %>%
#   mutate(logger_id = logger_id)

# Add logger_id column to td_add_on
td_add_on <- td_add_on %>%
  mutate(logger_id = logger_id,
         location = location_name,
         location = if_else(location == "Studhill", "Studhill off Whitstable", "Margate Hook inner west gully"))

td_dat <- bind_rows(td_dat, td_add_on)
# Display the resulting data frame
print(td_dat)
rm(td_dat_early_compiled, td_add_on)

