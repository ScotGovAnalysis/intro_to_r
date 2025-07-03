# Session 2 ---------------------------------------------------------------

#Read in libraries
library(tidyverse)
library(lubridate)

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


### 3.2 Exercises ---------------------------------------------------------

#1. Read in "UKgas.csv" and inspect the data. 
#   The data has been created from one of R data sets https://www.rdocumentation.org/packages/datasets/versions/3.6.2/topics/UKgas
#   The data set is a time series of gas consumption in the UK from 1960Q1 to 1986Q4, in millions of therms (a unit of heat energy).

UKgas <- read_csv("./UKgas.csv")
head(UKgas)
  
  
#2. Create a new tibble of the data in long format with a column to specify the quarter, and a column called "gas_consumption" to show the values.
  
UKgas_l <- UKgas %>% 
  pivot_longer(cols = -year, 
               names_to = "quarter", 
               values_to = "gas_consumption")
  
  
#3. Compute the mean quarterly UKgas consumption across years (Your new tibble will have four rows and 2 columns)
  
UKgas_by_quarter <- UKgas_l %>% 
  group_by(quarter) %>% 
  summarise(mean_quarterly_gas = mean(gas_consumption, 
                                      na.rm = TRUE)) %>% 
  ungroup()
  
  
  
#4. Compute the mean gas consumption for each year (Your tibble will have 27 rows and 2 columns)

UKgas_by_year <- UKgas_l %>% 
  group_by(year) %>% 
  summarise(mean_annual_gas = mean(gas_consumption, 
                                   na.rm = TRUE)) %>% 
  ungroup()
  
  
  
#5. **Bonus:** Convert your long tibble back to wide using the 'pivot_wider' function. This should be the same as the UKgas data. 
#   Use the wide data set to compute the mean gas consumption by year. 
#   Hint: Have a look at https://stackoverflow.com/questions/50352735/calculate-the-mean-of-some-columns-using-dplyrmutate 
#   (Your final tibble will have 27 rows and 6 columns). As you can see, working with long data is simpler in R.
  
# Use pivot_wider() to return the data to the original form
UKgas <- UKgas_l %>% 
  pivot_wider(names_from = "quarter",
              values_from = "gas_consumption")

# Or just re-read in the UKgas data set.
UKgas <- read_csv("./UKgas.csv")


UKgas <- UKgas %>% 
  mutate(mean_annual_gas =rowMeans(select(., Qtr1,
                                          Qtr2,
                                          Qtr3, 
                                          Qtr4)))
  
  
  
  
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

#4.1.6 combining wrangling and plotting in one concise chunk

#Import
benefits <- read_csv("./benefits.csv")

#Wide to long
benefit_long <- pivot_longer(benefits, 
                             cols = !date, 
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




### 4.2 Examples ----------------------------------------------------------

#4.2.1 add a variable to the benefit_long tibble containing the year, and convert the variable to a factor
benefit_long <- benefit_long %>%
  mutate(year = year(date)) %>%
  mutate(year = as.factor(year))  #These two lines could be combined: mutate(year = as.factor(year(date)))

#4.2.2 summarise average number of benefits by year, and add error bar max/min values
benefit_by_year <- benefit_long %>%
  filter(benefit != "Total") %>%
  group_by(year, benefit) %>%
  summarise(average_apps = mean(apps), 
            error_bar_min = average_apps - sd(apps), 
            error_bar_max = average_apps + sd(apps)
  )

head(benefit_by_year)

#4.2.3 plot as a bar chart
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

### 4.3 Exercises ---------------------------------------------------------

#1. Plot the UKgas consumption by year as a line graph, with quarters shown in different colours. 
#   Change the axes labels to something of your choice and add a title.
g <- ggplot(UKgas_l, aes(x = year, 
                         y = gas_consumption, 
                         group = quarter,
                         colour = quarter)) + 
  geom_line() +
  xlab("Year") +   ## Alternatively, all labels can be changed in a single line using labels(title = "", x="", y="")
  ylab("Gas consumption (mTherms)")

g

#2. Plot the same as above, but include a line for the mean gas consumption across quarters. 
#   You will first need to append the UKgas_by_year to your data
UKgas_l_with_mean <- UKgas_l %>% 
  bind_rows(UKgas_by_year %>% 
              # Specify the value that should appear in the "quarter" column
              mutate(quarter = "Mean") %>%
              # ensure that column names match
              rename(gas_consumption = mean_annual_gas))

g2 <- ggplot(UKgas_l_with_mean, aes(x = year, 
                                    y = gas_consumption, 
                                    group = quarter, 
                                    colour = quarter)) + 
  geom_line() +
  xlab("Year") + 
  ylab("Gas consumption (mTherms)")

g2

#3. Create the same plot as above (including the mean), but use thin lines for quarter, and a thick line for the mean. 
#   You will need to add a new numeric variable to the data used in the previous exercise that specifies a value for line thickness. 
#   See the examples in `?geom_line` for details around specifying aesthetics for the line graph and how to do this by group. 
#   You will also need to look at `?scale_linewidth`

# Add a linewidth value, to do this you will have to create a new column with a condition. 
# Look at ?if_else to see how to make a new column that shows '2' when "quarter == 'Mean'" and '1' otherwise.
# The numbers are not crucial as these will be rescaled in the plot.
UKgas_l_with_mean <- UKgas_l_with_mean %>% 
  mutate(linewidth = if_else(quarter == "Mean", 2, 1))

g3 <- ggplot(UKgas_l_with_mean, aes(x = year, 
                                    y = gas_consumption, 
                                    group = quarter, 
                                    colour = quarter)) + 
  #Implement the linewidth using geom_line()
  geom_line(aes(linewidth = linewidth)) +
  #specify the range that the linewidths should span, and disable the linewidth legend
  scale_linewidth(range = c(0.1, 2), guide = "none") +
  xlab("Year") + 
  ylab("Gas consumption (mTherms)")

g3





