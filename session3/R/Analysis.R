library(tidyverse)
library(lubridate)
#This script uses pivot_longer(). To use gather(), uncomment out the relevant lines, and comment out the pivot_longer() lines

# Assumptions imported into a long format 
Benefits = c("Benefit1", "Benefit2", "Benefit3") 
Types = c('coc', 'nc' )

#First applications come in, are processed and a decisions made (time: 2 months)
app_processing_time <- dplyr::tibble(type = Types, 
                              Benefit1 = c(150, 220), 
                              Benefit2 = c(140, 125), 
                              Benefit3 = c(167, 120)
)  %>% 
  pivot_longer(names_to = "benefit",
               values_to = "app_processing_time", 
               cols = -type)
  #gather(key = benefit, value = review_processing_time, -type)  %>%
  

#2 months later a proportion of these application will need the decision reviewed
review_prop <- dplyr::tibble(type = Types, 
                             Benefit1 = c(0.3, 0.4), 
                             Benefit2 = c(0.8, 0.65), 
                             Benefit3 = c(0.2, 0.3)
)  %>% 
  pivot_longer(names_to = "benefit",
               values_to = "review_prop", 
               cols = -type) 
  #gather(key = benefit, value = review_prop, -type) %>%


#This is the amount of time a review takes
review_processing_time <- dplyr::tibble(type = Types, 
                              Benefit1 = c(170, 140), 
                              Benefit2 = c(130, 112), 
                              Benefit3 = c(120, 145)
)  %>% 
  pivot_longer(names_to = "benefit",
               values_to = "review_processing_time", 
               cols = -type)
  #gather(key = benefit, value = appeals_time, -type)  %>%


# Import data
benefit1 <- read.csv("./data/benefit_1.csv")
benefit2 <- read.csv("./data/benefit_2.csv")
benefit3 <- read.csv("./data/benefit_3.csv")
working_days <- read.csv("./data/working_days.csv")


# Wrangle to long and add benefit type
benefit1_l <- benefit1 %>%
  rename(coc = `change.of.circumstances`, 
         nc = `new.cases`) %>%
  pivot_longer(cols = -date, 
               names_to = "application_type", 
               values_to = "applications") %>%
  mutate(benefit = "Benefit1")

benefit2_l <- benefit2 %>%
  rename(coc = `change.of.circumstances`, 
         nc = `new.cases`) %>%
  pivot_longer(cols = -date, 
               names_to = "application_type", 
               values_to = "applications") %>%
  mutate(benefit = "Benefit2")

benefit3_l <- benefit3 %>%
  rename(coc = `change.of.circumstances`, 
         nc = `new.cases`) %>%
  pivot_longer(cols = -date, 
               names_to = "application_type", 
               values_to = "applications") %>%
  mutate(benefit = "Benefit3")

#In order to join the processing time tibbles to the benefits dataframes ensure the variables we want to join on have consistent names

app_processing_time %>%
rename(application_type = type)

review_prop %>%
rename(application_type = type)

review_processing_time %>%
rename(application_type = type)

# Combine benefits
data_all <- bind_rows(benefit1_l, benefit2_l, benefit3_l) %>%
  #join by benefit and application type
  left_join(app_processing_time) %>%
  left_join(review_prop) %>%
  left_join(review_processing_time) %>%
  left_join(working_days, by = "date") %>%
  # lag by 2 months grouped by app type and benefit
  group_by(benefit, application_type) %>%
  mutate(
    #First calculate the amount of time needed for initial applications that come in this month
    total_initial_processing_time = applications * app_processing_time,
    #Then work out the time needed for review applications, recall that applicants can request a review for an application they made 2 months ago
    lagged_applications = lag(applications, 2, default = 0), 
         # compute the review volumes
         review_volumes = lagged_applications * review_prop,
          #compute times from volumes
         total_review_processing_time = review_volumes * review_processing_time, 
         #compute total FTE for each benefit and application_type, note that 444 is the number of minutes in a working day, and 0.75 is the estimated time an employee is productive
         #the denominator then is the number of working days in the month * number of working minutes in a day * 0.75
          fte = (total_review_processing_time + total_initial_processing_time)/(days * 444 * .75)) %>%
  group_by(date, benefit) %>%
  #compute the total fte across the application types
  summarise(total_fte = sum(fte)) %>%
  ungroup()



  