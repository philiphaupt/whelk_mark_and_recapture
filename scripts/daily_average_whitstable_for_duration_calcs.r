whitstable_tdd_dat <- td_dat %>% 
  filter(location == "Studhill off Whitstable") %>% 
  arrange(date_time) %>% 
  group_by(dates) %>% 
  summarise(max_daily_temp = max(temperature, na.rm = TRUE)) %>% 
  mutate(over20C = if_else(max_daily_temp > 20.0, "over 20 C", "under 20 C")) %>% 
  ungroup() %>% 
  #group_by(over20C) %>% 
  mutate(cum_day = 1) %>% 
  mutate(cum_day = if_else(over20C == lag(over20C), cumsum(cum_day),1),
         cum_day2 = if_else(over20C == lead(over20C), (cum_day+lag(cum_day)),0))
  
