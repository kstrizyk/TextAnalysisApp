library(data.table)
library(ggplot2)

#choosing columns, that matter in this functionality
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

#function drawing plot
tweet_popularity_plot = function(averages_vector, words) {
  averages_vector = averages_vector[words]
  df = data.table(word = names(averages_vector),
                  average_reaction = averages_vector)
  ggplot(data = df,
         aes(
           x = word,
           y = average_reaction,
           color = word,
           fill = word
         )) +
    geom_bar(stat = "identity",
             width = 0.6) + coord_flip() +
    scale_x_discrete() + labs(y = "Average reaction",
                              x = "Words",
                              title = "Average reaction to Tweets with given word") +
    theme_bw() +
    theme(
      plot.title =
        element_text(hjust = 0.5, size = 26),
      plot.subtitle =
        element_text(
          hjust = 0.5,
          color = "navy",
          size = 20
        ),
      # panel.background = element_rect(fill = "white",
      #                                 colour = 'black'),
      axis.title.y = element_text(size = 20),
      axis.title.x = element_text(size = 20),
      axis.text.y = element_text(size = 20),
      axis.text.x = element_text(size = 16),
      legend.position = "none"
    )
}
