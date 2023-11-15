# TITLE: Allometry functions using Weight vs length relationships to estimate standard equation parameters

# Aim: Determine parameters a and b for allometric body weight length formula: W = a*L^b
# Specific objectives: Plot Weight versus length for Kent and Essex Whelk data, and test if predicted weights are sigifciatly different from  actual weights using the dervied equation.

# Author: Philip Haupt
# Email: philip.haupt@gmail.com
# Date: 2021-02-12


#libraries
library(tidyverse) # for data wrangling and plotting
library(ggsci) # for colour scale in plotting in ggplot (optional)


# OPTIONAL SETTINGS: If you want to isolate Kent and Essex - apply this first and specify the correct input data set
# dat_essex <- dat %>% dplyr::filter(location == "Essex")
# dat_kent <- dat %>% dplyr::filter(location == "Kent")

# INPUT DATE REQUIRED - user to specify data
w <- dat$total_weight # Actual weights from measurements: whelk data used here called from the "explore_data.R" in the C:/Users/Phillip Haupt/Documents/SUSTAINABLE FISHERIES/whelks/whelk_ogive/allometric_analysis/whelk_allometry directory. 
l <- dat$shell_length # actual lengths from measurements:
funs <- mean  # change this to mean or median  - used in the equation to calculate the slope (a) in teh allometry function. 

#----------------------------------
# functions: My allometry functions:
# Calculate exponent b: Regres the natural logs of weight and length against each other to find b (expoetnial factor for the equation). 
calculate_exponent_b <- function(W = w, L = l){ # W is a numerical vector of weights, Legnth is a numerical vector of lengths
  regression <- lm(log(W) ~ log(L)) # create a linear regression of the natural logs of weight vs length
  as.numeric(regression$coefficients[2])# isolate the second parameter and ensure only the numeric value is retained. Note that isloating the first and taking the exp is sometimes used to calculate a -but here I am estiamting a sequently from my data in the next function
}

# from allometric equation, the reverse is, a = W/(L^b), so we can calculate from the data like this:
calculate_slope_fn <- function(W = w, L = l, b = b, fun = mean){ #W is a numerical vector representing the weight (actual/observed), L is the length, b is the exponential factor and fun is the functions with which to sumamrise all the a values into a single value. Default is mean, median could be an alternative: specify the latter at the top where user input is asked.
  a_calculated = fun(W/(L^b))
  # function to calculate a from means of all a's from data set using means or medians : defaults to mean - but user to specify in funs above
}

# CALCULATIONS---------------------
# call the function and calculate 
# b (the exponent)
b_calculated <- calculate_exponent_b() # Compare with Wales (2.845) and IOM(2.939)

# a (the slope)
a_calculated <- calculate_slope_fn(w,l,b_calculated, funs)


# plot the curves
ggplot2::ggplot()+
  geom_point(data = dat, aes(x = shell_length, y = total_weight, color = location), alpha = 0.6)+ # colour the points according to a variable called "location"
  xlab("Shell length (mm)")+
  ylab("Total weight (g)") + # up to hear makes a xy scatter plot of weight versus length
  theme_bw()+
  facet_wrap(~location)+ # split the panels by "location"
  scale_color_jco() + # use the Journal of Oncology's colour scale
  stat_function(fun=function(x,y)y=a_calculated*x^b_calculated,colour="brown",size=0.7)# adds the predicted line to the graph. #predict_weight_fn, args = list(a = a_calculated , L = l, exp_b = b)


#---------------------------------
# Statistical test of accuracy of model comparing predicted versus observed weights.

# Calculate Predicted Weights from our measures by fitting them to the function using the parameters that we just calculated.
# function to calculate weight estimations 
predict_weight_fn <- function(a = a_calculated, L = l, exp_b = b_calculated){
  w_predicted <- a*L^exp_b
}

# create a test data set of predicted weights to allow comparing against actual weights - using actual shell length as input to the model
Wp <- predict_weight_fn(L = l) # Predicated weights
#weight_pred_vs_obs <- cbind(Wp, w) %>% as_tibble()

# # Non-parametric test (we know that the data are not normally distributed from earlier investigations - so in this case, the non-parametric test here is correct:)
wilcox.test(x = Wp, y = w, alternative = "two.sided", mu = 0, conf.level = 0.95)
# 
# # RESULT INTERPRETATION: the predicted weights (Wp) and actual weights (w) are not significantly different from each otehr using the allometric realtionship to fit predicted weights.
# # Wilcoxon rank sum test with continuity correction
# # 
# # data:  Wp and w
# # W = 73718840, p-value = 0.2079
# # alternative hypothesis: true location shift is not equal to 0
# 
# 
# t.test(x = Wp, y = w, alternative = "two.sided", mu = 0, conf.level = 0.95)
# 
# # RESULT INTERPRETATION: the predicted weights are not significantly different from the observed weights
# # Welch Two Sample t-test
# # 
# # data:  weight_pred_vs_obs$Wp and weight_pred_vs_obs$w
# # t = 0.15114, df = 24142, p-value = 0.8799
# # alternative hypothesis: true difference in means is not equal to 0
# # 95 percent confidence interval:
# #   -0.3657691  0.4268888
# # sample estimates:
# #   mean of x mean of y 
# # 28.05918  28.02862


# NOW--------------------------------------------------------------------------
# now create a predicted data set from the measurements taken from photographs:
l <- size_dat$length
Wp_photo <- predict_weight_fn(L = l)


#now inserts that into size_dat
size_dat <- size_dat %>% mutate(weight_g_pred = predict_weight_fn(L = length))


# plot the curves
predicted_weight_plot <- ggplot2::ggplot()+
  geom_point(data = dat, aes(x = shell_length, y = total_weight), col = "goldenrod", alpha = 0.6)+
  stat_function(fun=function(x,y)y=a_calculated*x^b_calculated,colour="brown4",size=0.7)+# adds the predicted line to the graph. #predict_weight_fn, args = list(a = a_calculated , L = l, exp_b = b)
  geom_point(data = size_dat, aes(x = length, y = weight_g_pred), col = "blue", alpha = 0.6)+ # colour the points according to a variable called "location"
  xlab("Shell length (mm)")+
  ylab("Total predicted weight (g)") + # up to hear makes a xy scatter plot of weight versus length
  theme_bw()+
  theme(
    axis.title = element_text(size = rel(1.4)),
    axis.text = element_text(size = rel(1.3)),
    legend.title = element_text(size = rel(1.3)),
    legend.text = element_text(size = rel(1.3)),
    panel.background = element_rect(fill = "white", colour = "white"),
    axis.line = element_line(colour = "black"),
    legend.background = element_rect(colour = "white", fill = "white"),
    legend.box.background = element_rect(colour = "white", fill = "white"),
    legend.key = element_rect(fill = "white"),
    legend.key.size = unit(0.7, "cm"),
    legend.key.width = unit(0.5, "cm")
  )

predicted_weight_plot
# Save the grid plot
ggsave("./outputs/predicted_weights_from_length.png", predicted_weight_plot, width = 10, height = 10, units = "cm")

