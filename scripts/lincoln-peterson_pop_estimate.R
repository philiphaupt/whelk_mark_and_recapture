## Construct data in required input format for ... analysis
## planning on using Jolly-Seber analysis if possible because Suspect the population to be open.
# testing lincoln - peterson index
library("mra")
# Only
# m1 r2 - population appears fully mixed - but this may be influenced by micro scale food availability/movement dynamics?
# using the first two days as marking - and then only counting individuals that were recaptured on the third event, becuase a tthe time of the second event the populaiton was not fully mixed
# Formula: N = (C/R)*M

# M - Individuals marked (M1)  = total number caught first event/
# C - Total number captured event 2/3 # I am using 3
# R - Total number recaptured at event 2/3. # I am using 3

my_lincoln_peterson_index <- function(C, R, M){
  N = (C/R)*M
}

# data prep----------------
dat_prep <- mr_dat %>%
  mutate(string_section = str_sub(fkey_opcode, 2,2)) %>% 
  group_by(location_abbrv, date, string_number, string_section, deploy_type) %>%
  summarise(
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

# Margate data prep-------
#M
margate_marked1 <- dat_prep %>% 
  ungroup() %>% 
  dplyr::filter(location_abbrv == "Margate") %>% 
  dplyr::arrange(date) %>% 
  dplyr::slice(1:4) %>% 
  group_by(string_number, string_section, deploy_type) %>% 
  summarise(M = sum(total_unbanded_whelks))

#R
margate_marked1_recaptured2 <- dat_prep %>% 
  ungroup() %>% 
  dplyr::filter(location_abbrv == "Margate") %>% 
  dplyr::arrange(date) %>% 
  dplyr::slice(7:8) %>% 
  group_by(string_number, string_section, deploy_type) %>% 
  summarise(R = sum(r1_totals))

#C
margate_captured2 <- dat_prep %>% 
  ungroup() %>% 
  dplyr::filter(location_abbrv == "Margate") %>% 
  dplyr::arrange(date) %>% 
  dplyr::slice(7:8) %>% 
  group_by(string_number, string_section, deploy_type) %>% 
  summarise(C = sum(total_whelks_caught_m1r2))

# Lincoln_Peterson data final
margate_lp_dat <- margate_marked1 %>% bind_cols(margate_marked1_recaptured2) %>% bind_cols(margate_captured2) %>% 
  select(string_number = string_number...1,
         string_section = string_section...2,
         M,
         C,
         R)

#calculation---------
margate_lp_pop <- my_lincoln_peterson_index(C = margate_lp_dat$C, R = margate_lp_dat$R, M = margate_lp_dat$M)

# Repeat this for Whitstable when more data


  
