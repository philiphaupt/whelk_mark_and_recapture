library(tidyverse)
library(data.table)

## Construct data in required input format for ... analysis
## planning on using Jolly-Seber analysis if possible because Suspect the population to be open.

# Lincoln - Petersen index
## NOTES: 
# Only m1-r2 - population appears fully mixed between pots suggesting to only use this data - but this may be influenced by micro scale food availability/movement dynamics?
# using the first two days as marking - and then only counting individuals that were recaptured on the third event, because a the time of the second event the population was not fully mixed

# Lincoln - Petersen index
# Formula: N = (C/R)*M

# M - Individuals marked (M1)  = total number caught first event. (My case first two events from Margate)
# C - Total number captured during event 3 # I am using 3, COULD ALSO HAVE USED EVENT 2, BUT DID NOT SATISFY ASSUMPTION THAT THE POPULATION HAS FULLY MIXED
# R - Total number recaptured at event 3. # I am using 3

# Lincoln-Petersen as a function:
my_lincoln_Petersen_index <- function(C, R, M){
  N = (C/R)*M
}

# USER INPUT - can be moved to main script - or grouped??
site = "Margate"

# data prep for population size analysis----------------move to separate script
dat_prep <- mr_dat %>%
  group_by(location_abbrv, date, string_number, string_section, deploy_type) %>%
  summarise(
    total_whelks_caught_event = sum(total_whelks_caught),
    r1_totals = sum(recapture_1),
    r2_totals = sum(recapture_2),
    total_unbanded_whelks = sum(captured_unbanded_whelks),
    total_whelks_caught_m1r1 = if_else(
      is.na(r2_totals),
      sum(total_unbanded_whelks + r1_totals),
      NA
    ),
    total_whelks_caught_m1r2 = if_else(
      r2_totals >= 0,
      sum(total_unbanded_whelks + r1_totals),
      NA
    ),
    total_whelks_caught_m2r2 = if_else(
      r2_totals >= 0,
      sum(total_unbanded_whelks + r2_totals),
      NA
    ),
    proportion_marked_recaptures_m1r1 = r1_totals / total_whelks_caught_m1r1,
    proportion_marked_recaptures_m1r2 = r1_totals / total_whelks_caught_m1r2,
    proportion_marked_recaptures_m2r2 = r2_totals / total_whelks_caught_m2r2
  )

# Lincoln-Petersen data prep-------
# M
marked_1 <- dat_prep %>% 
  ungroup() %>% 
  dplyr::filter(location_abbrv == site) %>% 
  dplyr::filter(deploy_type %in% c("m")) %>%
  dplyr::mutate(date_mark_conlcuded = last(date)) %>% 
  group_by(date_mark_conlcuded, string_number, string_section, deploy_type) %>% 
  summarise(M1 = sum(total_unbanded_whelks),
            C = sum(total_whelks_caught_event)
            ) %>% 
  ungroup() %>% 
  rename(date = date_mark_conlcuded)

# Marked subsequently
marked_n <- dat_prep %>% 
  ungroup() %>% 
  dplyr::filter(location_abbrv == site) %>% 
  dplyr::arrange(date) %>%
  dplyr::filter(deploy_type %in% c("rm")) %>% 
  group_by(date, string_number, string_section, deploy_type) %>% 
  summarise(M = sum(total_unbanded_whelks)) %>%
  ungroup() %>% 
  mutate(event = frank(date, ties.method="dense")+1) %>% 
  pivot_wider(names_from = event, values_from = M, names_prefix = "M")

# R
recaptured <- dat_prep %>% 
  ungroup() %>% 
  dplyr::filter(location_abbrv == site) %>% 
  dplyr::arrange(date) %>% 
  dplyr::filter(deploy_type == "rm") %>% 
  group_by(date, string_number, string_section, deploy_type) %>% 
  summarise(Rm1 = sum(r1_totals),# number of whelks recaptured from the first marking event - during the first or second capture event
            Rm2 = sum(r2_totals)) %>% # number of whelks recaptured from the second marking event - during the first or second capture event
  ungroup()

# C
captured <- dat_prep %>% 
  ungroup() %>% 
  dplyr::filter(location_abbrv == site) %>% 
  dplyr::arrange(date) %>% 
  dplyr::filter(deploy_type == "rm") %>% 
  group_by(date, string_number, string_section, deploy_type) %>% 
  summarise(C = sum(total_whelks_caught_event)#,
            #C2 = sum(total_whelks_caught_m1r1),
            #C3 = sum(total_whelks_caught_m1r2+total_whelks_caught_m2r2)
            ) %>% 
  ungroup()

# Lincoln_Petersen data final
lp_dat <- marked_n %>%
  bind_cols(recaptured %>% select(Rm1, Rm2)) %>%
  bind_cols(captured %>% select(C)) %>%
  ungroup() %>%
  dplyr::select(date,
                string_number,
                string_section,
                C, # C2 Total WHELKS CAUGHT SECOND EVENT
                Rm1,# Recaptured marked event 1
                M2, # should be the difference of C2 - Rm1
                Rm2,# Recaptured marked event 2
                #C3, # TOTAL WHELKS CAUGHT THIRD EVENT
                M3 # Total numbers caught during third occasion/event
                ) %>% 
  bind_rows(marked_1) %>% 
  dplyr::arrange(date) %>% 
  dplyr::select(-deploy_type) %>% 
  dplyr::relocate(date,
                  string_number,
                  string_section,
                  C, #from initial marking event M1
                  M1 #from initial marking event M1
                  )
  

#calculation---------
# Per string
lp_pop_vector <- my_lincoln_Petersen_index(C = lp_dat$C, R = lp_dat$Rm1, M = marked_1$M1) %>% round(.,0) %>% as.vector()
lp_pop_matrix <- matrix(lp_pop_vector, nrow = 3, ncol = 2, byrow = TRUE) 
print(lp_pop_matrix)



lp_pop_df <- lp_pop_matrix %>% 
  as_tibble() %>% 
  dplyr::rename(N_a = V1, 
         N_b = V2)
rm(lp_pop_matrix, lp_pop_vector)


# Repeat this for Whitstable when more data


  
