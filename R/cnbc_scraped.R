# Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(tidyverse)
library(rvest)
library(httr)
library(jsonlite)

#Data Import and Cleaning
sections <-  c("Buiness", "Investing", "Tech", "Politics") #import sections that we will be using
urls <- c("https://www.cnbc.com/business/", "https://www.cnbc.com/investing/","https://www.cnbc.com/technology/", "https://www.cnbc.com/politics/")  #import the respective URLs
cnbc_tbl <- tibble(headline = as.character(), length = as.integer(), source = as.character()) #creating a tibble per instruction requirements and leaving it empty to be run in the forloop

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
  labs(x = "Source of Headline", y = "Number of words in headline", title = "Boxplot of soruce and length of headlines")