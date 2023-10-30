library(tidyverse)

mr_dat %>% group_by(location_abbrv, date, fkey_opcode, KEIFCA_tag_id) %>% 
  summarise(r1_totals = sum(recapture_1), 
            r2_totals = sum(recapture_2)
                ) %>% filter(!is.na(r1_totals)) %>% print(n = 50)
            