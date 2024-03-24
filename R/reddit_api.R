#Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(tidyverse)
library(RedditExtractoR)

#Data Import and Cleaning
urls <- find_thread_urls(subreddit = "rstats", period = "month")
thread_content <- get_thread_content(urls$url)

rstats_tbl <- tibble(post = thread_content$threads$title,
                        upvotes = thread_content$threads$upvotes,
                        comments = thread_content$threads$comments)

#Visualization
ggplot(rstats_tbl, aes(x = upvotes, y = comments)) +
  geom_point() +
  geom_smooth(method = "lm", color = "pink") +
  labs(x = "Upvotes", y = "Comments", title = "Scatterplot of the Upvotes and Comments")