library(tidyverse)

ggplot(data = td_dat)+
  geom_point(aes(date_time, temperature, colour = location), alpha = 0.6, size = 0.98)+
  theme_bw()+
  geom_hline(yintercept = 22, col = "red")+
  geom_hline(yintercept = 21, col = "orange")+
  geom_hline(yintercept = 20, col = "yellow")+
  facet_wrap(~location)+
  labs(x = 'Date', y = expression('Water temperature at seabed - degrees Celsius'))
