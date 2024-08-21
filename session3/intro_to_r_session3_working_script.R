#### Session 3 ####

## Section 1: Importing datasets ----

# 1.1: Read in the CSV file `visits2011.csv`.

# import library
library(tidyverse)

visits_csv <- 


# 1.2: Read in the Excel file `visits201213.xlsx`.

library(readxl)

visits_xl <- 


# 1.3: Examine the two datasets. What's the difference between these two datasets?


# 1.4: Stretch: Read in `TRNG.visits` dataset from SAS.

library(haven)

visits_sas <- 


## Section 2: Manipulating data ----

# 2.1: Combine the datasets from 1.1 and 1.2.

visits <- 


# 2.2: Convert the dataset to a "long" (i.e. "tidy") format.

visits_long <-


# 2.3: Create a new dataset using `tibble` to use as a lookup table to add the season corresponding to each month.

# Create the lookup
seasons <- 

# Create the match variable
visits_months <-

# Combine the datasets
visits_seasons <-


# 2.4: Stretch
# A: Create a date variable using the "period" column.
# B: Use this date variable to create a year variable calld `calendar_year`.

library(lubridate)

# Create date variable
visits_date <-

# Create year variable
visits_year <-


## Section 3: Analysing data ----

# 3.1: Calculate the total number of trips made during each season.

visits_seasons_total <-


# 3.2: For each visit type, find the total number of trips made during each season.

visits_types_seasons_total <-


# 3.3: For each each season, find the percentage of trips made for each of the visit types. Round this percentage to two decimal places.

visits_types_seasons_pct <-


# 3.4: Stretch: Calculate the monthly change in number of trips, by visit type.

visits_diff <-


## Section 4: Creating outputs ----

# 4.1. Create a bar chart showing the number of trips by calendar year and season.

bar_graph_trips <-


# 4.2 Export `visits_year` to an Excel workbook named "Ex 4.2.xlsx" and save your bar chart as a jpg.

library(writexl)

# Save table
write_xlsx()

# Save chart
ggsave()


# 4.3. Stretch: Amend `bar_graph_trips` to create a publication standard chart.
