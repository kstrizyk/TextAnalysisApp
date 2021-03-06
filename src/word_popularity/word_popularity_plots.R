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
    x = "Date",
    y = "Number of tweets",
    title = "Daily number of tweets with selected word",
    subtitle = paste("Selected word:", word)
  ) + theme_bw() +
    theme(
    plot.title =
      element_text(hjust = 0.5, size = 26),
    plot.subtitle =
      element_text(hjust = 0.5, size = 20),
    # panel.background = element_rect(fill = "white",
    #                                 colour = 'black'),
    axis.title.y = element_text(size=20),
    axis.title.x = element_text(size=20),
    axis.text.y = element_text(size = 16),
    axis.text.x = element_text(size = 16)
  ) + scale_x_date(date_labels = "%Y-%m")
}



