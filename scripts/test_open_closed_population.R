## Construct data in required input format for ... analysis
## planning on using Jolly-Seber analysis if possible because Suspect the population to be open.
library("mra")

proportion_recaptures <- mr_dat %>%
  group_by(location_abbrv, date, fkey_opcode) %>%
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
  ) %>%
  filter(!is.na(r1_totals)) %>% 
  ungroup() %>% 
  group_by(location_abbrv, 
           #se
           ) %>% 
  mutate(Rank = rank(-proportion_marked_recaptures_m1r1),
         occasion = fkey_opcode) %>% 
  print(n = 10)
  

corr <-#proportion_recaptures %>% 
  #group_by(location_abbrv) %>% 
  cor.test(
    x = proportion_recaptures$proportion_marked_recaptures_r1,
    y = proportion_recaptures$proportion_marked_recaptures_r2,
    method = 'spearman'
  )
