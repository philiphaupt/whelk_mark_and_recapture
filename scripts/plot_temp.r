library(tidyverse)

#{NOT RUN}
# ggplot(data = td_dat %>% filter(location == "Studhill off Whitstable"))+
#   geom_point(aes(date_time, temperature
#                  
#                  ), colour = "goldenrod",alpha = 0.65, size = 0.98)+
#   theme_bw()+
#   labs(x = 'Date', y = expression('Water temperature at seabed - degrees Celsius'))+
# guides(fill=guide_legend(title="Location"))

# for both locations
ggplot(data = td_dat) +
  geom_hline(yintercept = 20, col = "goldenrod")+
  geom_hline(yintercept = 21, col = "orange1")+
  geom_hline(yintercept = 22, col = "red")+
  geom_point(aes(date_time, temperature, colour = location),
             alpha = 0.65,
             size = 0.98) +
  theme(
    axis.title = element_text(size = rel(1.4)),
    axis.text = element_text(size = rel(1.3)),
    legend.title = element_text(size = rel(1.3)),
    legend.text = element_text(size = rel(1.3)),
    panel.background = element_rect(fill = "white", colour = "white"),
    axis.line = element_line(colour = "black"),
    legend.background = element_rect(colour = "white", fill = "white"),
    legend.box.background = element_rect(colour = "white", fill = "white"),
    legend.key = element_rect(fill = "white"),
    legend.key.size = unit(0.7, "cm"),
    legend.key.width = unit(0.5, "cm")#panel.grid.major.y = element_line(colour = "grey40"),
    #panel.grid.minor.y = element_line(colour = "grey66")
  )+
  labs(x = 'Date (Month in 2023)', 
       y = expression("Seabed Water Temperature " (degree*C)))+
  scale_color_manual("Location", values = c("goldenrod", "cornflowerblue"), labels = c("Margate", "Whitstable"))+
  scale_y_continuous(n.breaks = 13, limits = c(10, 23))
  
