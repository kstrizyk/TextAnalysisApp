library(wordcloud)
library(RColorBrewer)


# input:
# usersID = c(...)                             # jako wektor character 
# time_limits = c("yyyy-mm-dd", "yyyy-mm-dd")  # jako wektor character ("rok-miesiąc-dzien")

wordcloud_function <- function(usersID, time_limits, max_words){
  
  # Wczytywanie danych
  df = fread(config::get('path-file')[['clean-tweets']])
  
  df = df[ , c("date", "userId", "tweetContent")]
  df = df[ , date := as.Date(date, format = "%y/%m/%d")]
  df = df[ , userId := as.character(userId)]
  
  # wybieramy użytkowników
  df = df[df$userId %in% usersID, ]
  
  # wybieramy przedział czasowy
  time_limits = as.Date(time_limits)
  df = df[df$date >= time_limits[1] & df$date <= time_limits[2], ]
  
  wordcloud_plot = wordcloud(df$tweetContent, 
                              min.freq = 2,
                              colors = brewer.pal(7,"Dark2"),
                              random.color = FALSE, 
                              random.order = FALSE,
                              max.words = max_words)
}


# PRZYKŁAD dla input
# usersID = c("19527964")                         
# time_limits = c("2022-04-22", "2022-04-30")  
# 
# wordcloud_function(usersID, time_limits, max_words=20)
