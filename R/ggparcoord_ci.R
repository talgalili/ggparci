
# x should be a data.frame with each column representing a data dimension
# group = a grouping variable
ggparcoord_ci <- function(x, group, level = 0.95,
                          lab_group = "",
                          lab_y = "", lab_x = "",
                          title = "",
                          ylim, 
                          include_lines = FALSE,
                          seriate = TRUE,
                          facet = FALSE, 
                          flip = FALSE, 
                          alpha_per_line = 0.1,
                          alpha_geom_ribbon = 0.5,
                          jitter_median_factor = 0,
                          ...
) {
  
  library(tidyr)
  library(ggplot2)
  x <- as.data.frame(x)
  if(missing(group)) group <- rep(1, nrow(x))
  x$group <- factor(group)
  alpha <- 1-level
  
  tmp <- x %>% # iris %>% # percentize %>% 
    mutate(row_id = seq_len(n())) %>%  gather(key = "measures", value = "value", -row_id, -group)
  # head(tmp)
  # https://stats.stackexchange.com/a/21116/253
  
  # some ideas from here:
  # http://stackoverflow.com/questions/14033551/r-plotting-confidence-bands-with-ggplot
  predframe <- 
    tmp %>% group_by(measures, group) %>% 
    summarise(median = median(value), n = n(), 
              L = sort(value)[max(qbinom(alpha/2, n(), 0.5), 1)], # the max is to deal with cases of 0
              U = sort(value)[qbinom((1-alpha/2), n(), 0.5)])
  # sort(value)[qbinom(c(.025,.975), n(), 0.5)]
  
  

  if(seriate) {
    measures_df <- predframe %>% select(1:3) %>% spread(key = group, value = median) %>% 
      data.frame
    rownames(measures_df) <- measures_df[,1]
    measures_df <- measures_df[,-1]
    # TODO: control the dist measure
    the_dist <- dist(measures_df) 
    library(seriation)
    # library(dendextend)
    # seriate_dendrogram
    # TODO: control the seriate method.
    # TSP has a random element, we wish to set it to always give the same result
    set.seed(2017-05-06)
    ss_c <- get_order(seriate(the_dist, method = "TSP"))
    seriated_measures <- rownames(measures_df)[ss_c]
    tmp$measures <- factor(tmp$measures, levels = seriated_measures)
    predframe$measures <- factor(predframe$measures, levels = seriated_measures)
  }

  # jittering should be done AFTER seriation.
  if(jitter_median_factor > 0) predframe$median <- jitter(predframe$median, factor = jitter_median_factor)
  
    
  p <- ggplot(data = tmp, aes(x = measures, color = group)) 
  
  if(include_lines) {
    p <- p + geom_line(aes(y = value, group = row_id), size = 0.8, alpha = alpha_per_line)  
  }
  
  p <- p + geom_ribbon(data = predframe, aes(ymin = L, ymax = U, fill = group, 
                                      group = group), 
                alpha = alpha_geom_ribbon, # fill = "grey", 
                color =  adjustcolor( "grey", alpha.f = 0.1)) + 
    geom_line(data = predframe, aes(y = median, color = group, 
                                    group = group), size = 2, alpha = 0.8) +  
    # lims(y = c(0,1)) +
    # theme(axis.text.x=element_text(angle=90, hjust=1) ) + 
    labs(color = lab_group, y = lab_y, x = lab_x, title = title) 
  
  if(!missing(ylim)) p <- p + lims(y = ylim) 
  
  # http://stackoverflow.com/questions/14604435/turning-off-some-legends-in-a-ggplot
  p <- p + guides(fill=FALSE) + 
    guides(color = guide_legend(override.aes = list(alpha = 1)))
  # fix legend alpha becoming transperant
  # http://stackoverflow.com/questions/5290003/how-to-set-legend-alpha-with-ggplot2
  
  
  if(facet) p <- p + facet_grid(group ~ .)
  if(flip) p <- p + coord_flip()
      
  p
}



if(F) {
  ggparcoord_ci(iris[,-5], iris[,5])
  ggparcoord_ci(normalize(iris[,-5]), iris[,5], ylim = c(0,1))
  ggparcoord_ci(percentize(iris[,-5]), iris[,5], ylim = c(0,1))
  ggparcoord_ci(x = percentize(mtcars[,-10]),group =  factor(mtcars[,10]), ylim = c(0,1))
  ggparcoord_ci(x = percentize(mtcars[,-9]),group =  factor(mtcars[,9]), ylim = c(0,1), lab_group = "automatic\nvs\nmanual") 

  ggparcoord_ci(x = percentize(mtcars[,-9]),group =  factor(mtcars[,9]), jitter_median_factor = 0)
  ggparcoord_ci(x = percentize(mtcars[,-9]),group =  factor(mtcars[,9]), jitter_median_factor = 5)
  
  
  
  p <- ggparcoord_ci(x = percentize(mtcars[,-9]),group =  factor(mtcars[,9]), ylim = c(0,1), lab_group = "automatic\nvs\nmanual", flip = TRUE) 
  library(plotly)
  ggplotly(p)
    
}

 
