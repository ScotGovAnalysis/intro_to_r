# Create datasets
# #################################

################# 
#Load libraries
library(tidyverse)
library(lubridate)
##################

#Create vector of dates
dates <- seq(as_date("2020/01/01"), 
             as_date("2025/01/01"), 
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
####################################
# Lets create 4 vectors for the # applications for each of the four benefits
apps1 <- lin_noise(m = 1.5,
                   c = 500, 
                   lngth = lngth, 
                   mean =  5, 
                   sd = 100)
apps2 <- lin_noise(m = 4, 
                   c = 300, 
                   lngth = lngth, 
                   mean =  8, 
                   sd = 120)
apps3 <- lin_noise(m = 5, 
                   c = 450, 
                   lngth = lngth,
                   mean =  10, 
                   sd = 100)
apps4 <- lin_noise(m = 5, 
                   c = 190, 
                   lngth = lngth, 
                   mean =  10,
                   sd = 80)
# We could append the date to each of these to create seperate tibbles (dataframe) and then join them
 
 
# Alternatively: create a loop that calls the lin_noise function and creates the full (long) dataframe
# ###################################


# Parameter vectors
m = c(1.5, 4, 5, 5)
c = c(500, 300, 450, 190)
mu = c(5, 8, 10, 10)
sig = c(100, 120, 100, 80)
benefit_names= LETTERS[1:4]
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
                         apps = apps_temp,
                         benefit = benefit_names[i])
  
  #concatenate data to create output tibble
  if (i == 1) {
    benefit_long <-  benefit_temp
  } else {
    benefit_long <- bind_rows(benefit_long, 
                              benefit_temp)
  }
  benefit_long$apps <- as.integer(benefit_long$apps)
}
#view the first few rows of the dataframe
head(benefit_long)

#check that there are no negative numbers in the benefit_long$apps
print("Checking generation of negative numbers of apps")
print(length(which(benefit_long$apps < 0))!=0)



######################################
#Now convert it to wide using pivot_wider()
benefit_wide <- pivot_wider(benefit_long,
                            names_from = benefit, 
                            values_from = apps)
head(benefit_wide)


# And as a test, we can convert this back to long by using pivot_longer()
benefit_long2 <- pivot_longer(benefit_wide, 
                              cols = !date, 
                              names_to = "benefit", 
                              values_to = "apps")


# Export the data
write_csv(benefit_wide, "./benefits.csv")

rm(list=ls())  # clear workspace
