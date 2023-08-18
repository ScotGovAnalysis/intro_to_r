# Create datasets
# #################################

################# 
#Load libraries
library(tidyverse)
library(lubridate)
##################

#Create vector of dates
dates <- seq(as_date("01/04/2020", format = "%d/%m%Y"), 
             as_date("01/03/2025", format = "%d/%m%Y"), 
             by = "month")

# Store the length of the date vector
lngth <- length(dates)

#######################################################
# Function to create linear function with noise
# input:
# m: slope
# c: intercept
# lngth: length of vector
# mean, sd: parameters for Gaussian noise
# output: vector of length lngth

lin_noise <- function(m, c, lngth, mean, sd){
  x <- 1:lngth
  line <- m*x+c
  noise <- rnorm(n = lngth, mean = mean, sd = sd)
  output <- line + noise
  output
}

 
# Alternatively: create a loop that calls the lin_noise function and creates the full (long) dataframe
# ###################################


# Parameter vectors
m = c(1.5, 4, 5)
c = c(500, 300,  190)
mu = c(5, 8, 10)
sig = c(100, 120, 80)
benefit_names= 1:3
###################################
set.seed(99)
for (i in seq(1:length(m))){
  #create a vector with lin_noise
  apps_temp <- lin_noise(m = m[i],
                         c = c[i], 
                         lngth = lngth,
                         mean = mu[i], 
                         sd = sig[i])
  #put the data in tibble with the date and benefit name
  benefit_temp <- tibble(date = as.character(dates), 
                         `new cases` = apps_temp,
                         #sample coc from a vector of integers based on mu and sig. This is arbitrary
                         `change of circumstances` = sample(seq(mu[i]*20:mu[i] * 20 + sig[i]/2),
                                      lngth, replace = TRUE),
                         benefit = benefit_names[i])
  
  #concatenate data to create output tibble
  if (i == 1) {
    benefit_long <-  benefit_temp
  } else {
    benefit_long <- bind_rows(benefit_long, 
                              benefit_temp)
  }
  
  benefit_long %>% 
    mutate_if(is.numeric, as.integer)
}
#view the first few rows of the dataframe
head(benefit_long)

#check that there are no negative numbers in the benefit_long$anc
print("Checking generation of negative numbers of nc")
print(length(which(benefit_long$`new cases` < 0))!=0)


# Export the data
map(benefit_names, ~write_csv(benefit_long %>% 
                                filter(benefit == .x) %>% 
                                select(-benefit),
                              paste0("./data/benefit_", .x, ".csv"), 
                              
                              
                              ))



rm(list=ls())  # clear workspace
