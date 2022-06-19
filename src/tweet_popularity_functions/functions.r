library(data.table)
library(ggplot2)

#interesujące mnie kolumny
prepare_tweets_popularity_df = function(df, words) {
  df <-
    df[, c("retweetCount",
           "replyCount",
           "likeCount",
           "quoteCount",
           "tweetContent")]
  df[, `:=`(SUM = rowSums(.SD, na.rm = T)), .SDcols = c("retweetCount", "replyCount", "likeCount", "quoteCount")]
  df <- df[, c("tweetContent", "SUM")]
  
  for (word in c(words)) {
    df[, (word) := as.integer(grepl(word, df$tweetContent))]
  }
  averages = sapply(words, function(word) {
    mean(df[df[[word]] == 1, SUM])
    
  })
  averages['all'] = mean(df[["SUM"]])
  round(averages, 0)
}


tweet_popularity_plot = function(averages_vector, words) {
  averages_vector = averages_vector[words]
  df = data.table(word = names(averages_vector),
                  average_reaction = averages_vector)
  ggplot(data = df, aes(x = word, y = average_reaction, color = word, fill = word)) +
    geom_bar(stat = "identity",
             width = 0.6) + coord_flip() +
    scale_x_discrete() + labs(y = "average reaction",
                              x = "word",
                              title = "average of reactions per tweet") +
    theme_bw()
}

