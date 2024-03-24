#Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(tidyverse)
library(RedditExtractoR)

#Data Import and Cleaning
urls <- find_thread_urls(subreddit = "rstats", period = "month") #based on the directions from the class slides, this code is used to extract urls from threads from a subreddit on reddit, in this case "rstats" 
thread_content <- get_thread_content(urls$url) #based on the directions from the class slides, this code is used to extract threads given the url provided

#created a tibble, using tibble because i am using building a data frame
rstats_tbl <- tibble(post = thread_content$threads$title, #pulled the titles from each thread and assigned to the variable post, per the class instructions
                        upvotes = thread_content$threads$upvotes, #pulled the number of upvotes from each thread and assigned to the variable upvotes, per the class instructions
                        comments = thread_content$threads$comments) #pulled the number of comments from each thread and assigned to the variable comments, per the class instrutions

#Visualization
ggplot(rstats_tbl, aes(x = upvotes, y = comments)) + #because the two variables are continous, i used a scatterplot to display the relationship between the variables
  geom_point() +
  geom_smooth(method = "lm", color = "pink") +
  labs(x = "Upvotes", y = "Comments", title = "Scatterplot of the Upvotes and Comments")

#Analysis
corr <- cor.test(rstats_tbl$upvotes, rstats_tbl$comments) #using cor.test(), provided by the class instrcutions to determine the correlation and p-value between the two variables
corr$estimate #the estimate is 0.52 
corr$p.value #the p-value is less than 0.001 which indicated that the results are statistically signficant 

#Publication
# The correlation between upvotes and comments was r(121) = .52, p = .00. This test was statistically significant.

cat(sprintf("The correlation between upvotes and comments was r(%d) = %s, p = %s. This test %s statistically significant.", #provided the message and used cat to print the message to the console
                   corr$parameter, #pulled the degress of freedom from the correlation test
                   sub("^0", "",formatC(corr$estimate, format = 'f', digits = 2)),#pulled the correlation estimate from the cor.test(), removed the leading zeros and only provided 2 digits after the decimal 
                   sub("^0", "", formatC(corr$p.value, format = 'f', digits = 2)), #pulled the p.value estimate from the cor.test(), removed the leading zeros and only provided 2 digits after the decimal 
                   ifelse(corr$p.value < 0.05, "was", "was not"))) #this code was used for the output so that R knew if the corr.test p.value was less than 0.05 to report as signficant and if greater than 0.05 to report as not significant