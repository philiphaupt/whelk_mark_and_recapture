# Aim Read mark and recapture data

library(tidyverse)
library(readxl)
# most up to date data:
# https://keifca-my.sharepoint.com/personal/philip_haupt_kentandessex-ifca_gov_uk/Documents/whelk_banding_survey_form_2023_PH.xlsx?web=1
# time specific copy:whelk_banding_survey_form_2023_PH_cleaned_copy_20231020 in data directory needs updating when new data are collected.

#Read in mark and recapture data
pots_dat <- readxl::read_xlsx("./data/whelk_banding_survey_form_2023_PH_cleaned_copy_20231020.xlsx", sheet = "pots_frm")
sample_section_dat <- readxl::read_xlsx("./data/whelk_banding_survey_form_2023_PH_cleaned_copy_20231020.xlsx", sheet = "sample_section_frm")
string_dat <- readxl::read_xlsx("./data/whelk_banding_survey_form_2023_PH_cleaned_copy_20231020.xlsx", sheet = "string_frm")

# join data tables together by data keys
string_and_section_dat <- right_join(string_dat,sample_section_dat, by = c("pkey_deploy_id" = "fkey_deploy_id"))

# join pots to samples and strings
mr_dat_raw <- right_join(string_and_section_dat, pots_dat, by = c("pkey_opcode" = "fkey_opcode"))

# NOT IN FUNCTION 
`%!in%` = function(x, y) !(x%in%y)

# filter out deployment data - (not of interest for calculations, only for records)
mr_dat <- mr_dat_raw %>% dplyr::filter(deploy_mark_recapture.x %!in% c("d")) %>% 
  dplyr::select(fkey_deploy_id = pkey_deploy_id,
                deploy_type = deploy_mark_recapture.x, 
                date,
                soak_time,
                location_name,
                depth_m,
                string_number = string_number.x,
                number_of_sections_in_string,
                number_of_baited_pots_on_string,
                distance_between_pots,
                direction,
                fkey_opcode = pkey_opcode,
                start_lat_dm = start_lat_dm.y,
                start_long_dm = start_long_dm.y,
                end_lat_dm = end_lat_dm.y,
                end_long_dm = end_long_dm.y,
                pkey_deploy_pot_id,
                KEIFCA_tag_id,
                data_looger_id = data_logger_id.x,
                captured_unbanded_whelks,
                captured_unbanded_weight_g,
                number_marked = no_MARKED,
                mark_colour_used_on_day_large_25x13,# = colour_mark_on_day_large_25x15,
                mark_colour_used_on_day_medium_20x10,# = colour_medium_20x10,
                mark_colour_used_on_day_medium_10x6,# = colour_small__15x10,
                recap_blue_large = recap_bluebands,
                recap_red_small = recap_small_red,
                recap_green_medium = recap_green,
                recap_red_large = recap_large_red,
                recap_black_medium = black_medium 
                #total_recaptures = `Total recaptures`
                ) %>% 
  mutate(location_abbrv = if_else(location_name == "West end inner gully near Margate Hook",
                                  "Margate",
                                  "Whitstable")
         ) %>% 
  mutate(captured_unbanded_whelks = as.numeric(captured_unbanded_whelks), 
         recapture_1 = if_else(location_abbrv == "Margate",
                               recap_blue_large + recap_red_small,
                               recap_red_large),
         recapture_2 = if_else(location_abbrv == "Margate",
                               recap_green_medium, 
                               recap_black_medium)
         )

# housekeeping
rm(pots_dat, string_and_section_dat, sample_section_dat, string_dat, mr_dat_raw)



