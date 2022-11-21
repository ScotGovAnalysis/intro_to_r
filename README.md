
# Introduction to R

This project contains the material for an introductory course in R.

The material is split into three sections and is delivered via Markdown files. 
Each session contains datasets as well as Markdown files that are missing some code for students to try it themselves, as well as a complete solution.

*Session 2 contains two versions of the Rmd files. One version uses the
 old dplyr gather() and spread(), the other uses pivot_*().*

## Session 1

Session 1 beings by presenting an overview of the R programming language. It then presents syntax in Base R, before introducing some elements of the dplyr and lubridate packages

The first section presents information on R, including the utility/applications of open source computing and the properties of coding in the RStudio IDE. Concepts introduced are:
 - assignment operator `<-`
 - concatenate `c()`
 - `.R` or script files

The second section shows how to set up a working directory, then how to:
 - Install packages with the `library()` call (using the tidyverse as an example)
 - Read in datasets with `read_csv()`
 - Check data classes with:
   - `class()`
   - `as.integer()`
   - `as.numeric()`
   - `as.character()`
   - `as.factor()`
 - Caclculate an assortment of numerical and statistical functions
 
The third section shows the following `dplyr` syntax:
 - `group_by()` and `summarise()`
 - `filter()`
 - `select()`
 - `rename()`
 - `mutate()`
 - `if_else()` #SHOULD PRESENT `case_when()` INSTEAD?

The final session shows how to merge datasets, incorporating syntax from previous sections, with `inner_join()`, `left_join()`, `right_join()` and `full_join()`. Also how to export dataframes with `write_csv()`
 


## Session 2

This session covers the importation and examination of data using the console and some basic plots. It then proceeds to tidying data for some more detailed analysis and ploting.

In the first section, the following functions are used:
 - read_csv
 - head
 - str
 - summary
 - is.na
 - sum
 - plot
 
In the second part data manipulations and plotting are covered:
 - pivot_longer
 - group_by
 - summarise
 - ungroup
 - bind_rows
 - mutate
 - filter
 - lubridate::year
 - as.factor
 - ggplot ...

Additional statistical functions
 - mean
 - sd

Some detail of ggplot coverage:
 - aes(x,y,group, colour)
 - geom_point, geom_line, geom_smooth, geom_col, geom_errorbar
 - facet_grid
 - theme_bw
 - xlab, ylab
 - position_dodge

## Session 3