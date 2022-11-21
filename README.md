
# Introduction to R

This project contains the material for an introductory course in R.

The material is organised in Markdown files. 
Each session contains Markdown files that are missing some code for students to try it themselves, as
well as a complete solution.

Session 2 contains two versions of the Rmd files. One version uses the
 old dplyr gather() and spread(), the other uses pivot_*().

## Session 1

Testjdfklsfj

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