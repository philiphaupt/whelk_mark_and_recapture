library(tidyverse)
library(data.table)
library(RColorBrewer)
library(diverging_hcl)

#histo gram plot basic monthly number of days at temperature
td_dat %>%
  dplyr::filter(location == "Studhill off Whitstable") %>% 
  group_by(location, as.Date(date_time)) %>% 
  summarise(max_daily_temp = max(temperature)) %>% 
  mutate(temperature_rnd = round(max_daily_temp, 0)) %>% 
  ggplot()+
  geom_histogram(aes(y = temperature_rnd))+
  labs(x = "Water Temperature (degrees Centigrade)", y = "Number of days (in a year at temperature)", fill = "Temperature Range \ndegrees Centigrade") +
  #facet_wrap(~location)+
  theme_bw() +
  scale_fill_brewer(palette = "RdYlBu",direction = -1, labels = function(x) gsub("\\(|\\[|\\]", "", x)%>% gsub(",", " - ", .))+
  geom_vline(xintercept =20, colour = "black", linetype ="dashed")

  # geom_hline(yintercept = 22, col = "red")+
  # geom_hline(yintercept = 21, col = "orange")+
  # geom_hline(yintercept = 20, col = "yellow")

# NOT IN FUNCTION 
#`%!in%` = function(x, y) !(x%in%y)

# number of days at temperature
td_dat %>%
  dplyr::filter(location == "Studhill off Whitstable") %>% 
  group_by(location, as.Date(date_time)) %>% 
  summarise(max_daily_temp = max(temperature)) %>% 
  #filter(year %!in% c(2006, 2024)) %>% 
  mutate(temperature_rnd = round(max_daily_temp, 0)) %>% 
  ggplot(aes(x = temperature_rnd, fill = cut(temperature_rnd, 9))) +
  geom_histogram(binwidth = 1) +
  labs(x = "Water Temperature (degrees Centigrade)", y = "Number of days (in a year at temperature)", fill = "Temperature Range \ndegrees Centigrade") +
  #facet_wrap(~location)+
  theme_bw() +
  scale_fill_brewer(palette = "RdYlBu",direction = -1, labels = function(x) gsub("\\(|\\[|\\]", "", x)%>% gsub(",", " - ", .))+
  geom_vline(xintercept =20, colour = "black", linetype ="dashed")



#summary of daily max temperatures
td_dat %>%
  #dplyr::filter(location == "Margate Hook inner west gully") %>% 
  group_by(location, as.Date(date_time)) %>% 
  summarise(max_daily_temp = max(temperature)) %>% 
  arrange(desc(`as.Date(date_time)`))

#max temperature
td_dat %>% group_by(location, as.Date(date_time)) %>%   summarise(max(temperature)) %>% arrange(desc(`max(temperature)`))

#plot time series temperatures overlaid onto each other
td_dat %>% group_by(location, as.Date(date_time)) %>% 
  dplyr::filter(location == "Studhill off Whitstable") %>% 
  group_by(location, as.Date(date_time)) %>% 
  summarise(max_daily_temp = max(temperature)) %>% 
  mutate(temperature_rnd = round(max_daily_temp, 0)) %>% 
  group_by(temperature_rnd) %>% 
  summarise(n())

#Bin count
# bin_count <- sst %>%
#   filter(year %!in% c(2006, 2024)) %>% 
#   ggplot(aes(x = temperature)) +
#   geom_histogram(binwidth = 1, color = "white") +
#   facet_wrap(~ year) +
#   theme_void()  # Use a blank theme to avoid displaying the plot
# 
# # Extract the number of bins
# num_bins <- bin_count$data %>%
#   pull(temperature) %>%
#   cut_width(width = 1) %>%
#   levels() %>%
#   length()
# 
# num_bins

# td_dat %>%
#   filter(year %!in% c(2006, 2024)) %>% 
#   mutate(temperature_rnd = round(temperature, 0)) %>%
#   ggplot(aes(x = temperature_rnd, fill = temperature_rnd >= 20)) +
#   geom_histogram(binwidth = 1) +
#   labs(x = "Water Temperature (degrees Centigrade)", y = "Number of days (in a year at temperature)") +
#   facet_wrap(~ year) +
#   theme_bw() +
#   geom_vline(xintercept =20, colour = "black", linetype ="dashed")+
#   scale_fill_manual(values = c("grey", "red"),
#                     labels = c("Below 20°C", "Over 20°C"),
#                     guide = guide_legend(title = "Temperature Range"))+
#   coord_flip()
# 
# 
# 
# td_dat %>%
#   filter(year %!in% c(2006, 2024)) %>% 
#   mutate(temp_range = ifelse(temperature < 20, "Below 20", "Above 20"),
#          sst_trunc = trunc(temperature)
#   ) %>%
#   ggplot(aes(x = sst_trunc, fill = temp_range)) +
#   geom_histogram(binwidth = 1) +
#   labs(x = "Water Temperature (degrees Centigrade)", y = "Number of days in a year at temperature") +
#   facet_wrap(~ year) +
#   theme_bw() +
#   scale_fill_manual(values = c("Below 20" = "grey", "Above 20" = "red"),
#                     guide = guide_legend(title = "Temperature Range"))+
#   geom_vline(xintercept =20, colour = "black", linetype ="dashed")+
#   coord_flip()
# 
# 
# 
# #18 deg
# days_above_18 <- sst %>% 
#   mutate(t_18 = if_else(temperature >= 18, "above", "under")) %>% 
#   group_by(year(time)) %>% 
#   count(t_18 == "above") %>% 
#   rename(year = `year(time)`, 
#          t_18 = `t_18 == "above"`)
# 
# ggplot(days_above_18 %>% filter(t_18 == TRUE))+
#   geom_point(aes(x = `year`, 
#                  y = n),
#              size = 5,
#              color = "black"
#   )+
#   theme_minimal()
# 
# #22 deg
# days_above_21 <- td_dat %>% 
#   mutate(t_21 = if_else(temperature >= 21, "above", "under")) %>% 
#   group_by(year(time)) %>% 
#   count(t_21 == "above") %>% 
#   rename(year = `year(time)`, 
#          t_21 = `t_21 == "above"`)
# 
# ggplot(days_above_21 %>% filter(t_21 == TRUE))+
#   geom_point(aes(x = `year`, 
#                  y = n),
#              size = 5,
#              color = "red"
#   )+
#   theme_minimal()
