library(mgcv)

# The time series data is a data frame called 'td_dat'
# with columns 'date_time', 'temperature', and 'location'

# # Convert 'date_time' to POSIXct if it's not already in that format
# td_dat$date_time <- as.POSIXct(td_dat$date_time)
# 
# # Sort the data frame by 'date_time'
# td_dat <- td_dat[order(td_dat$date_time), ]

# Summaries the data getting daily means before working out slopes
td_daily <- td_dat %>%
  group_by(dates, location) %>%
  summarise(
    daily_mean_temperature = mean(temperature, na.rm = TRUE)#,
    #date_time = first(date_time)
  ) 

# Simplified daily data is in a data frame called 'td_daily'
# with columns 'dates' and 'daily_mean_temperature'

# Convert 'dates' to POSIXct if it's not already in that format
td_daily$dates <- as.POSIXct(td_daily$dates)

# Sort the data frame by 'dates'
td_daily <- td_daily[order(td_daily$dates), ]

# Subset the data by location
subset_location <- td_daily[td_daily$location == "Studhill off Whitstable", ]
subset_location <- ungroup(subset_location) %>% 
  mutate(daily_dif_temp = daily_mean_temperature - lag(daily_mean_temperature))

# Check for missing values
sum(is.na(subset_location$dates))
sum(is.na(subset_location$daily_mean_temperature))

write_csv(subset_location, "./outputs/Whitstable_daily_mean_temperatures.csv") # for Essex Uni
#-----------------------------
# Determine slope

# Fit a GAM with a cyclic cubic regression spline for time
gam_model <- gam(daily_mean_temperature ~ s(as.numeric(dates), bs = "cc"), data = subset_location)

# Extract the estimated smooth function
smooth_function <- predict(gam_model, type = "response", se.fit = TRUE)$fit

# Calculate the first derivative of the smooth function (slope)
slope <- diff(smooth_function)


# Set the threshold for identifying significant changes in slope
threshold <- 0.158  # Adjust as needed

# Identify significant changes in slope
change_points <- which(slope > threshold)# positive slope only for temp increases. which(abs(slope) > threshold) if positive and negative

# Filter change points that are at least 7 days apart
min_interval_days <- 1
valid_change_points <- change_points[diff(subset_location$dates[change_points]) >= min_interval_days]

# Print or visualize the identified change points
#print(valid_change_points)
# or
plot(subset_location$dates, subset_location$daily_mean_temperature, type = "l", col = "blue", lwd = 2)
points(subset_location$dates[valid_change_points], subset_location$daily_mean_temperature[valid_change_points], col = "red", pch = 16)

# slope in temperature
slope_t_data <- td_daily$daily_mean_temperature[range(valid_change_points)[1]:range(valid_change_points)[2]]
lin_mod <- lm(slope_t_data ~ c(range(valid_change_points)[1]:range(valid_change_points)[2]))
lin_slope_df <- data.frame(c(range(valid_change_points)[1]:range(valid_change_points)[2]), slope_t_data) %>% 
  rename(n_day = 1, 
         temp = 2)

coef(lin_mod)[2]


lin_slope_df <- lin_slope_df %>% 
  mutate(temp_dif = lag(temp)-temp)



mean(lin_slope_df$temp_dif, na.rm = TRUE)


# plot
plot_core_slope <- ggplot(data = lin_slope_df, aes(n_day, temp))+
  geom_point()+
  stat_smooth(method = "lm", 
              formula = y ~ x, 
              geom = "smooth") +
  labs(x = "N day in data set", y = "Water temperature")+
  theme_classic()

plot_core_slope

plot_core_slope <- ggplot(data = lin_slope_df, aes(n_day, temp_dif-min(lin_slope_df$temp_dif, na.rm = TRUE)))+
  geom_point()+
  stat_smooth(method = "lm", 
              formula = y ~ x, 
              geom = "smooth") +
  labs(x = "N day in data set", y = "Water temperature increases")+
  theme_classic()

plot_core_slope

lm(lin_slope_df$n_day[2:9] ~ -(lin_slope_df$temp_dif[2:9]))
