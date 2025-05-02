# Session 2 ---------------------------------------------------------------

#Read in libraries
library(tidyverse)
library(lubridate)

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
  
  
### 3.2 Exercises ---------------------------------------------------------

#1. Read in "UKgas.csv" and inspect the data. 
#   (The data has been created from one of R datasets https://www.rdocumentation.org/packages/datasets/versions/3.6.2/topics/UKgas)

UKgas <-  
  
  
  
  
#2. Create a new tibble of the data in long format with a column to specify the quarter.
  
UKgas_l <-
  
  
  
  
#3. Compute the mean quarterly UKgas consumption across years (Your new tibble will have four rows and 2 columns)
  
UKgas_by_quarter <-
  
  
  
  
#4. Compute the mean gas consumption for each year (Your tibble will have 27 rows and 2 columns)
  
UKgas_by_year <- 
  
  
  
  
#5. **Bonus:** Convert your long tibble back to wide. This should be the same as the UKgas data. 
#   Compute the mean gas consumption by year. 
#   Hint: Have a look at https://stackoverflow.com/questions/50352735/calculate-the-mean-of-some-columns-using-dplyrmutate 
#   (Your tibble will have 27 rows and 6 columns). As you can see, working with long data is simpler in R.
  
UKgas <-
  
  
  
  
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




### 4.2 Examples (incomplete) ---------------------------------------------

#4.2.1 add a variable to the benefit_long tibble containing the year, and convert the variable to a factor
benefit_long <- benefit_long %>%
  mutate() %>%
  mutate()  

#4.2.2 summarise average number of benefits by year, and add error bar max/min values
benefit_by_year <- benefit_long %>%
  filter() %>%
  group_by() %>%
  summarise(average_apps = , 
            error_bar_min = , 
            error_bar_max = 
  )

head(benefit_by_year)

#4.2.3 plot as a bar chart
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


### 4.3 Exercises ---------------------------------------------------------

#1. Plot the UKgas consumption by year as a line graph, with quarters shown in different colours. 
#   Change the axes labels to something of your choice and add a title.
#   Use the `UKgas_l` data set created in exercise 3.2.
g <- ggplot(UKgas_l, aes(x = , 
                         y = , 
                         group = ,
                         colour = )) + 
  geom_line() +
  xlab("") +   ## Alternatively, all labels can be changed in a single line using labels(title = "", x="", y="")
  ylab("")

g

#2. Plot the same as above, but include a line for the mean gas consumption across quarters. 
#   You will first need to append the UKgas_by_year to your data
UKgas_l_with_mean <- UKgas_l %>% 
  bind_rows(UKgas_by_year %>% 
              # Specify the value that should appear in the "quarter" column
              mutate() %>%
              # ensure that column names match
              rename()

g2 <- ggplot(UKgas_l_with_mean, aes(x = , 
                                    y = , 
                                    group = , 
                                    colour = )) + 
  geom_line() +
  xlab("") + 
  ylab("")

g2

#3. Create the same plot as above (including the mean), but use thin lines for quarter, and a thick line for the mean. 
#   You will need to add a new numeric variable to the data used in the previous exercise that specifies a value for line thickness. 
#   See the examples in `?geom_line` for details around specifying aesthetics for the line graph and how to do this by group. 
#   You will also need to look at `?scale_linewidth`

# Add a linewidth value, to do this you will have to create a new column with a condition. 
# Look at ?if_else to see how to make a new column that shows '2' when "quarter == 'Mean'" and '1' otherwise.
# The numbers are not crucial as these will be rescaled in the plot.
UKgas_l_with_mean <- UKgas_l_with_mean %>% 
  mutate(linewidth = if_else())

g3 <- ggplot(UKgas_l_with_mean, aes(x = , 
                                    y = , 
                                    group = , 
                                    colour = )) + 
  #Implement the linewidth using geom_line()
  geom_line() +
  #specify the range that the linewidths should span, and disable the linewidth legend
  scale_linewidth(range = ,
                  guide = ) +
  xlab("") + 
  ylab("")

g3

