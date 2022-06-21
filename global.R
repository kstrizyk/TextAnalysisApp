library(shiny)
library(data.table)

# prepare data
tweets = fread(config::get('path-file')[['clean-tweets']],
               integer64 = "character")
users = fread(config::get('path-file')[['users-clean']], integer64 = "character") 

# prepare wordcloud funcionality
source("src/wordcloud_functions/wordcloud_function.R")


# prepare word popularity functionality
source("src/word_popularity/word_popularity_plots.R")
words = c("war", "putin", "zelensky", "ukraine", "russia", 
          "bucha","kharkiv", "mariupol", "war crimes")
word_popularity_df = word_occurrence(words, tweets)

# prepare tweet popularity functionality
source("src/tweet_popularity_functions/functions.r")
popularity_averages = prepare_tweets_popularity_df(tweets, words)
