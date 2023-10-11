library(tidyverse)

ggplot(data = td_dat)+
  geom_point(aes(date_time, temperature, colour = location), alpha = 0.1)+
  theme_bw()+
  facet_wrap(~location)+
  labs(x = 'Date', y = expression('Water temperature at seabed - degrees Celsius'))
