<!-- README.md is generated from README.Rmd. Please edit that file -->
ggparci
=======

The goal of ggparci is to ...

Example
-------

This is a basic example which shows you how to solve a common problem:

``` r

library(plotly)
#> Loading required package: ggplot2
#> 
#> Attaching package: 'plotly'
#> The following object is masked from 'package:ggplot2':
#> 
#>     last_plot
#> The following object is masked from 'package:stats':
#> 
#>     filter
#> The following object is masked from 'package:graphics':
#> 
#>     layout
library(cluster)
#> Warning: package 'cluster' was built under R version 3.4.2
library(ggparci)
tmp_org <- readRDS('data/tmp_org.rds')
clus_r <- pam(tmp_org, k = 2)$cluster
p <- ggparcoord_ci(tmp_org, clus_r, alpha_per_line = 0.01, jitter_median_factor = 2,
                   alpha_geom_ribbon = 0.3, flip = TRUE)+ggtitle('rank') 

p
```

![](README-example-1.png)
