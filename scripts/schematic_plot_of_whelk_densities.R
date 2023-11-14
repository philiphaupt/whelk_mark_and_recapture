# Circular plots depicting density of whelks

# Install and load necessary packages
library(ggplot2)
library(ggimage)
library(png)
library(cowplot)

# Set a seed for reproducibility
set.seed(123)

# Define the ratio of blue to green (4:1)
color_ratio <- c(57, 4, 1)
colors <- rep(c("white", "blue", "green"), times = color_ratio)

# Generate random data
n_points <- 62 # how many snails per image
max_lim <- 100 # max position - x and y
min_lim <-  1 # min position - x and y

# # Test individual runs---------------
# data <- data.frame(
#   X = runif(n_points, min_lim, max_lim),
#   Y = runif(n_points, min_lim, max_lim),
#   image = sample(c("./images/whelk_lr.png"),
#                  size = n_points, 
#                  replace = TRUE
#                   ),
#   color = sample(colors, size = n_points, replace = TRUE)
# )
# 
# # Create the ggplot circular plot with custom image points
# ggplot(data, aes(x = X, y = Y)) +
#   geom_image(aes(image=image), size=0.1)+
#   geom_point(aes(color = color), size=3,shape = 15, alpha = 0.5)+
#   scale_color_identity() +  # Use the actual colors in the 'color' column
#   coord_polar() +
#   theme_bw() +
#   theme(legend.position = "none")  # Remove legend (if not needed)
# 
#------------------as function:
#-----------------
generate_circular_plot <- function(n_points, color_ratio, max_lim, min_lim, sample_section, pot_number) {
  colors <- rep(c("white","blue", "green"), times = color_ratio)
  
  data <- data.frame(
    X = runif(n = n_points, min = min_lim, max = max_lim),
    Y = runif(n = n_points, min = min_lim, max = max_lim),
    image = sample(c("./images/whelk_lr_no_bg.png"), size = n_points, replace = TRUE),
    color = sample(colors, size = n_points, replace = TRUE)
  ) %>% 
    mutate(alphas = if_else(color == "white", 0.01, 0.3)) # adds dynamically determined by condition alpha value
  
  ggplot(data, aes(x = X, y = Y)) +
    geom_image(aes(image = image), size = 0.075) +
    geom_point(aes(colour = color, fill = color, alpha = alphas), size = 5, shape = 21) +
    scale_color_identity() +
    scale_fill_identity() +
    scale_alpha_identity() +
    coord_polar() +
    theme_minimal() +
    theme(legend.position = "none") +
    labs(x = NULL, y = NULL, title = paste0("Sample: ", sample_section, ", Pot number: ", pot_number)) +
    theme(panel.background = element_rect(fill = "white"),
          plot.background = element_rect(fill = "white"),
          axis.text = element_blank())
}


# Example usage
#generate_circular_plot(n_points = 62, color_ratio = c(57, 4, 1), max_lim = 100, min_lim = 1, sample_section = paste0("Sample Section ", i), pot_number = j)
#----------

# # Set the seed for reproducibility
# set.seed(123)
# 
# # Number of strings
# num_sampling_sections <- 2
# 
# 
# for (i in 1:num_sampling_sections) {
#   
#   # Number of iterations (pots)
#   num_pots <- 5
#   
#   # Create and display plots for each iteration
#   for (j in 1:num_pots) {
#     pot_number = j
#     n_points <- 62
#     color_ratio <-
#       sample(
#         x = list(c(57, 5, 0), c(57, 4, 1), c(57, 3, 2), c(57, 2, 3), c(57, 1, 4)),
#         size = 1,
#         prob = c(0.1, 0.6, 0.1, 0.07, 0.03)
#       ) %>% unlist()
#     max_lim <- 100
#     min_lim <- 1  # sample(1:100, 1)
#     
#     print(generate_circular_plot(n_points, color_ratio, max_lim, min_lim, sample_section = i, pot_number = j))
#     
#   }
# }

#--
# Install and load necessary packages
#install.packages("cowplot")


# Set the seed for reproducibility
set.seed(123)

# Number of sampling sections
num_sampling_sections <- 2

# Create a list to store plots
plot_list <- list()

for (i in 1:num_sampling_sections) {
  sample_section <- i
  
  # Number of iterations (pots)
  num_pots <- 5
  
  # Create and store plots for each iteration
  for (j in 1:num_pots) {
    pot_number = j
    n_points <- 62
    color_ratio <-
      sample(
        x = list(c(57, 5, 0), c(57, 4, 1), c(57, 3, 2), c(57, 2, 3), c(57, 1, 4)),
        size = 1,
        prob = c(0.1, 0.6, 0.1, 0.07, 0.03)
      ) %>% unlist()
    max_lim <- 100
    min_lim <- 1  # sample(1:100, 1)
    
    plot_list[[length(plot_list) + 1]] <- generate_circular_plot(n_points, color_ratio, max_lim, min_lim, sample_section = sample_section, pot_number = j)
  }
}

# Arrange plots in a grid
grid_plot <- plot_grid(plotlist = plot_list, ncol = 5)
print(grid_plot)
# Save the grid plot
ggsave("./outputs/grid_plot.png", grid_plot, width = 15, height = 8, units = "in")


