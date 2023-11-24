library(tidyverse)

mean_weight_per_whelk <- size_dat %>% 
  #group_by(event_type) %>% 
  summarise(mean(weight_g_pred, na.rm = TRUE),
            sdev = sd(weight_g_pred, na.rm = TRUE))
  # ggplot()+
  # geom_boxplot(aes(x = sample_number, y = length, group = pot_number)) +
  # facet_wrap(event_type~sample_number)
  
  
dat_prep %>% 
  mutate(biomass_whelks_caught = total_whelks_caught_event*mean_weight_per_whelk[[1,2]]/1000) %>% 
  select(biomass_whelks_caught)
