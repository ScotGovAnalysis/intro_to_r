
# Introduction to R

This project contains the material for an introductory course in R.

The material is split into three sessions. 

Each session contains the relevant datasets for the session, as well as the R files. The main course material is delivered through **R markdown**. R Markdown allows you to
easily create dynamic documents, presentations and reports from R. It
combines markdown (simple formatting syntax) and embedded R code chunks that are run and can perform calculations. The R Markdown files are identified with a .Rmd suffix. See [How to use the session material](#how_to) for details on how to use R Markdown.

Within each session, the Rmd files which end with `_incomplete` are a version of the session material that is missing some code.  Students should work through this version, and refer to the complete solution for answers. Session 2 contains two versions of the Rmd files. One version uses the old dplyr gather() and spread(), the other uses pivot_().

The housekeeping folder contains material that was used to develop the course and does not form part of the training.

## <a name="how_to"></a>How to use the session material

A demo video of how to use the training material can be found [here](https://www.youtube.com/watch?v=1sie-g1Ku-c).

You will be using RStudio to interface with R. When you open RStudio, you will see the window split into four panels.

![Figure 1. The four panels of the RStudio window: 1. Source; 2. Console; 3. Environment/History; 4. Files/Plots/Packages/Help](./housekeeping/rstudio_panels.svg "The four panels of the RStudio window: 1. Source; 2. Console; 3. Environment/History; 4. Files/Plots/Packages/Help")

The source panel is where R files can be viewed and edited. This is the panel in which the course material will appear when you open it. The console window is used to type commands directly into R. The Environment tab in the Environment/History panel shows the objects that exist in your R session. The History tab contains all the commands that you have given to R in the current session. The other tabs in this panel will not be needed for now.  The Files tab in the final panel shows you the files in your working directory. You can open files from this panel as you would from Windows Explorer. Other relevant tabs will be referred to when needed in the course.



### R projects

Each session is structured as an R project. To open the the session, click on the relevant .Rproj file. This sets up the session within R as is required for the session.

### R Markdown 

R markdown is a file format for making dynamic
documents with R. Markdown is a simple formatting syntax which can be used to create HTML, PDF, Word documents and other formats.\
Markdown provides a means of integrating text and code and other embedded material to create a robust and reproducible output document when compiled.

R Markdown is written in plain text, which R can interpret as either text to format, or to compute as code. More details can be found in the demo video.

## Course contents

### Session 1

Session 1 begins by presenting an overview of the R programming language. It then presents syntax in Base R, before introducing some elements of the dplyr and lubridate packages

The first section presents information on R, including the utility/applications of open source computing and the properties of coding in the RStudio IDE. Concepts introduced are:

* assignment operator `<-`
* concatenate `c()`
* `.R` or script files

The second section shows how to set up a working directory, then how to:

* Install packages with the `library()` call (using the tidyverse as an example)
* Read in datasets with `read_csv()`
* Check data classes with:

   * `class()`
   * `as.integer()`
   * `as.numeric()`
   * `as.character()`
   * `as.factor()`
   
 * Calculate an assortment of numerical and statistical functions
 
The third section shows the following `dplyr` syntax:

* `group_by()` and `summarise()`
* `filter()`
* `select()`
* `rename()`
* `mutate()`
* `if_else()`

* Merge datasets, incorporating syntax from previous sections, with `inner_join()`, `left_join()`, `right_join()` and `full_join()`. 

* How to export dataframes with `write_csv()`
 


### Session 2

This session covers the importation and examination of data using the console and some basic plots. It then proceeds to tidying data for some more detailed analysis and ploting.

In the first section, the following functions are used:

-   `read_csv()`
-   `head()`
-   `str()`
-   `summary()`
-   `is.na()`
-   `sum()`
-   `plot()`
 
In the second part data manipulations and plotting are covered:

* `pivot_longer()`
* `group_by()`
* `summarise()`
* `ungroup()`
* `bind_rows()`
* `mutate()`
* `filter()`
* `lubridate::year()`
* `as.factor()`
* `ggplot()`

Additional statistical functions

* `mean()`
* `sd()`

Some detail of ggplot coverage:
 - `aes(x,y,group, colour)`
 - `geom_point()`, `geom_line()`, `geom_smooth()`, `geom_col()`, `geom_errorbar()`
 - `facet_grid()`
 - `theme_bw()`
 - `xlab()`, `ylab()`
 - `position_dodge()`

## Session 3

This session provides an opportunity to put everything learned during previous sessions into practice. It outlines a hypothetical scenario, with a specific ask to create a plot and a table. 

To be honest this section looks pretty underdeveloped. A more fleshed-out example which comprises the data importing, tidying, *and* visualsation functions covered in sessions 1 and 2 would likely be a more effective means of embedding the materials.

* `aes(x,y,group, colour)`
* `geom_point()`, `geom_line()`, `geom_smooth()`, `geom_col()`, `geom_errorbar()`
* `facet_grid()`
* `theme_bw()`
* `xlab()`, `ylab()`
* `position_dodge()`

### Session 3

This session provides an opportunity to put everything learned during previous sessions into practice. It outlines a hypothetical scenario, with a specific ask to create a plot and a table. 