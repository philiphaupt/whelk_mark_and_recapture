library(tidyverse)

size_dat %>% 
  # group_by(event_type, pot_number) %>% 
  # summarise()
  ggplot()+
  geom_boxplot(aes(x = sample_number, y = length, group = pot_number)) +
  facet_wrap(event_type~sample_number)
