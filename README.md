
ggparci
=======

The goal of ggparci is to allow the comparison of several groups across several variables using parallell coordinates plot, while including confidence intervals.



## Installation

To install the latest ("cutting-edge") GitHub version run:


```r

# You'll need devtools
install.packages.2 <- function (pkg) if (!require(pkg)) install.packages(pkg);
install.packages.2('devtools')
# make sure you have Rtools installed first! if not, then run:
#install.packages('installr'); install.Rtools()


devtools::install_github("ropensci/plotly") # you will probably benefit from the latest version of plotly
devtools::install_github('talgalili/ggparci')

```





## Example


This is a basic example which shows you how to solve a common problem:

``` r
library(ggparci)

ggparci(iris[,-5], iris[,5])
ggparci(normalize(iris[,-5]), iris[,5], ylim = c(0,1))
ggparci(percentize(iris[,-5]), iris[,5], ylim = c(0,1))
ggparci(x = percentize(mtcars[,-10]),group =  factor(mtcars[,10]), ylim = c(0,1))
ggparci(x = percentize(mtcars[,-9]),group =  factor(mtcars[,9]), ylim = c(0,1), lab_group = "automatic\nvs\nmanual")

ggparci(x = percentize(mtcars[,-9]),group =  factor(mtcars[,9]), jitter_median_factor = 0)
ggparci(x = percentize(mtcars[,-9]),group =  factor(mtcars[,9]), jitter_median_factor = 5)

p <- ggparci(x = percentize(mtcars[,-9]),group =  factor(mtcars[,9]), ylim = c(0,1), lab_group = "automatic\nvs\nmanual", flip = TRUE)
library(plotly)
ggplotly(p)

```
