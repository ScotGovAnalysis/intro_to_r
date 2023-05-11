library(tidyverse)
library(lubridate)
#This script uses pivot_longer(). To use gather(), uncomment out the relevant lines, and comment out the pivot_longer() lines

# Assumptions imported into a long format 
Benefits = c("Benefit1", "Benefit2", "Benefit3") 
Types = c('coc', 'nc' )

#First applications come in, are processed and a decisions made (time: 2 months)
app_processing_time <- dplyr::tibble(type = Types, 
                              Benefit1 = c(20, 12), 
                              Benefit2 = c(25, 12), 
                              Benefit3 = c(15, 10)
)  %>% 
  pivot_longer(names_to = "benefit",
               values_to = "app_processing_time", 
               cols = -type)  %>%
  #gather(key = benefit, value = review_processing_time, -type)  %>%
  rename(application_type = type)



#2 months later a proportion of these application will need the decision reviewed
review_prop <- dplyr::tibble(type = Types, 
                             Benefit1 = c(0.1, 0.2), 
                             Benefit2 = c(0.5, 0.65), 
                             Benefit3 = c(0.2, 0.3)
)  %>% 
  pivot_longer(names_to = "benefit",
               values_to = "review_prop", 
               cols = -type) %>%
  #gather(key = benefit, value = review_prop, -type) %>%
  rename(application_type = type)

#This is the amount of time a review takes
review_processing_time <- dplyr::tibble(type = Types, 
                              Benefit1 = c(10, 10), 
                              Benefit2 = c(10, 12), 
                              Benefit3 = c(10, 15)
)  %>% 
  pivot_longer(names_to = "benefit",
               values_to = "review_processing_time", 
               cols = -type)  %>%
  #gather(key = benefit, value = appeals_time, -type)  %>%
  rename(application_type = type)


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
    lagged_applications = lag(applications, 2, default = 0), 
         # compute the review volumes
         review_volumes = lagged_applications * review_prop,
          #compute times from volumes
         total_review_processing_time = review_volumes * review_processing_time, 
         #compute total FTE for each benefit and application_type
         fte = (total_review_processing_time + app_processing_time)/(days * 444 * .75)) %>%
  group_by(date, benefit) %>%
  #compute the total fte across the application types
  summarise(total_fte = sum(fte)) %>%
  ungroup()



  