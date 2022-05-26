# GET PATH TO JSON FILES
path = config::get('path-dir')[['data-twitter']]

# ACTIVATE NEEDED LIBRARIES
library(data.table)
library(jsonlite)


# 1. HOW TO READ DATA1 TO DATATABLE?

# CREATE FILE LIST
files = list.files(path)

# FUNCTION TURNING JSON FILE TO TABLE
# SINGLE ARGUMENT: NAME 0F THE JSON FILE
# RETURNS CLASS DATA.TABLE
JSON_to_table<- function(file_name){
  full_path = paste(path, file_name, sep = "/")
  dt = fromJSON(full_path)
  dt_table = as.data.table(dt$data) #JUST DATA, WE DO NOT USE META
  return(dt_table)
}

# CREATE LIST OF DATA.TABLES OF ALL FILES IN FILE LIST
listOfAll = lapply(files, JSON_to_table)
# MERGE ALL DATA.TABLES FROM LIST TO ONE DATA.TABLE
tableOfAllTweets = rbindlist(listOfAll, use.names = TRUE)

# CHANGE COLUMN NAMES IN DATA.TABLE OF ALL TWEETS 
# FOR MORE INTUITIVE APPROACH
colNamesNewTweets =  c("creationDate", "userId", 
                 "text", "tweetId", "retweetCount", 
                 "replyCount", "likeCount", "quoteCount")
setnames(tableOfAllTweets, colNamesNewTweets)
tableOfAllTweets[, userId:=as.double(userId)] #CHANGE COLUMN TYPE TO BE THE SAME AS IN USERS.CSV


# 2. CREATE CSV FILE FOR ALL TWEETS

path1 = config::get('path-dir')[['data-raw']]
write.csv(tableOfAllTweets, paste(path1, "/tweets.csv", sep=""), row.names = FALSE)

# 3. UPDATE USERS.CSV, 
#    ADDING FIRST AND LAST TWEET ID AND DATE FOR EACH USER,
#    ALSO CHANGE COLUMN NAMES IN THIS FILE

# READING USERS.CSV AS DATA.TABLE
# AND CHANGING COLUMN NAMES
tableOfAllUsers = as.data.table(read.csv(paste(path1, "/users.csv", sep="")))
colNamesNewUsers =  c("name", "fullName", 
                 "description", "userId", "verification", 
                 "followersCount", "followingCount", "tweetCount",
                 "listedCount", "lastUpdate")
setnames(tableOfAllUsers, colNamesNewUsers)

# FIRST AND LAST TWEET AND DATES OF THESE TWEETS - NEW COLUMNS

#NUMBER OF USER IN TWEETS.CSV AND USERS.CSV IS NOT EQUAL
users = unique(tableOfAllTweets$userId) 
users1 = unique(tableOfAllUsers$userId) #MORE USERS THAN IN TWEETS, BY 7

findCrucialTweets <- function(table,id){
  tableForUser = table[userId == id]
  tableForUser = tableForUser[order(as.Date(tableForUser$creationDate, 
                                            format = "%Y/%m/%d")),]
  firstTweetDate = tableForUser$creationDate[1]
  lastTweetDate = tail(tableForUser$creationDate, n=1)
  firstTweetId = tableForUser$tweetId[1]
  lastTweetId = tail(tableForUser$tweetId, n= 1)
}

#tableOfAllUsers[, `:=` ("firstTweet"=0, "firstTweetDate"=0, "lastTweet"=0, "lastTweetDate"=0)]

