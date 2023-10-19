# Aim Read mark and recapture data

library(tidyverse)
library(readxl)
# most up to date data:
# https://keifca-my.sharepoint.com/personal/philip_haupt_kentandessex-ifca_gov_uk/Documents/whelk_banding_survey_form_2023_PH.xlsx?web=1
# time specific copy:whelk_banding_survey_form_2023_PH_copy_20231017 in data directory needs updating when new data are collected.

#Read in mark and recapture data
pots_dat <- readxl::read_xlsx("./data/whelk_banding_survey_form_2023_PH_copy_20231017.xlsx", sheet = "pots_frm")
sample_section_dat <- readxl::read_xlsx("./data/whelk_banding_survey_form_2023_PH_copy_20231017.xlsx", sheet = "sample_section_frm")
string_dat <- readxl::read_xlsx("./data/whelk_banding_survey_form_2023_PH_copy_20231017.xlsx", sheet = "string_frm")

# join data tables together by data keys
string_and_section_dat <- right_join(string_dat,sample_section_dat, by = c("pkey_deploy_id" = "fkey_deploy_id"))

# join pots to samples and strings
mr_dat <- right_join(string_and_section_dat, pots_dat, by = c("pkey_opcode" = "fkey_opcode"))

# NOT IN FUNCTION 
`%!in%` = function(x, y) !(x%in%y)

# filter out deployment data - (not of interest for calculations, only for records)
mr_dat_cln <- mr_dat %>% dplyr::filter(deploy_mark_recapture.x %!in% c("d"))

# housekeeping
rm(pots_dat, string_and_section_dat, sample_section_dat, string_dat, mr_dat)



