# Install and load required packages
library(mgcv)

# Assuming your time series data is in a data frame called 'td_dat'
# with columns 'date_time' and 'temperature'

# Convert 'date_time' to POSIXct if it's not already in that format
td_dat$date_time <- as.POSIXct(td_dat$date_time)

# Fit a GAM with a smooth term for time
gam_model <- gam(temperature ~ s(date_time), data = td_dat)

# Plot the GAM
plot(gam_model)

# Extract the estimated smooth function
smooth_function <- predict(gam_model, type = "response", se.fit = TRUE)$fit

# Calculate the first derivative of the smooth function (slope)
slope <- diff(smooth_function)

# Set the threshold for identifying significant changes in slope
threshold <- 0.5  # Adjust as needed

# Identify significant changes in slope
change_points <- which(abs(slope) > threshold)

# Filter change points that are at least 7 days apart
min_interval_days <- 7
valid_change_points <- change_points[diff(td_dat$date_time[change_points]) >= min_interval_days]

# Print or visualize the identified change points
print(valid_change_points)
# or
plot(td_dat$date_time, td_dat$temperature, type = "l", col = "blue", lwd = 2)
points(td_dat$date_time[valid_change_points], td_dat$temperature[valid_change_points], col = "red", pch = 16)
