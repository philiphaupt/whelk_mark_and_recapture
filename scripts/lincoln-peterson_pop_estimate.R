## Construct data in required input format for ... analysis
## planning on using Jolly-Seber analysis if possible because Suspect the population to be open.
# testing lincoln - peterson index
library("mra")
# Only
# m1 r2 - population appears fully mixed - but this may be influenced by micro scale food availability/movement dynamics?
# using the first two days as marking - and then only counting individuals that were recaptured on the third event, becuase a tthe time of the second event the populaiton was not fully mixed
# Formula: N = (C/R)*M

# M - Individuals marked (M1)  = total number caught first event/
# C - Total number captured event 2/3
# R - Total number recaptured at event 2/3.

my_lincoln_peterson_index <- function(C, R, M){
  N = (C/R)*M
}


dat_prep <- mr_dat %>%
  mutate(string_section = str(fkey_opcode, ))
  group_by(location_abbrv, date, string_number, deploy_type) %>%
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
    #sum(total_unbanded_whelks + r2_totals),
    # sum(total_unbanded_whelks + r1_totals + r2_totals)
    proportion_marked_recaptures_m1r1 = r1_totals / total_whelks_caught_m1r1,
    proportion_marked_recaptures_m1r2 = r1_totals / total_whelks_caught_m1r2,
    proportion_marked_recaptures_m2r2 = r2_totals / total_whelks_caught_m2r2
  )

lincoln_peterson_data <- proportion_recaptures %>% 
  group_by(fkey_opcode) %>% 
  mutate(C = )
  
  




  
