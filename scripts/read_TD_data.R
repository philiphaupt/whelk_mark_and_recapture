# Read Temperature Depth log data
library(tidyverse)
library(readxl)
library(data.table)

#---------------------
#NOT RUN: This solution will not work if you are using OneDrive for Business and your admin has disabled the use of public file sharing via links
# url1<-"https://keifca-my.sharepoint.com/personal/philip_haupt_kentandessex-ifca_gov_uk/Documents/whelk_pot_data_logger_water_temperature_20230502-20230809.xlsx?web=1"
# 
# 
# GET(url1, write_disk(tf <- tempfile(fileext = ".xlsx")))
# td_dat <- read_excel(tf, 1L)
getwd()
my_wd <- getwd()

#----------------------------------------
#my_wd <- "C:/Users/philip.haupt/OneDrive - Kent & Essex Inshore Fisheries and Conservation Authority/data_analysis/whelk/whelk__mark_and_recapture_2023/whelk_mark_and_recapture_analysis"
#C:\Users\philip.haupt\OneDrive - Kent & Essex Inshore Fisheries and Conservation Authority\data_analysis\whelk\whelk__mark_and_recapture_2023\mark_and_recapture_analysis\data
# td_dat_early_compiled <- readxl::read_xlsx(paste0(my_wd, "/data/whelk_pot_data_logger_water_temperature_20230502-20230809_copy_20231011.xlsx")) %>% 
#   select(pkey_td_log_id,
#          fkey_record_on_deployment,
#          dates = date_correct_all...11,
#          times = time,
#          date_time =date_time,
#          temperature = temperature_degrees_celsius,
#          depth = water_depth_meter,
#          status = `...16`,
#          logger_id = Logger_id,
#          location) %>% 
#   mutate(dates = format(as.POSIXct(date_time), "%Y-%m-%d"),
#          times = format(as.POSIXct(date_time), "%H:%M")) %>% 
#   group_by(dates) %>% 
#   mutate(status = ifelse(abs(depth - lag(depth, default = first(depth))) > 0.5| abs(depth - lag(depth, default = first(depth))) < -0.5, 
#                          "emerged", 
#                          "submerged"),
#          temp_change = abs(temperature - lag(temperature, default = first(temperature))),
#          temp_change_status = ifelse(temp_change > 0.35, "remove", "keep")
# ) %>% 
#   mutate(start_date_status == case_when(location %like% "Margate" & dates > "2023-06-12" ~ "keep", "remove")) %>%  # start date filter
#   filter(status == "submerged" & temp_change_status == "keep" & start_date_status == "keep") %>%   
#   ungroup()

##---------
td_dat_early_compiled <- readxl::read_xlsx(paste0(my_wd, "/data/whelk_pot_data_logger_water_temperature_20230502-20230809_copy_20231011.xlsx")) %>% 
  select(pkey_td_log_id,
         fkey_record_on_deployment,
         dates = date_correct_all...11,
         times = time,
         date_time = date_time,
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
         depth_status = if_else(depth<0.1, "emerged", "submerged"),
         temp_change = abs(temperature - lag(temperature, default = first(temperature))),
         temp_change_status = ifelse(temp_change > 0.35, "remove", "keep"),
         start_date_status = case_when(location %like% "Margate" & dates > "2023-06-12" ~ "keep",
                                       location %like% "Studhill" ~ "keep",
                                       TRUE ~ "remove")) %>%  # start date filter
  filter(status == "submerged" & temp_change_status == "keep" & start_date_status == "keep" & depth_status == "submerged") %>% 
  mutate(file_name = "whelk_pot_data_logger_water_temperature_20230502-20230809_copy_20231011.xlsx") %>% 
  ungroup() %>% 
  select(-start_date_status, -pkey_td_log_id)


# Needs AM PM sorting: Add column that adds "AM" or "PM" based on time and position, over writing the AM PM.

# Save
from_date <- unlist(arrange(td_dat_early_compiled, dates) %>% first() %>% select(dates))
to_date <- unlist(arrange(td_dat_early_compiled, dates) %>% last() %>% select(dates))
write_csv(td_dat_early_compiled, paste0("./data_out/td_dat_early_compiled_from_", from_date, "_to_", to_date,".csv"))



#----------------------------------------
# Read in second file - will need to make this a function in future
# td_add_on <- read_table("./data/20231002 - 20231106_studhill_data.txt", skip = 14, 
#                         col_names = FALSE
# ) %>% 
#   rename(fkey_record_on_deployment = X1, 
#          dates = X2,
#          times = X3,
#          temperature = X4,
#          depth = X5) %>% 
#   mutate(dates = dmy(dates),  # Parse the date using lubridate
#          dates = format(dates, "%Y-%m-%d"),  # Reformat the date
#          times = format(as.POSIXct(times, format = "%H:%M"), "%H:%M:%S"),
#          date_time = as.POSIXct(paste(dates, times), format = "%Y-%m-%d %H:%M:%S"),
#          status = ifelse(abs(depth - lag(depth, default = first(depth))) > 0.5 | 
#                            abs(depth - lag(depth, default = first(depth))) < -0.5, 
#                          "emerged", 
#                          "submerged"),
#          temp_change = abs(temperature - lag(temperature, default = first(temperature))),
#          temp_change_status = ifelse(temp_change > 0.35, "remove", "keep")
#   ) %>% 
#   filter(status == "submerged" & temp_change_status == "keep")


## Working ON BELOW: START HERE: THIS I SNOT WORKING PROPERLY - IT IS NOT Getting the logger id  into the columns. Check if necessary - cause merged data seems to have this captured!
#-------------------------------------------------
td_add_on_fn <- function(data_in, skip_nrows = 14, column_names = FALSE) {
  # Extract location from the file name
  filename <- basename(data_in)
  loc_name <- str_match(filename, "(?<=_)[A-Za-z]+(?=_TD_data)")[, 1] %>%
    tools::toTitleCase()
  
  # Read logger ID from the original text file
  temp_logger_id <- read_table(data_in, n_max = 13, col_names = FALSE) %>%
    slice(13) %>%
    pull(X3) %>% 
    str_extract("C.*(?=DAT)")
  
  # Read the data
  read_table(data_in, skip = skip_nrows, col_names = column_names) %>%
    rename(fkey_record_on_deployment = X1,
           dates = X2,
           times = X3,
           temperature = X4,
           depth = X5) %>%
    mutate(dates = dmy(dates),  # Parse the date using lubridate
           dates = format(dates, "%Y-%m-%d"),  # Reformat the date
           times = format(as.POSIXct(times, format = "%H:%M"), "%H:%M:%S"),
           date_time = as.POSIXct(paste(dates, times), format = "%Y-%m-%d %H:%M:%S"),
           status = ifelse(abs(depth - lag(depth, default = first(depth))) > 0.5 |
                             abs(depth - lag(depth, default = first(depth))) < -0.5,
                           "emerged",
                           "submerged"),
           depth_status = if_else(depth<0.1, "emerged", "submerged"),
           temp_change = abs(temperature - lag(temperature, default = first(temperature))),
           temp_change_status = ifelse(temp_change > 0.35, "remove", "keep")
    ) %>%
    filter(status == "submerged" & temp_change_status == "keep" & depth_status == "submerged") %>%
    mutate(file_name = filename, 
           location = loc_name,
           logger_id = temp_logger_id)
}

#data_out <- td_add_on_fn("./data/raw_data/20231106-20240213_Studhill_TD_data_0-16C11830.dat")# test

library(purrr)

# Define function to apply td_add_on_fn to a single file
process_file <- function(file_path) {
  td_add_on_fn(file_path)
}

# List files in directory
directory_path <- "./data/raw_data"
file_paths <- list.files(path = directory_path, pattern = "\\.DAT$", full.names = TRUE)

# Apply td_add_on_fn to each file
processed_data <- lapply(file_paths, process_file)

# Merge data frames into a single data frame
merged_data <- do.call(bind_rows, processed_data)
merged_data <- merged_data %>% relocate(names(td_dat_early_compiled))
from_date <- unlist(arrange(merged_data, dates) %>% first() %>% select(dates))
to_date <- unlist(arrange(merged_data, dates) %>% last() %>% select(dates))
write_csv(merged_data, paste0("./data_out/merged_data_from_", from_date, "_to_", to_date,".csv"))

rm(processed_data)


#----
# merged_data %>% filter()
td_dat_early_compiled %>% filter(date > "2023-08-29")
merged_data %>% filter(date == "2023-08-30")
