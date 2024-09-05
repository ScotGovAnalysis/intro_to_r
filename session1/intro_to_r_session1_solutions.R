
# Session 1 ---------------------------------------------------------------


## Section 1: Introduction ------------------------------------------------


# 1.4 Examples ------------------------------------------------------------

#1.4.1
x <- 3

#1.4.2
x

#1.4.3
x <- c(3, 2, 4)

# 1.6 Examples ------------------------------------------------------------

#1.6.1
?mean

### 1.7 Exercises ---------------------------------------------------------


# 1.  Create a new value called y which is equal to 17.

y <- 17

# 2.  Now multiply y by 78. What answer do you get?

y * 78 #1326

# 3.	What does the command "head" do?

?head

## Section 2: Data Processing ---------------------------------------------

### 2.1 Examples ----------------------------------------------------------

#2.1.1
getwd()

#2.1.2
setwd("C:/Users/u446122/Documents/OFFLINE/Training/intro_to_r/intro_to_r")


### 2.2 Examples ----------------------------------------------------------

#2.2.1
library("tidyverse")

#2.2.2
help(package=dplyr)

### 2.3 Examples ----------------------------------------------------------

#2.3.1
chick_weights <- read_csv("chickweights.csv")

#2.3.2
data(iris)
iris

### 2.4 Examples ----------------------------------------------------------

#2.4.1
View(iris)

#2.4.2
str(iris)

#2.4.3
summary(iris)

#2.4.4
iris[10,4]

#2.4.5
iris[c(10, 12),4]

#2.4.6
iris[10,1:3]

#2.4.7
iris[-10,1:3]

#2.4.8
iris$Species

### 2.5 Examples ----------------------------------------------------------

#2.5.1
class(iris$Sepal.Length) 

#2.5.2
iris$Sepal.Length <- as.integer(iris$Sepal.Length)

#2.5.3
iris$Sepal.Length <- as.numeric(iris$Sepal.Length)

#2.5.4
data(iris)
iris

#2.5.5
levels(iris$Species)

#2.5.6
iris$Species <- relevel(iris$Species, "versicolor")

#2.5.7
iris$Species <- as.character(iris$Species)  

#2.5.8
iris$Species <- as.factor(iris$Species)  


### 2.7 Exercises ---------------------------------------------------------

# reload the iris dataset

data(iris)

# 1. Find the mean and median of the Sepal.Length variable in the iris dataset.

mean(iris$Sepal.Length)

median(iris$Sepal.Length)

# 2. Find the max and min for the Petal.Length variable in the iris dataset.

max(iris$Petal.Length)

min(iris$Petal.Length)

## Section 3: Data wrangling and 'group by' calculations ------------------

### 3.1 Examples ----------------------------------------------------------

#3.1.1
setosa_sepal_leng <- filter(iris, Species == "setosa" & Petal.Length < 1.5)

#3.1.2
setosa_sepal_leng_av <- summarise(setosa_sepal_leng, ave = mean(Sepal.Length))

#3.1.3
setosa_sepal_leng_av <- iris %>% 
  filter(Species == "setosa" & Petal.Length < 1.5) %>% 
  summarise(ave = mean(Sepal.Length))

#3.1.4
setosa_sepal_leng_av <- summarise(filter(iris, Species == "setosa" & Petal.Length < 1.5), ave = mean(Sepal.Length))


### 3.2 Examples ----------------------------------------------------------

#3.2.1
?dplyr::summarise
?group_by

#3.2.2
sepal_length_average <- iris %>% 
  group_by(Species) %>%
  summarise(ave = mean(Sepal.Length))

#3.2.3
sepal_length_average <- 
  summarise(group_by(iris, Species),
            ave = mean(Sepal.Length))

#3.2.4
sepal_length_average <- iris %>% 
  group_by(Species) %>%
  summarise(ave = mean(Sepal.Length), 
            count=n())

#3.2.5
sepal_length_average <- iris %>% 
  group_by(Species) %>%
  summarise(ave = mean(Sepal.Length), count=n()) %>%
  ungroup()

### 3.3 Examples ----------------------------------------------------------

#3.3.1
iris_no_sepal_length <- iris %>% 
  select(-Sepal.Length)

#3.3.2
iris_petals <- iris %>% 
  select(-c(Sepal.Length, Sepal.Width))

### 3.4 Examples ----------------------------------------------------------

#3.4.1
iris_petals <- iris_petals %>%
  rename(P.Length = Petal.Length,
         P.Width = Petal.Width) 

### 3.5 Examples ----------------------------------------------------------

#3.5.1
?mutate

#3.5.2
iris_petals <- iris_petals %>% 
  mutate(P.Area = P.Length * P.Width)

### 3.6 Examples ----------------------------------------------------------

#3.6.1
iris <- iris %>% 
  mutate(small_p_length = if_else(Petal.Length<2,1,0))


### 3.7 Exercises ---------------------------------------------------------

# reload the iris dataset and load library

library(tidyverse)
data(iris)

# 1.  Using group_by and summarise, calculate the average and max petal width for each species.

iris_summary <- iris %>%
  group_by(Species) %>%
  summarise(ave_petal_width = mean(Petal.Width),
            max_petal_width = max(Petal.Width)) %>%
  ungroup()

# 2.  Using select and filter to produce a table of sepal length and widths for irises where the sepal width is greater than 3.

iris_filtered <- iris %>%
  select(Sepal.Length, Sepal.Width) %>%
  filter(Sepal.Width > 3)

## Section 4: Merging data, missing values and exporting ------------------

### 4.1 Examples ----------------------------------------------------------

#4.1.1
staff_salaries <- read_csv("staff_salaries.csv")
staff_sickness <- read_csv("staff_sickness.csv")

#4.1.2
staff_sickness <- staff_sickness %>%
  rename(staff_id = staff_id_no) 

#4.1.3
staff_merge <- inner_join(staff_salaries, 
                          staff_sickness, 
                          by="staff_id")

#4.1.4
staff_salary_preserved_with_sickness_joined <-
  left_join(staff_salaries,
            staff_sickness,
            by="staff_id")

#4.1.5
staff_sickness_preserved_with_sickness_joined <- 
  right_join(staff_salaries,
             staff_sickness,
             by="staff_id")

#4.1.6
staff_sickness_preserved_with_salaries_joined <- 
  left_join(staff_sickness,
            staff_salaries,
            by="staff_id")

#4.1.7
staff_all <- full_join(staff_salaries,
                       staff_sickness,
                       by="staff_id")


### 4.2 Examples ----------------------------------------------------------

#4.2.1
write_csv(iris_petals, file = "iris_petals.csv")


### 4.3 Exercises ---------------------------------------------------------

# reload the iris dataset, and load tidyverse

library(tidyverse)
data(iris)

# 1.	Create a new dataset called iris_sepals which includes the species, sepal length and sepal width

iris_sepals <- iris %>%
  select(Species, Sepal.Length, Sepal.Width)

# 2.	Export the dataset iris_sepals to a csv file.
  
write_csv(iris_sepals, file = "iris_sepals.csv")
