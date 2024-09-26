#### Session 3 solutions ####

## Section 1: Importing datasets ----

# 1.1: Read in the CSV file `visits2011.csv`.

# import library
library(tidyverse)

visits_csv <- read_csv("Data/visits2011.csv")


# 1.2: Read in the Excel file `visits201213.xlsx`.

library(readxl)

visits_xl <- read_excel("Data/visits201213.xlsx")


# 1.3: Examine the two datasets. What's the difference between these two datasets?


# 1.4: Stretch: Read in `TRNG.visits` dataset from SAS.

library(haven)

visits_sas <- haven::read_sas("//s0177a/sasdata1/Training/all_visits.sas7bdat") 


## Section 2: Manipulating data ----

# 2.1: Combine the datasets from 1.1 and 1.2.

visits <- bind_rows(visits_csv,visits_xl)


# 2.2: Convert the dataset to a "long" (i.e. "tidy") format.

visits_long <- visits %>% 
  pivot_longer(-c("period", "source3"),
               names_to = "visit_type", 
               values_to = "no_of_trips")


# 2.3: Create a new dataset using `tibble` to use as a lookup table to add the season corresponding to each month.

# Create the lookup
seasons <- tibble(month =seq(1,12), 
                  season = c(rep("winter", 2), rep("spring", 3),
                             rep("summer", 3), rep("autumn", 3), "winter"))

# Create the match variable
visits_months <- visits_long %>% 
  mutate(month = substr(period,5,6) %>%
           as.numeric())

# Combine the datasets
visits_seasons <- visits_months %>% 
  left_join(seasons, by = "month") %>% 
  # Optionally, remove the match variable as it isn't required
  select(-month)


# 2.4: Stretch
# A: Create a date variable using the "period" column.
# B: Use this date variable to create a year variable calld `calendar_year`.

library(lubridate)

# Create date variable
visits_date <- visits_seasons %>% 
  mutate(date = paste0(period,"01") %>% 
           as_date())

# Create year variable
visits_year <- visits_date %>% 
  mutate(calendar_year = year(date))


## Section 3: Analysing data ----

# 3.1: Calculate the total number of trips made during each season.

visits_seasons_total <- visits_seasons %>%
  group_by(season) %>%
  summarise(total_trips_all = sum(no_of_trips)) 


# 3.2: For each visit type, find the total number of trips made during each season.

visits_types_seasons_total <- visits_seasons %>%
  group_by(visit_type, season) %>%
  summarise(total_trips = sum(no_of_trips)) 


# 3.3: For each each season, find the percentage of trips made for each of the visit types. Round this percentage to two decimal places.

visits_types_seasons_pct <- visits_types_seasons_total %>%
  full_join(visits_seasons_total,
            by = "season") %>%
  mutate(pct = total_trips / total_trips_all) %>% 
  mutate(pct = round(pct, digits = 2))

# Alternatively using group_by:
visits_types_seasons_pct2 <- visits_seasons %>%
  group_by(visit_type, season) %>%
  summarise(no_of_trips = sum(no_of_trips)) %>%
  group_by(season) %>%
  mutate(pct = no_of_trips / sum(no_of_trips)) %>% 
  mutate(pct = round(pct, digits = 2))


# 3.4: Stretch: Calculate the monthly change in number of trips, by visit type.

visits_diff <- visits_date %>%
  group_by(visit_type) %>%
  arrange(date) %>%
  mutate(diff = no_of_trips - lag(no_of_trips, default = NA_real_))


## Section 4: Creating outputs ----

# 4.1. Create a bar chart showing the number of trips by calendar year and season.

# Creating a basic bar chart using ggplot
# Choosing the x and y variables
bar_graph_trips <- ggplot(data = visits_year,
                          aes(x = calendar_year,
                              y = no_of_trips)) +
  
  # Define chart type and colour bars by season
  geom_col(aes(fill = season), position = "dodge")


# 4.2 Export `visits_year` to an Excel workbook named "Ex 4.2.xlsx" and save your bar chart as a jpg.

library(writexl)

# Save table
write_xlsx(visits_date, "Ex 4.2.xlsx")

# Save chart
ggsave("bar_chart.jpg", plot = bar_graph_trips)


# 4.3. Stretch: Amend `bar_graph_trips` to create a publication standard chart.

# Order the seasons
visits_year <- visits_year %>% 
  mutate(season = factor(season, levels = c("spring", "summer", 
                                            "autumn", "winter")))

# Use sgplot, an R package for creating accessible plots 
# in the Scottish Government
sgplot::use_sgplot()

# Create chart
bar_graph_trips <- ggplot(data = visits_year,
                          aes(x = calendar_year,
                              y = no_of_trips)) +
  
  # Define chart type and colour bars by season
  geom_col(aes(fill = season), position = "dodge") +
  
  # Label the axes
  labs(x = "Calendar year",
       y = "Number of trips per year",
       
       # These lines add a title and subtitle to the chart, 
       # however it's better for accessibility if titles are 
       # not embedded in charts.
       title = "Visits to Wales by season, 2011 to 2013",
       subtitle = "Source: International Passenger Survey") + 
  
  # Format y-axis labels with thousands comma and define limits
  scale_y_continuous(labels = scales::comma,
                     limits = c(min = 0, max = 6000),
                     breaks = seq(0, 6000, by = 1000)) +
  
  # Capitalise legend title and text
  scale_fill_discrete(name = "Season",
                      labels = c("Spring", "Summer", "Autumn", "Winter")) +
  
  # The sgplot theme sets the axis text as horizontal.
  # This sets the y-axis title back to default (a 90 degree angle)
  # if preferred.
  theme(axis.title.y = element_text(angle = 90))