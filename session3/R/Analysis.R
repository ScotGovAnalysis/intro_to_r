library(tidyverse)
library(lubridate)
#This script uses pivot_longer(). To use gather(), uncomment out the relevant lines, and comment out the pivot_longer() lines

# Assumptions imported into a long format 

Benefits = c("Benefit1", "Benefit2", "Benefit3", "Benefit4") 
Types = c('ar', 'coc', 'nc' )
review_prop <- dplyr::tibble(type = Types, 
                             Benefit1 = c(0.1, 0, 0.2), 
                             Benefit2 = c(0.5, 0.8, 0.1), 
                             Benefit3 = c(0, 0, 0), 
                             Benefit4 = c(1, 1, 1)
)  %>% 
  pivot_longer(names_to = "benefit",
               values_to = "review_prop", 
               cols = -type) %>%
  #gather(key = benefit, value = review_prop, -type) %>%
  rename(application_type = type)

appeals_prop <- dplyr::tibble(type = Types, 
                              Benefit1 = c(0.1, 0.5, 0.6), 
                              Benefit2 = c(0.5, 1, 1), 
                              Benefit3 = c(0, 0, 0), 
                              Benefit4 = c(0, 0, 0)
)  %>% 
  pivot_longer(names_to = "benefit",
               values_to = "appeals_prop", 
               cols = -type)  %>%
  #gather(key = benefit, value = appeals_prop, -type)  %>%
  rename(application_type = type)

review_time <- dplyr::tibble(type = Types, 
                             Benefit1 = c(10, 10, 15), 
                             Benefit2 = c(10, 12, 8), 
                             Benefit3 = c(0, 0, 0), 
                             Benefit4 = c(10, 15, 5)
)  %>% 
  pivot_longer(names_to = "benefit",
               values_to = "review_time", 
               cols = -type)  %>%
  #gather(key = benefit, value = review_time, -type)  %>%
  rename(application_type = type)

appeals_time <- dplyr::tibble(type = Types, 
                              Benefit1 = c(10, 10, 15), 
                              Benefit2 = c(10, 12, 8), 
                              Benefit3 = c(0, 0, 0), 
                              Benefit4 = c(10, 15, 5)
)  %>% 
  pivot_longer(names_to = "benefit",
               values_to = "appeals_time", 
               cols = -type)  %>%
  #gather(key = benefit, value = appeals_time, -type)  %>%
  rename(application_type = type)

# Import data
Benefit1 <- read.csv("./Data/Benefit1.csv")
Benefit2 <- read.csv("./Data/Benefit2.csv")
Benefit3 <- read.csv("./Data/Benefit3.csv")
Benefit4 <- read.csv("./Data/Benefit4.csv")
working_days <- read.csv("./Data/working_days.csv")



# Wrangle to long and add benefit type
Benefit1_L <- Benefit1 %>%
  rename(ar = `Award.Reviews`, 
         coc = `Change.of.Circ`, 
         nc = `New.Cases`) %>%
  pivot_longer(cols = -date, 
               names_to = "applications_type", 
               values_to = "applications") %>%
  # gather(key = application_type, 
  #        value = applications, -date) %>%
  mutate(benefit = "Benefit1")

Benefit2_L <- Benefit2 %>%
  rename(nc = `New.Cases`) %>%
  pivot_longer(cols = -date, 
               names_to = "applications_type", 
               values_to = "applications") %>%
  # gather(key = application_type, 
  #        value = applications, -date) %>%
  mutate(benefit = "Benefit2")

Benefit3_L <- Benefit3 %>%
  rename(ar = `Award.Reviews`, 
         coc = `Change.of.Circ`, 
         nc = `New.Cases`) %>%
  pivot_longer(cols = -date, 
               names_to = "applications_type", 
               values_to = "applications") %>%
  # gather(key = application_type, 
  #        value = applications, -date) %>%
  mutate(benefit = "Benefit3")

Benefit4_L <- Benefit4 %>%
  rename(ar = `Award.Reviews`, 
         coc = `Change.of.Circ`, 
         nc = `New.Cases`) %>%
  pivot_longer(cols = -date, 
               names_to = "applications_type", 
               values_to = "applications") %>%
  # gather(key = application_type, 
  #        value = applications, -date) %>%
  mutate(benefit = "Benefit4")

# Combine benefits
data_all <- bind_rows(Benefit1_L, Benefit2_L, Benefit3_L, Benefit4_L) %>%
  #join by benefit and application type
  left_join(review_prop) %>%
  left_join(appeals_prop) %>%
  left_join(review_time) %>%
  left_join(appeals_time) %>%
  left_join(working_days) %>%
  # lag by 2 months grouped by app type and benefit
  group_by(benefit, application_type) %>%
  mutate(
    lagged_applications = lag(applications, 2, default = 0), 
         # compute the review volumes
         review_volumes = lagged_applications * review_prop,
          #lag review volumes by 1 month for appeals
         lagged_reviews = lag(review_volumes, 1, default = 0),          # compute appeal volumes   
         appeals_volumes = lagged_reviews * appeals_prop,
          #compute times from volumes
         total_review_time = review_volumes * review_time, 
         total_appeals_time = appeals_volumes * appeals_time,
         #coumpute total fte for each benefit and application_type
         fte = (total_appeals_time + total_review_time)/(days * 444 * .75)) %>%
  group_by(date, benefit) %>%
  #compute the total fte across the application types
  summarise(total_fte = sum(fte)) %>%
  ungroup()



  