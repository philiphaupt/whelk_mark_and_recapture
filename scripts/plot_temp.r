library(tidyverse)

ggplot(data = td_dat %>% filter(location == "Studhill off Whitstable"))+
  geom_point(aes(date_time, temperature
                 
                 ), colour = "goldenrod",alpha = 0.6, size = 0.98)+
  theme_bw()+
  labs(x = 'Date', y = expression('Water temperature at seabed - degrees Celsius'))+
guides(fill=guide_legend(title="Location"))

#for both locations
ggplot(data = td_dat)+
  geom_point(aes(date_time, temperature, colour = location
                 
  ),alpha = 0.6, size = 0.98)+
  theme_bw()+
  #facet_wrap(~location)+
  labs(x = 'Date', y = expression('Water temperature at seabed - degrees Celsius'))+
  scale_color_manual("Location", values = c("goldenrod", "cornflowerblue"))
  
