library(tidyverse)
library(lubridate)
#This script uses pivot_longer(). To use gather(), uncomment out the relevant lines, and comment out the pivot_longer() lines

# Assumptions imported into a long format 
Benefits = c("Benefit1", "Benefit2", "Benefit3") 
Types = c('coc', 'nc' )

#First applications come in, are processed and a decisions made (time: 2 months)
initial_time <- dplyr::tibble(type = Types, 
                              Benefit1 = c(20, 12), 
                              Benefit2 = c(25, 12), 
                              Benefit3 = c(15, 10)
)  %>% 
  pivot_longer(names_to = "benefit",
               values_to = "initial_time", 
               cols = -type)  %>%
  #gather(key = benefit, value = review_time, -type)  %>%
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
review_time <- dplyr::tibble(type = Types, 
                              Benefit1 = c(10, 10), 
                              Benefit2 = c(10, 12), 
                              Benefit3 = c(10, 15)
)  %>% 
  pivot_longer(names_to = "benefit",
               values_to = "review_time", 
               cols = -type)  %>%
  #gather(key = benefit, value = appeals_time, -type)  %>%
  rename(application_type = type)


# Import data
Benefit1 <- read.csv("./Data/Benefit1.csv")
Benefit2 <- read.csv("./Data/Benefit2.csv")
Benefit3 <- read.csv("./Data/Benefit3.csv")
working_days <- read.csv("./Data/working_days.csv")



# Wrangle to long and add benefit type
Benefit1_L <- Benefit1 %>%
  rename(coc = `Change.of.Circ`, 
         nc = `New.Cases`) %>%
  pivot_longer(cols = -date, 
               names_to = "application_type", 
               values_to = "applications") %>%
  # gather(key = application_type, 
  #        value = applications, -date) %>%
  mutate(benefit = "Benefit1")

Benefit2_L <- Benefit2 %>%
  rename(coc = `Change.of.Circ`,
         nc = `New.Cases`) %>%
  pivot_longer(cols = -date, 
               names_to = "application_type", 
               values_to = "applications") %>%
  # gather(key = application_type, 
  #        value = applications, -date) %>%
  mutate(benefit = "Benefit2")

Benefit3_L <- Benefit3 %>%
  rename(coc = `Change.of.Circ`, 
         nc = `New.Cases`) %>%
  pivot_longer(cols = -date, 
               names_to = "application_type", 
               values_to = "applications") %>%
  # gather(key = application_type, 
  #        value = applications, -date) %>%
  mutate(benefit = "Benefit3")



# Combine benefits
data_all <- bind_rows(Benefit1_L, Benefit2_L, Benefit3_L) %>%
  #join by benefit and application type
  left_join(initial_time) %>%
  left_join(review_prop) %>%
  left_join(review_time) %>%
  left_join(working_days) %>%
  # lag by 2 months grouped by app type and benefit
  group_by(benefit, application_type) %>%
  mutate(
    lagged_applications = lag(applications, 2, default = 0), 
         # compute the review volumes
         review_volumes = lagged_applications * review_prop,
          #compute times from volumes
         total_review_time = review_volumes * review_time, 
         #compute total FTE for each benefit and application_type
         fte = (total_review_time + initial_time)/(days * 444 * .75)) %>%
  group_by(date, benefit) %>%
  #compute the total fte across the application types
  summarise(total_fte = sum(fte)) %>%
  ungroup()



  