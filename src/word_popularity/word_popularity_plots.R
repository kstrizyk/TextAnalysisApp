library(data.table)
library(ggplot2)



# crucial words related to war vector
words = c("war", "putin", "zelensky", "ukraine", "russia", 
          "bucha","kharkiv", "mariupol", "war crimes")

# function searching word popularity over time (per date)
word_occurrence = function(words, tableOfAllTweets){
  tableOfWords = tableOfAllTweets[, .(date)]
  tableOfWords[,date:= format(as.POSIXct(date,format='%Y-%m-%d %H:%M:%S'),format='%Y-%m-%d')]
  for (word in words){
    tableOfWords[, (word):=as.integer(grepl(word, tableOfAllTweets$tweetContent))]
    tableOfWords[, (word):=sum(get(word)), by=date]
  }
  tableOfWords =tableOfWords[, date := as.Date(date)]
  unique(tableOfWords)
}
tableOfWords = word_occurrence(words)


# function drawing plot

word_popularity_plot = function(word){
  ggplot(tableOfWords)+geom_point(aes(x=date,y=get(word)))+labs(x="months of 2022", 
                      y="number of tweets containing this word", title = "Plot showing word popularity in tweets daily", 
                      subtitle = paste("selected word:", word))+theme(plot.title = 
                      element_text(hjust = 0.5), plot.subtitle = 
                      element_text(hjust = 0.5, color ="navy"),
                      panel.background = element_rect( fill="white",
                      colour='black'), panel.grid.major = 
                      element_line(colour = "black"),)+scale_x_date(date_labels = "%m")
}







