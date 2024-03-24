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

#Analysis
corr <- cor.test(rstats_tbl$upvotes, rstats_tbl$comments)
corr$estimate
corr$p.value

#Publication
# The correlation between upvotes and comments was r(121) = .52, p = .00. This test was statistically significant.

cat(sprintf("The correlation between upvotes and comments was r(%d) = %s, p = %s. This test %s statistically significant.",
                   corr$parameter, 
                   sub("^0", "",formatC(corr$estimate, format = 'f', digits = 2)), 
                   sub("^0", "", formatC(corr$p.value, format = 'f', digits = 2)),
                   ifelse(corr$p.value < 0.05, "was", "was not")))