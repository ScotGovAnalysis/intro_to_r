
# Session 1 ---------------------------------------------------------------


## Section 1: Introduction ------------------------------------------------


### 1.7 Exercises ---------------------------------------------------------


# 1.  Create a new value called y which is equal to 17.






# 2.  Now multiply y by 78. What answer do you get?






# 3.	What does the command "head" do?






## Section 2: Data Processing ---------------------------------------------

### 2.7 Exercises ---------------------------------------------------------

# reload the iris dataset

data(iris)

# 1. Find the mean and median of the Sepal.Length variable in the iris dataset.






# 2. Find the max and min for the Petal.Length variable in the iris dataset.






## Section 3: Data wrangling and 'group by' calculations ------------------

### 3.7 Exercises ---------------------------------------------------------

# reload the iris dataset

data(iris)

# 1.  Using group_by and summarise, calculate the average and max petal width for each species.

iris_summary <- 
  
  
  

# 2.  Using select and filter to produce a table of sepal length and widths for irises where the sepal width is greater than 3.

iris_filtered <-
  
  


## Section 4: Merging data, missing values and exporting ------------------

### 4.3 Exercises ---------------------------------------------------------

# reload the iris dataset, and load tidyverse

library(tidyverse)
data(iris)

# 1.	Create a new dataset called iris_sepals which includes the species, sepal length and sepal width

iris_sepals <- 

# 2.	Export the dataset iris_sepals to a csv file.
  
write_csv()