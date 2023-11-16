# Density calculations based on 30 m - 50 m buffers around lines

b30m <- 5787.953 #(30 m buffer around 51.44 m length line between first and last pot in section)
b50m <- 12889.707 #(50 m buffer around 51.44 m length line between first and last pot in section)

densities <- tibble(d30 = (lp_pop_df %>% pivot_longer(cols = c("N_a", "N_b"), names_to = "site", values_to = "abundance") %>% 
                             dplyr::select(abundance_30 = abundance))/b30m, 
                    d50 = (lp_pop_df %>% pivot_longer(cols = c("N_a", "N_b"), names_to = "site", values_to = "abundance") %>% 
                             dplyr::select(abundance_50 = abundance)/b50m)
                      ) %>% unnest(cols = c(d30, d50)) %>% 
  rename(density_30 = `abundance_30`,density_50 = `abundance_50`)
# densities$d30 <- (lp_pop_df %>% pivot_longer(cols = c("N_a", "N_b"), names_to = "site", values_to = "abundance") %>% 
#           dplyr::select(abundance))/b30m 
# densities$d50 <- (lp_pop_df %>% pivot_longer(cols = c("N_a", "N_b"), names_to = "site", values_to = "abundance") %>% 
#           dplyr::select(abundance))/b50m


density_range <- bind_cols((lp_dat %>% select(date)), (lp_pop_df %>% pivot_longer(cols = c("N_a", "N_b"), names_to = "site", values_to = "abundance"))) %>% bind_cols(densities)

# Means for report
density_range %>% slice(5:6) %>% select(3:5) %>% summarise_all(mean, na.rm = TRUE)


# House keeping
rm(densities, b30m, b50m)