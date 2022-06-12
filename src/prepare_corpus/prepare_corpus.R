
getwd()

# Libraries:

libraries <- c("readr", "dplyr", "plyr", "ggplot2", "RColorBrewer", "magrittr", 
               "tidytext", "stringi", "rtweet", "tm", "wordcloud", "SentimentAnalysis")
  
for( i in libraries  ){
  if( ! require( i , character.only = TRUE ) ){
    install.packages( i , dependencies = TRUE )
    require( i , character.only = TRUE )
  }
}




#####  ------ 1. Wczytywanie danych -----
tweets_df <- read_csv(file = "./TextAnalysisApp-feature-clean-twitter-data/data/raw/tweets.csv")
tweets_df

users_clean <- read_csv(file = "./TextAnalysisApp-feature-clean-twitter-data/data/raw/users_clean.csv")
users_clean

# dodajemy do tweets_df dwie kolumny z users_clean
new_name_df <-users_clean %>% select(c("name","fullName","userId"))

tweets_df <- merge(x=tweets_df, y=new_name_df, by="userId")
tweets_df <- tweets_df[,c(9,10,1:8)]


#### ------------- 2. Struktura ----------------------

##  ---- 2.1 Struktura użytkowników (userId)  ---

table(tweets_df$userId)

# wektór, który zachowuje wszsystkie ID użytkowników
ID_vector <- unique(tweets_df$userId)
ID_vector

fullName <- unique(tweets_df$fullName)
fullName

# wybieramy konkretnego użytkownika i przedział czasowy => funkcja


##### ----  3. Tworzymy objekty character i list, gdzie elementy - tweety -----

# --- dla wybranego użytkownika (według ID) ---
x <- c(14224719)
twtext <- tweets_df$text[tweers_df$userId %in% x]
twtext

# --- dla wszystkich użytkowników --
# twitter_text data.table
twtext <- tweets_df$text
twtext
class(twtext)
twtext[1]  # pierwszy tweet


# twitter_text list - lista, gdzie pojedyncze elementy to tweety
twtext_list <- as.list(twtext)
twtext_list

class(twtext_list)
class(twtext_list[[1]])
length(twtext_list)
head(twtext_list, 12)







###### ---------- 4. Czyścimy tekst - cleaning the text ------------------

#remove non-ASCII charaters

clean = function(t){
  #t = gsub('[-]', ' ', t)
  #t = gsub('\\<U+\\>', '', t)
  t = gsub("/[\u{1F600}-\u{1F6FF}]/", "", t)
  t = gsub("[^[:alnum:][:space:]']", "", t)
  t = gsub('[[:cntrl:]]', '', t) 
  t = gsub('[[:digit:]]', '', t)
  t = gsub('\\d+', '', t)
  t = gsub('@\\w+','', t)          # ??????? nie działa
  t = gsub('http\\w+', '', t)
  t = gsub('^\\s+|\\s+$', '', t)

  return(t)
}

# [:punct:] - Punctuation characters: ! " # $ % & ' ( ) * + , - . / : ; < = > ? @ [ \ ] ^ _ ` { | } ~.
# [^'[:^punct:]] - Punctuation characters except "'"
# [^[:alnum:][:space:]'] - It replaces everything that's not (caret symbol!) alphanumeric signs, space or apostrophe with an empty string.
# [:cntrl:] - Control characters. In ASCII, these characters have octal codes 000 through 037, and 177 (DEL). 
# [:digit:] - Digits: 0 1 2 3 4 5 6 7 8 9.
# "@\\w+" - removes usernames
# \d - digits
# \s - znak niedrukowalny, np. spacja, tabulator, nowa linia

twtext_list_clean <- lapply(twtext_list, function(x) clean(x))
head(twtext_list_clean, 12)

# ???? Jak skasować tekst postaci <U+0001F46E> ? emoji


# --- lower case ---
twtext_list_clean_lower <- lapply(twtext_list_clean, function(x) tolower(x))
head(twtext_list_clean_lower, 10)



###### ---------- 5. Corpus -------------------
## kasujemy stop-słowa (najczęściej używane słowa języka angielskiego)

tw.corpus <- Corpus(VectorSource(twtext_list_clean_lower))
class(tw.corpus) # klasa Corpus


stopwords("en") # standartowe stop-słowa języka angielskiego
our_stopwords <- c("also", "just", "according", "can", "may", "must", "will", 
                   "around", "since", "back", "one", "two", "three", "first", "now",
                   "say", "said", "says", "reported", "many",  "new", "day")


stopwords <- c(stopwords("en"), our_stopwords)
stopwords

# bez stop-słów języka angielskiego
tw.corpus_clean <- tm_map(tw.corpus, removeWords, stopwords)
tw.corpus_clean




tw.corpus[[1]]         # porównywanie liczby symboli w pierwszym Tweecie z i bez stop-słów
tw.corpus_clean[[1]][["content"]]



# ------ 6. WordCloud ----------------

par(mfcol=c(1,1))
# ze stop-słowami
wordcloud1 <- wordcloud(tw.corpus, scale=c(3.5,0.5),
                        random.order = FALSE, 
                        rot.per = 0.20, use.r.layout = FALSE, 
                        colors = brewer.pal(6,"Dark2"), 
                        max.words = 50)


# bez stop-słów
wordcloud2 <- wordcloud(tw.corpus_clean, 
                        min.freq=2,
                        #scale=c(1,1), 
                        rot.per = 0.20, 
                        use.r.layout = FALSE, 
                        colors = brewer.pal(7,"Dark2"),
                        random.color=TRUE, 
                        random.order = FALSE,
                        max.words = 100)



###### -------- 7. Sentiment Analysis --------------

# --> obtain list of positive and negative words
pos.words <- scan(file="positive-words.txt", what="chraracter", comment=";")
neg.words <- scan(file="negative-words.txt", what="character", comment=";")

head(pos.words, 20)
head(neg.words, 20)


