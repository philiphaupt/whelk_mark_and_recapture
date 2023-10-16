# aim: create basic descriptive analysis from the size data
library(tidyverse)
library(plotrix)

# Overall summary with standard error
size_dat %>% dplyr::group_by(event_code) %>%
  dplyr::summarise(
    mean_length_mm = mean(length, na.rm = TRUE),
    median_length_mm = median(length, na.rm = TRUE),
    sd_length_mm = sd(length, na.rm = TRUE),
    se_length_mm = std.error(length, na.rm = TRUE)
  )



# plot frequency distribution
size_dat %>%
ggplot() +
  geom_histogram(aes(x = length,
                 fill = event_code),
                 alpha = 0.6) +
  theme_minimal() +
  labs(x = "Length (mm)", y = "Number of Whelks")+
  scale_fill_manual("Mark/Recapture Event", values =c("goldenrod", "cornflowerblue", "grey22"))


ggplot(data = size_dat) +
  geom_density(aes(x = length,
               fill = event_code),
               alpha = 0.3) +
  theme_minimal() #+ 
  #facet_wrap(~event_code)

# Perform Kolmogorov-Smirnov test
event1 <- size_dat %>% filter(event_code == "M") %>% select(length) %>% unlist()
event2 <- size_dat %>% filter(event_code == "R1") %>% select(length) %>% unlist()
event3 <- size_dat %>% filter(event_code == "R2") %>% select(length) %>% unlist()


# Kolomogorov-Smirnoff test
ks.test(event1, event2, alternative = c("two.sided"))  # Compare event1 and event2
ks.test(event1, event3, alternative = c("two.sided"))  # Compare event1 and event3
ks.test(event2, event3, alternative = c("two.sided"))  # Compare event2 and event3


# NORMALITY PLOTS:

# Perform Shapiro-Wilk test for normality
shapiro_test_event1 <- shapiro.test(event1)
shapiro_test_event2 <- shapiro.test(event2)
shapiro_test_event3 <- shapiro.test(event3)

# Print the results of the Shapiro-Wilk tests
cat("Shapiro-Wilk Test for Event 1:\n", "W =", shapiro_test_event1$statistic, ", p-value =", shapiro_test_event1$p.value, "\n")
cat("Shapiro-Wilk Test for Event 2:\n", "W =", shapiro_test_event2$statistic, ", p-value =", shapiro_test_event2$p.value, "\n")
cat("Shapiro-Wilk Test for Event 3:\n", "W =", shapiro_test_event3$statistic, ", p-value =", shapiro_test_event3$p.value, "\n")

# Create Q-Q plots to visually assess normality
qqnorm(event1, main = "Q-Q Plot for Event 1")
qqline(event1)
qqnorm(event2, main = "Q-Q Plot for Event 2")
qqline(event2)
qqnorm(event3, main = "Q-Q Plot for Event 3")
qqline(event3)

# #{NOT RUN becuase size data are not normally distributed in initial marking}
# # ANOVA
# # Perform one-way ANOVA
# anova_result <- aov(length ~ event_code, data = size_dat)
# # Summary of ANOVA
# summary(anova_result)
# 
# # Perform Tukey's HSD test for post-hoc comparisons
# tukey_result <- TukeyHSD(anova_result)
# 
# # Print the results of Tukey's HSD test
# print(tukey_result)
