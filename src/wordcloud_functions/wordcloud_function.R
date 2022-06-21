library(wordcloud2)
library(tm)
library(SnowballC)

# input:
# usersID = c(...)                             # jako wektor character 
# time_limits = c("yyyy-mm-dd", "yyyy-mm-dd")  # jako wektor character ("rok-miesiąc-dzien")

wordcloud_function <- function(df, usersID, time_limits, max_words){
  
  df = df[ , c("date", "userId", "tweetContent")]
  df = df[ , date := as.Date(date, format = "%y/%m/%d")]
  df = df[ , userId := as.character(userId)]
  
  # wybieramy użytkowników
  df = df[df$userId %in% usersID, ]
  
  # wybieramy przedział czasowy
  time_limits = as.Date(time_limits)
  df = df[df$date >= time_limits[1] & df$date <= time_limits[2], ]
  
  corpus = Corpus(VectorSource(df[, tweetContent]))
  # corpus = tm_map(corpus, stemDocument)
  
  word_freq = TermDocumentMatrix(corpus)
  word_freq = as.matrix(word_freq)
  freq = sort(rowSums(word_freq), decreasing = TRUE)
  print(names(freq))
  word_freq = data.table(words = names(freq), freq = freq)
  wordcloud_plot = wordcloud2(word_freq[1:max_words], shuffle = FALSE)
  wordcloud_plot
}


# # PRZYKŁAD dla input
# usersID = c("19527964")
# time_limits = c("2022-04-30", "2022-04-30")
# df = fread(config::get('path-file')[['clean-tweets']], integer64 = "character")
# wordcloud_function(df, usersID, time_limits, max_words=30)

