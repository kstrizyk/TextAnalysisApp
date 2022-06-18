# Ten skrypt:
# 1) włącza wszystkie biblioteki
# 2) wczytuje dane z tweetami
# 3) czyści tweety
# 4) usuwa niepotrzebne słowa z języka angielskiego
# 5) dopisuje oczyszczone tweety do tabeli jako nową kolumnę
# 6) zapisuje gotowy plik jako data/clean/tweets.csv



# -------  1. Libraries ----------
library(data.table)
library(tm)



### ----- 2. Wczytywanie danych ----
tweets_df = fread(config::get('path-file')[['tweets-dt']])
users_df = fread(config::get('path-file')[['users-clean']])


### ---------- 3. Czyszczenie tekstu - cleaning the text ------------------

t40 = tweets_df[1:40, text]
t40


clean = function(t){
  t = gsub("RT @[a-z,A-Z]*: ", "", t)   # usuwa "RT @[name]" (w retweetach)
  t = gsub("RT ", "", t)
  t = gsub("@[a-z,A-Z, _]*", "", t)    # usuwa "@[name]" 
  t = gsub("#[a-z,A-Z]*", "", t)       # usuwa "#[name]" (hashtags)
  t = gsub("&amp;", "", t)             # usuwa &
  
  t = gsub("https://t.co/[a-z,A-Z,0-9]*{8,12}", "", t)   # usuwa linki "https://t.co/[...]"
  t = gsub("<U[+][0-9,A-Z]*{4,8}>", " ", t)               # usuwa emogi postaci <U+0001F535>, <U+FE0F> itd
  
  t = gsub("â€¦", "", t)          # â€¦ to znak "!" zakodowany w CP-1252 (zamiast UTF-8).
  t = gsub("â€™s", "", t)         # â€™ to znak "'" zakodowany w CP-1252 (zamiast UTF-8).
  t = gsub("â€™", "", t)
  t = gsub("'s", "", t)
  t = gsub("'ve", "", t)
  t = gsub("â€™re", "", t) 
  t = gsub("â€™ve", "", t) 
  
  t = gsub("[[:digit:]]", "", t)  # usuwa cyfry (Digits: 0 1 2 3 4 5 6 7 8 9)
  t = gsub("\r\n", " ", t)        # \r\n to nowy wiersz w Windows
  t = gsub("[[:punct:]]", "", t)  # znaki punktuacujne
  t = gsub("[ ]{2,}", " ", t)    # kasuje zbędne spacje
  t = trimws(t)
  t = tolower(t)                  # małe litery (lower case)
  return(t)
}

clean(t40)



### ----- 4. Usuwamy niepotrzebne słowa języka angielskiego  -----------------

stopwords("en")  # standartowe stop-słowa języka angielskiego
our_stopwords <- c("also", "just", "according", "can", "may", "must", "will", 
                   "around", "since", "back", "one", "two", "three", "first", "now",
                   "say", "said", "says", "reported", "many",  "new", "day", "pm", "am")

stopwords <- c(stopwords("en"), our_stopwords)


# kasujemy stop-słowa (najczęściej używane słowa języka angielskiego)
remove_stopwords = function(tweet) {
  tweet_list = strsplit(tweet, split = " ")[[1]]
  paste(tweet_list[sapply(tweet_list, function(x) !(x %in% stopwords))], collapse = " ")
}



remove_stopwords(clean(t40)) #???


# przykład
clean(t40)[5]
remove_stopwords(clean(t40[5]))



### ---- 5. Dopisywanie oczyszczonych tweetów do tabeli (nowa kolumna) ------

tweets = tweets_df[, text]
clean_tweets = clean(tweets)

#clean_tweets2 =    #????


# dodawanie kolumny do tabeli
tweets_df = tweets_df[ , clean_text := clean_tweets]




### ---- 6. Zapisywanie gotowego pliku jako data/raw/tweets_clean.csv ------

write.table(tweets_df, file="data/raw/tweets_clean.csv")




# !!!!!!!!!
# renv::snapshot() => zapisuje funkcje

