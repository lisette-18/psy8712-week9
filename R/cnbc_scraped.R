# Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(tidyverse)
library(rvest)


#Data Import and Cleaning
sections <-  c("Buiness", "Investing", "Tech", "Politics") #import sections that we will be using
urls <- c("https://www.cnbc.com/business/", "https://www.cnbc.com/investing/","https://www.cnbc.com/technology/", "https://www.cnbc.com/politics/")  #import the respective URLs
cnbc_tbl <- tibble(headline = character(), length = integer(), source = character()) #creating a tibble per instruction requirements and leaving it empty to be run in the forloop

for(i in 1:length(sections)) { #using forloop to loop over the four desired sections
  web <- read_html(urls[i]) #import the links 
  headlines <- web %>% #scrape the headlines 
    html_nodes(".Card-title") %>%
    html_text(trim = TRUE) 
  length <- str_count(headlines, "\\S+") #count number of words in each string
  source <- sections[i] 
  tbl_2 <- tibble(headline = headlines, #create a new tibble to be used 
                  length = length,
                  source = source)
  cnbc_tbl <- rbind(cnbc_tbl, tbl_2) #this recombines them after the foodloop looped ver all four sections
}

#Visualization
ggplot(cnbc_tbl, aes(x = source, y = length)) +
  geom_boxplot() + #creating a visualization and using boxplot because i assume we want to see the distribution
  labs(x = "Source of Headline", y = "Number of words in headline", title = "Boxplot of source and length of headlines")

#Analysis
sum_aov <- summary(aov(length ~ source, data = cnbc_tbl)) #conduct anova comparing length across all four soruces, code provided in instructions
#i see a significant difference between the four sources with p value pf .02


#Publication
#The results of an ANOVA comparing lengths across sources was F(3, 130) = 3.34, p = .02. This test was statistically significant.

cat(sprintf("The results of an ANOVA comparing lengths across sources was F(%d, %d) = %.2f, p = %s. This test %s statistically significant.",
                   dfn = sum_aov[[1]]$'Df'[1] , #pulled the first degrees of freedom
                   dfd = sum_aov[[1]]$'Df'[2], #pulled the second degrees of freedom
                   F_value = sum_aov[[1]]$'F value'[1], #pull the f value
                   p_value =  sub("^0\\.", ".", formatC(sum_aov[[1]]$'Pr(>F)'[1], format = 'f', digits = 2)), #pull the p-value
                   ifelse(p_value < 0.05, "was", "was not"))) #was or was not statement provided by class instructions
#for the dfn, dfd, f value, and p_value, had to put the information in ' ' because of the way that the aov summary is created so that r would know the extact information to pull