# Session 2 ---------------------------------------------------------------

#Read in libraries
library(tidyverse)

## Section 2: Exploring the Data ------------------------------------------

### 2.1 Examples (incomplete) ---------------------------------------------

#2.1.1 import data
benefits <- 
  
#2.1.2 view the first few lines of the tibble
  
  
#2.1.3 view the entire tibble in a new tab
  
  
### 2.2 Examples (incomplete) ---------------------------------------------

#2.2.1 data structure


#2.2.2 summary statistics


#2.2.3 check for missing values


#2.2.4 total missing values


### 2.3 Examples (incomplete) ---------------------------------------------

#2.3.1 quick plots
plot()
plot()
plot()
plot()


## Section 3: Data Wrangling ----------------------------------------------

### 3.1 Examples (incomplete) ---------------------------------------------

#3.1.1 pivot_longer documentation
?pivot_longer

#3.1.2 wide to long
benefit_long <- pivot_longer(
  
  
  
)
head(benefit_long)

#3.1.3 alternate way of specifying cols
benefit_long <- pivot_longer(
  
  
  
)
head(benefit_long)

#3.1.4 add total
benefit_total <- benefit_long %>%
  group_by() %>%
  summarise(benefit = 
              apps = , 
  ) %>%
  ungroup()

head(benefit_total)

#3.1.5 append benefit_total to benefit_long
benefit_long <-

  
## Section 4: Data Wrangling ----------------------------------------------

### 4.1 Examples ----------------------------------------------------------

#4.1.1 Time series plot
time_series_plot <- ggplot(data = benefit_long,
                           aes(x = date, y = apps)) +
  #Add the geometry
  geom_point()

#call the object to show the plot
time_series_plot


#4.1.2 separate series with different colours
time_series_plot2 <-  ggplot(data = benefit_long,
                             aes(x=date,
                                 y = apps,  
                                 group = benefit, 
                                 colour = benefit)) +
  geom_point()

time_series_plot2

#4.1.3 split into panels
time_series_plot3 <- time_series_plot2 + 
  facet_grid(rows = vars(benefit))

time_series_plot3

#4.1.4 best fit line
time_series_plot4 <- time_series_plot3 + 
  geom_line() +
  geom_smooth(method = "lm")  #Uses a linear model for fit and confidence interval

time_series_plot4

#4.1.5 apply a theme
time_series_plot5 <- time_series_plot4 +
  xlab("Date") +
  ylab("Application number") +
  labs(colour = "Benefit") +
  theme_bw()

time_series_plot5

### 4.2 Exercises ---------------------------------------------------------

#1. create the time_series_plot5 in a concise bit of code

#Import
benefits <- 
  
#Wide to long
benefit_long <- 
  
#Get total
benefit_total <- 
  
#Append benefit_total to benefit_long
benefit_long <- 
  
  
#Plotting
time_series_plot <-  
  
  
  
  
  
time_series_plot


### 4.3 Examples (incomplete) ---------------------------------------------

#4.3.1 add a variable to the benefit_long tibble containing the year, and convert the variable to a factor
benefit_long <- benefit_long %>%
  mutate() %>%
  mutate()  

#4.3.2 summarise average number of benefits by year, and add error bar max/min values
benefit_by_year <- benefit_long %>%
  filter() %>%
  group_by() %>%
  summarise(average_apps = , 
            error_bar_min = , 
            error_bar_max = 
  )

head(benefit_by_year)

#4.3.3 plot as a bar chart
bar_graph_plot <- ggplot(
  
  
  
  
  
  
) 

dodge <- position_dodge(width=0.9)

bar_graph_plot <- bar_graph_plot +
  geom_col() +
  geom_errorbar(
  ) +
  xlab() +
  ylab()

bar_graph_plot

