# aim: create basic descriptive analysis from the size data
library(tidyverse)
library(plotrix)

# Overall summary
summary(size_dat$length)
# Overall summary with standard error
size_dat %>% dplyr::summarise(mean_length_mm = mean(length, na.rm = TRUE),
                              median_length_mm = median(length, na.rm = TRUE),
                              se_length_mm = std.error(length, na.rm = TRUE))



# plot frequency distribution
ggplot(data = size_dat)+
geom_histogram(aes(x = length), fill = "cornflowerblue", alpha = 0.6)+
  theme_minimal()
  


ggplot(data = size_dat)+
  geom_density(aes(x = length), fill = "cornflowerblue", alpha = 0.6)+
  theme_minimal()


ggplot(data = size_dat)+
  geom_boxplot(aes(x = length, y = date, group = as.factor(date), fill = as.factor(date)),  alpha = 0.6)+
  theme_minimal()+
  labs(x = "Date", y = "Length (mm)", size = 5)+
  scale_fill_discrete(name = "Date")
                 