library(tidyverse)

size_dat %>% 
  group_by(event_type, sample_number) %>% 
  summarise(mean(weight_g_pred, na.rm = TRUE))
  # ggplot()+
  # geom_boxplot(aes(x = sample_number, y = length, group = pot_number)) +
  # facet_wrap(event_type~sample_number)
  
  
