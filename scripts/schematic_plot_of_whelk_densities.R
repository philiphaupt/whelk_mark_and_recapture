# Circular plot dpicting denisty

# Install and load necessary packages
library(ggplot2)
library(ggimage)
library(png)

# Set a seed for reproducibility
set.seed(123)

# Define the ratio of blue to green (4:1)
color_ratio <- c(4, 1)
colors <- rep(c("blue", "green"), times = color_ratio)



# Generate random data
n_points <- 3
max_lim <- 4
min_lim <-  1

data <- data.frame(
  X = runif(n_points, min_lim, max_lim),
  Y = runif(n_points, min_lim, max_lim),
  image = sample(c("./images/whelk_lr.png"),
                 size = n_points, 
                 replace = TRUE
                  ),
  color = sample(colors, size = n_points, replace = TRUE)
)

# Create the ggplot circular plot with custom image points
ggplot(data, aes(x = X, y = Y)) +
  geom_image(aes(image=image), size=0.1)+
  geom_point(aes(color = color), size=3,shape = 15, alpha = 0.5)+
  scale_color_identity() +  # Use the actual colors in the 'color' column
  coord_polar() +
  theme_bw() +
  theme(legend.position = "none")  # Remove legend (if not needed)

#------------------as function:
generate_circular_plot <- function(n_points, color_ratio, max_lim, min_lim) {
  colors <- rep(c("blue", "green"), times = color_ratio)
  
  data <- data.frame(
    X = runif(n_points, min_lim, max_lim),
    Y = runif(n_points, min_lim, max_lim),
    image = sample(c("./images/whelk_lr.png"), size = n_points, replace = TRUE),
    color = sample(colors, size = n_points, replace = TRUE)
  )
  
  ggplot(data, aes(x = X, y = Y)) +
    geom_image(aes(image = image), size = 0.1) +
    geom_point(aes(color = color), size = 3, shape = 15, alpha = 0.5) +
    scale_color_identity() +
    coord_polar() +
    theme_minimal() +
    theme(legend.position = "none")
}


# Example usage
generate_circular_plot(n_points = 3, color_ratio = c(4, 1), max_lim = 4, min_lim = 1)
#----------

# Set the seed for reproducibility
set.seed(123)

# Number of iterations
num_iterations <- 5

# Create and display plots for each iteration
for (i in 1:num_iterations) {
  n_points <- sample(1:10, 1)
  color_ratio <- sample(list(c(4, 1), c(3, 2), c(2, 3), c(1, 4)),1) %>% unlist()
  max_lim <- sample(1:5, 1)
  min_lim <- 1
  
  print(generate_circular_plot(n_points, color_ratio, max_lim, min_lim))
}


