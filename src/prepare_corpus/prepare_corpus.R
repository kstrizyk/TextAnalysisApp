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


### ---------- 3. Czyszczenie tekstu - cleaning the text ------------------

clean = function(t){
  t = gsub("RT @[a-z,A-Z]*: ", "", t)   # usuwa "RT @[name]" (w retweetach)
  t = gsub("RT ", "", t)
  t = gsub("@[a-z,A-Z]* ", "", t)       # usuwa "@[name]" 
  t = gsub("#[a-z,A-Z]* ", "", t)       # usuwa "#[name]" (hashtags)
  t = gsub("&amp;", "", t)              # usuwa &
  
  t = gsub("https://t.co/[a-z,A-Z,0-9]*{8,12}", "", t)   # usuwa linki "https://t.co/[...]"
  t = gsub("<U[+][0-9,A-Z]*{4,8}>", " ", t)              # usuwa emogi postaci <U+0001F535>, <U+FE0F> itd
  
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
  t = gsub("[ ]{2,}", " ", t)     # kasuje zbędne spacje
  t = gsub("\\n", " ", t)
  t = gsub("  ", " ", t)
  t = trimws(t)
  t = tolower(t)                  # małe litery (lower case)
  return(t)
}

tweets_df[, tweetContent := lapply(.SD, clean), .SDcols = "text"]



### ----- 4. Usuwamy niepotrzebne słowa języka angielskiego  -----------------

our_stopwords <- c("also", "just", "according", "can", "may", "must", "will", 
                   "around", "under", "since", "back", "one", "two", "three", "first", "now",
                   "say", "said", "says", "reported", "many",  "new", "day", "pm", "am")

stopwords <- c(stopwords("en"), our_stopwords)


# kasujemy stop-słowa (najczęściej używane słowa języka angielskiego)
remove_stopwords = function(tweets) {
  tweet_list = strsplit(tweets, split = " ")
  sapply(tweet_list, function(tweet) {
    paste(tweet[!(tweet %in% stopwords)], collapse = " ")
  })
}



### ---- 5. Dopisywanie oczyszczonych tweetów do tabeli (nowa kolumna) ------

tweets_df[, tweetContent := lapply(.SD, remove_stopwords), .SDcols = "tweetContent"]

tweets_df[, text := NULL]

### ---- 6. Zapisywanie gotowego pliku jako data/clean/tweets.csv ------

fwrite(tweets_df, file=config::get('path-file')[['clean-tweets']])


