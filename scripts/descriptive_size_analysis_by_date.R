# aim: create basic descriptive analysis from the size data
library(tidyverse)
library(plotrix)

# Overall summary with standard error
size_dat %>% dplyr::group_by(date) %>%
  dplyr::summarise(
    mean_length_mm = mean(length, na.rm = TRUE),
    median_length_mm = median(length, na.rm = TRUE),
    sd_length_mm = sd(length, na.rm = TRUE),
    se_length_mm = std.error(length, na.rm = TRUE)
  )



# plot frequency distribution
size_dat %>%
ggplot() +
  geom_histogram(aes(x = length),
                 fill = "cornflowerblue",
                 alpha = 0.6) +
  theme_minimal() + 
  facet_wrap("date")


ggplot(data = size_dat) +
  geom_density(aes(x = length),
               fill = "cornflowerblue",
               alpha = 0.6) +
  theme_minimal() + 
  facet_wrap("date")


