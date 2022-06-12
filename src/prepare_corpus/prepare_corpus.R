# Libraries:
library(data.table)
# libraries <- c("readr", "dplyr", "plyr", "ggplot2", "RColorBrewer", "magrittr",
#                "tidytext", "stringi", "rtweet", "tm", "wordcloud", "SentimentAnalysis")
# 
# 
# for( i in libraries  ){
#   if( ! require( i , character.only = TRUE ) ){
#     install.packages( i , dependencies = TRUE )
#     require( i , character.only = TRUE )
#   }
# }


# 
tweets = fread(config::get('path-file')[['tweets-dt']])
users = fread(config::get('path-file')[['users-clean']])



# --- dla wybranego użytkownika (według ID) ---
# x <- c(14224719)
# twtext <- tweets_df$text[tweers_df$userId %in% x]
# twtext
# 
# # --- dla wszystkich użytkowników --
# # twitter_text data.table
# twtext <- tweets_df$text
# twtext
# class(twtext)
# twtext[1]  # pierwszy tweet


# twitter_text list - lista, gdzie pojedyncze elementy to tweety
twtext_list <- as.list(twtext)
twtext_list

class(twtext_list)
class(twtext_list[[1]])
length(twtext_list)
head(twtext_list, 12)







###### ---------- 4. Czyścimy tekst - cleaning the text ------------------

#remove non-ASCII charaters

# TO REMOVE FROM TWEETS:
# emojis
# 

t30 = tweets[1:30, text]

clean = function(t){
  t = gsub("\\+", "", t)
  t = gsub('<\\w+>', '', t)
  t = gsub("RT", "", t)
  t = gsub('@\\w+','', t)
  t = gsub("\\n", " ", t)
  t = gsub("[^[:alnum:][:space:]']", "", t)
  t = gsub('[[:cntrl:]]', '', t)
  t = gsub('[[:digit:]]', '', t)
  t = gsub('\\d+', '', t)
  t = gsub('http\\w+', '', t)
  t = gsub('^\\s+|\\s+$', '', t)

  return(t)
}

clean(t30)
t30[29]
# emoji letftovers
# polaczone słowa (po usunięciu kropek czasem słowa się łączą.)
# usunąć apostrofy z koncowkami
# usunąć rt


# [:punct:] - Punctuation characters: ! " # $ % & ' ( ) * + , - . / : ; < = > ? @ [ \ ] ^ _ ` { | } ~.
# [^'[:^punct:]] - Punctuation characters except "'"
# [^[:alnum:][:space:]'] - It replaces everything that's not (caret symbol!) alphanumeric signs, space or apostrophe with an empty string.
# [:cntrl:] - Control characters. In ASCII, these characters have octal codes 000 through 037, and 177 (DEL). 
# [:digit:] - Digits: 0 1 2 3 4 5 6 7 8 9.
# "@\\w+" - removes usernames
# \d - digits
# \s - znak niedrukowalny, np. spacja, tabulator, nowa linia

twtext_list_clean <- lapply(t30, function(x) tolower(clean(x)))
head(twtext_list_clean, 12)

# ???? Jak skasować tekst postaci <U+0001F46E> ? emoji


# --- lower case ---
twtext_list_clean_lower <- lapply(twtext_list_clean, function(x) tolower(x))
head(twtext_list_clean_lower, 10)



###### ---------- 5. Corpus -------------------
## kasujemy stop-słowa (najczęściej używane słowa języka angielskiego)
library(tm)

tw.corpus <- Corpus(VectorSource(twtext_list_clean))
class(tw.corpus) # klasa Corpus



stopwords("en") # standartowe stop-słowa języka angielskiego
our_stopwords <- c("also", "just", "according", "can", "may", "must", "will", 
                   "around", "since", "back", "one", "two", "three", "first", "now",
                   "say", "said", "says", "reported", "many",  "new", "day")


stopwords <- c(stopwords("en"), our_stopwords)

# bez stop-słów języka angielskiego
tw.corpus_clean <- tm_map(tw.corpus, removeWords, stopwords)
length(tw.corpus_clean)



remove_stopwords = function(tweet) {
  
  tweet_list = strsplit(tweet, split = " ")[[1]]
  paste(tweet_list[sapply(tweet_list, function(x) !(x %in% stopwords))], collapse = " ")
  
}
remove_stopwords(clean(t30[1]))


tw.corpus[[1]]         # porównywanie liczby symboli w pierwszym Tweecie z i bez stop-słów
tw.corpus_clean[[1]][["content"]]
View(tw.corpus_clean)

library(wordcloud)

# Co ma robić ten skrypt:
# włączać wszystkie biblioteki
# wczytywać dane z tweetami
# czyścić tweety
# usunać niepotrzebne słwoa z języka angielksiego
# dopisać oczyszczone tweety do tabeli jako nowa kolumna
# zapisać gotowy plik jako data/clean/tweets.csv





# ------ 6. WordCloud ----------------

# par(mfcol=c(1,1))
# # ze stop-słowami
# wordcloud1 <- wordcloud(t30, scale=c(3.5,0.5),
#                         random.order = FALSE, 
#                         rot.per = 0.20, use.r.layout = FALSE, 
#                         colors = brewer.pal(6,"Dark2"), 
#                         max.words = 50)
# 
# 
# # bez stop-słów
# wordcloud2 <- wordcloud(tw.corpus_clean, 
#                         min.freq=2,
#                         #scale=c(1,1), 
#                         rot.per = 0.20, 
#                         use.r.layout = FALSE, 
#                         colors = brewer.pal(7,"Dark2"),
#                         random.color=TRUE, 
#                         random.order = FALSE,
#                         max.words = 100)
# 
# 
# 
# ###### -------- 7. Sentiment Analysis --------------
# 
# # --> obtain list of positive and negative words
# pos.words <- scan(file="positive-words.txt", what="chraracter", comment=";")
# neg.words <- scan(file="negative-words.txt", what="character", comment=";")
# 
# head(pos.words, 20)
# head(neg.words, 20)


