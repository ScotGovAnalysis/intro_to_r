library(tidyverse)

data(UKgas)
UKgas_tibble <- tibble(UKgas = UKgas, 
                       quarter = rep(c("Qtr1", 
                                       "Qtr2", 
                                       "Qtr3", 
                                       "Qtr4"), 27), 
                       year = rep(1960:1986, 4) %>% 
                         sort()) %>% 
  pivot_wider(names_from = quarter, 
              values_from = UKgas)

write_csv(UKgas_tibble, "./additional_exercises/data/UKgas.csv")
