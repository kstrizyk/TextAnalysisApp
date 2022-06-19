library(data.table)
library(ggplot2)

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


# function drawing plot

word_popularity_plot = function(word, tableOfWords) {
  ggplot(tableOfWords, aes(x = date, y = get(word))) + 
    # geom_point() +
    geom_line(color = "navy") +
    labs(
    x = "date",
    y = "number of tweets containing this word",
    title = "Plot showing word popularity in tweets daily",
    subtitle = paste("selected word:", word)
  ) + theme_bw() +
    theme(
    plot.title =
      element_text(hjust = 0.5, size =30),
    plot.subtitle =
      element_text(hjust = 0.5, color = "navy", size = 20),
    panel.background = element_rect(fill = "white",
                                    colour = 'black'),
    axis.title.y = element_text(size=16),
    axis.title.x = element_text(size=16)
  ) + scale_x_date(date_labels = "%Y-%m")
}


# # Example
# df = fread("data/clean/tweets.csv", integer64 = "character")
# df = word_occurrence(words, df)
# word_popularity_plot(words[1], df)

