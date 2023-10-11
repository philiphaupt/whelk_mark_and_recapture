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


td_dat <- readxl::read_xlsx("./data/whelk_pot_data_logger_water_temperature_20230502-20230809_copy_20231011.xlsx") %>% 
  select(pkey_td_log_id,
         fkey_record_on_deployment,
         date = date_correct_all...11,
         time,
         date_time =date_time,
         temperature = temperature_degrees_celsius,
         depth = water_depth_meter,
         status = `...16`,
         logger_id = Logger_id,
         location) %>% 
  dplyr::filter(status == "submerged") # only keep clean records

