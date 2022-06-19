library(shiny)
library(data.table)


words = c("war", "putin", "zelensky", "ukraine", "peace")

# prepare data
tweets = fread(config::get('path-file')[['clean-tweets']],
               integer64 = "character")
users = fread(config::get('path-file')[['users-clean']], integer64 = "character") 

# prepare wordcloud funcionality
source("src/wordcloud_functions/wordcloud_function.R")


