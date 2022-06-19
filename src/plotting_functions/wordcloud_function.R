library(wordcloud)
library(RColorBrewer)


# input:
# usersID = c(...)                             # jako wektor character 
# time_limits = c("yyyy-mm-dd", "yyyy-mm-dd")  # jako wektor character ("rok-miesiąc-dzien")


wordcloud_function <- function(usersID, time_limits, max_words = 100){
  
  # time_period - wektor, który zawiera wszystkie daty z przedziału time_limits
  time_limits = as.Date(time_limits)
  time_period = seq(time_limits[1], time_limits[2], by = "day")
  
  # Wczytywanie danych
  df = fread(config::get('path-file')[['clean-tweets']])
  
  df = df[ , c("date", "userId", "tweetContent")]
  df = df[ , date := as.Date(date, format = "%y/%m/%d")]
  df = df[ , userId := as.character(userId)]
  
  # wybieramy użytkowników
  df = df[df$userId %in% usersID, ]
  
  # wybieramy przedział czasowy
  df = df[df$date %in% time_period, ]
  
  wordcloud_plot = wordcloud(df$tweetContent, 
                              min.freq=2,
                              colors = brewer.pal(7,"Dark2"),
                              random.color=TRUE, 
                              random.order = FALSE,
                              max.words = max_words)
}


# PRZYKŁAD dla input
usersID = c("428333", "759251")              # jako wektor character 
time_limits = c("2022-04-25", "2022-04-30")  # jako wektor character ("rok-miesiąc-dzien")


wordcloud_function(usersID, time_limits, max_words=100)
