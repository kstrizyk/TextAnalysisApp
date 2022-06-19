
library(data.table)
tweets_data_table = fread(config::get('path-file')[['clean-tweets']])

#interesujące mnie kolumny 
tweets_data_table <- tweets_data_table[,c("retweetCount","replyCount","likeCount","quoteCount","tweetContent")]
#dodanie nowej kolumny która odpowiada za miarę aktywności
tweets_data_table[, `:=`(SUM = rowSums(.SD, na.rm=T)), .SDcols=c("retweetCount","replyCount","likeCount","quoteCount")]

tweets_data_table <- tweets_data_table[,c("tweetContent","SUM")]
tweets_data_table <- as.data.table(tweets_data_table)

like_average <- tweets_data_table[,c("SUM")]
like_average <- like_average[[1]]
#ramka do przechowywania slow oraz sreniej
key_word_average <-data.frame(word = character(),
                                     average_reaction = integer())


  #tworzenie  tabeli do zliczania sredniej like'ow dla jednego tweeta
  for(word in words){
    
    word_patern <- lapply(tweets_data_table[,1],grepl,pattern=word) 
    word_patern <- unlist(word_patern[[1]])
    
    tweets_with_key_word <- tweets_data_table[which(word_patern == TRUE),]
    wektor <- tweets_with_key_word[,2]
    wektor <- wektor[[1]]
    key_word_average[nrow(key_word_average) + 1,] <- c(word, round(mean(wektor),0))
  }
  key_word_average[nrow(key_word_average) + 1,] <- c("all", round(mean(like_average),0))
  


#wykres 

library(ggplot2)
word_popularity(words)
ggplot(data=key_word_average, aes(x=word, y=average_reaction)) +
  geom_bar(stat="identity", color="blue", fill="blue") +coord_flip() +
  scale_x_discrete() + labs(x = "average reaction", title = "average of reactions per tweet")
