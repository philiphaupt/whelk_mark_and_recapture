library(tidyverse)
library(data.table)
library(plotrix)

mr_dat %>% group_by(as.factor(date)) %>% 
  summarise(mean_lpue = mean())


# data prep for population size analysis----------------move to separate script
per_pot_analysis <- mr_dat %>%
  group_by(location_abbrv, date) %>%
  summarise(
    mean_whelks_pot = mean(total_whelks_caught),
    sd_whelks_pot = sd(total_whelks_caught),
    sub_total = sum(total_whelks_caught)
  ) %>% 
  mutate(cum_total = cumsum(sub_total)
  )

# plot
per_pot_analysis %>%
  filter(location_abbrv == "Margate") %>% 
  ggplot()+
  geom_point(aes(x = cum_total, y = mean_whelks_pot),  fill = "white")+
  geom_errorbar(aes(y = mean_whelks_pot,
                    x = cum_total,
                    ymin = mean_whelks_pot-sd_whelks_pot, 
                    ymax = mean_whelks_pot+sd_whelks_pot
                    ),
                width = 50
                )+
  labs(y = "CPUE whelks per pot", x = "Cumulative abundance")+
  #facet_wrap(~location_abbrv, scales = "free")+
  theme_minimal()


