# Session 2 ---------------------------------------------------------------

#Read in libraries
library(tidyverse)

## Section 2: Exploring the Data ------------------------------------------

### 2.1 Examples ----------------------------------------------------------

#2.1.1 import data
benefits <- read_csv("./benefits.csv")

#2.1.2 view the first few lines of the tibble
head(benefits)

#2.1.3 view the entire tibble in a new tab
View(benefits)

  
  ### 2.2 Examples ----------------------------------------------------------

#2.2.1 data structure
str(benefits)

#2.2.2 summary statistics
summary(benefits)

#2.2.3 check for missing values
is.na(benefits)

#2.2.4 total missing values
sum(is.na(benefits))


### 2.3 Examples ----------------------------------------------------------

#2.3.1 quick plots
plot(benefits$date, benefits$A)
plot(benefits$date, benefits$B)
plot(benefits$date, benefits$C)
plot(benefits$date, benefits$D)


## Section 3: Data Wrangling ----------------------------------------------

### 3.1 Examples ----------------------------------------------------------

#3.1.1 pivot_longer documentation
?pivot_longer

#3.1.2 wide to long
benefit_long <- pivot_longer(benefits, 
                             cols = -date, 
                             names_to = "benefit", 
                             values_to = "apps")
head(benefit_long)

#3.1.3 alternate way of specifying cols
benefit_long <- pivot_longer(benefits, 
                             cols = 2:5, 
                             names_to = "benefit", 
                             values_to = "apps")
head(benefit_long)

#3.1.4 add total
benefit_total <- benefit_long %>%
  group_by(date) %>%
  summarise(benefit = "Total",
            apps = sum(apps)) %>%
  ungroup()

head(benefit_total)

#3.1.5 append benefit_total to benefit_long
benefit_long <- bind_rows(benefit_long, benefit_total)

  
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
                             aes(x = date,
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
benefits <- read_csv("./benefits.csv")

#Wide to long
benefit_long <- pivot_longer(benefits, 
                             cols = -date, 
                             names_to = "benefit", 
                             values_to = "apps")
#Get total
benefit_total <- benefit_long %>%
  group_by(date) %>%
  summarise(apps = sum(apps), 
            benefit = "Total") %>%
  ungroup()

#Append benefit_total to benefit_long
benefit_long <- benefit_long %>%
  bind_rows(benefit_total)

#Plotting
time_series_plot <-  ggplot(data = benefit_long,
                            aes(x=date,
                                y = apps,  
                                group = benefit, 
                                colour = benefit)) +
  geom_point() + 
  facet_grid(rows = vars(benefit)) +
  geom_line() +
  geom_smooth(method = "lm") +  
  xlab("Date") +
  ylab("Application number") +
  labs(colour = "Benefit") +
  theme_bw()

time_series_plot


### 4.3 Examples ----------------------------------------------------------

#4.3.1 add a variable to the benefit_long tibble containing the year, and convert the variable to a factor
benefit_long <- benefit_long %>%
  mutate(year = year(date)) %>%
  mutate(year = as.factor(year))  #These two lines could be combined: mutate(year = as.factor(year(date)))

#4.3.2 summarise average number of benefits by year, and add error bar max/min values
benefit_by_year <- benefit_long %>%
  filter(benefit != "Total") %>%
  group_by(year, benefit) %>%
  summarise(average_apps = mean(apps), 
            error_bar_min = average_apps - sd(apps), 
            error_bar_max = average_apps + sd(apps)
  )

head(benefit_by_year)

#4.3.3 plot as a bar chart
bar_graph_plot <- ggplot(data = benefit_by_year, 
                         aes(x = year,
                             y = average_apps, 
                             colour = benefit, 
                             group = benefit
                         )) 

dodge <- position_dodge(width=0.9)

bar_graph_plot <- bar_graph_plot+
  geom_col(aes(fill = benefit),
           position = dodge) +
  geom_errorbar(aes(ymin = error_bar_min, 
                    ymax = error_bar_max), 
                position = dodge,
                width = 1
  ) +
  xlab("") +
  ylab("Average yearly applications")

bar_graph_plot

