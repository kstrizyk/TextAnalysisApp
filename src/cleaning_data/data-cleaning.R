# GET PATH TO JSON FILES
path = config::get('path-dir')[['data-twitter']]


# ACTIVATE NEEDED LIBRARIES
library(data.table)
library(jsonlite)
library(readr) #USED FOR READ_CSV BECAUSE OF PROBLEMS WITH READ.CSV


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
colNamesNewTweets =  c("date", "userId", 
                 "text", "tweetId", "retweetCount", 
                 "replyCount", "likeCount", "quoteCount")
setnames(tableOfAllTweets, colNamesNewTweets)
tableOfAllTweets[, userId:=as.character(userId)] #CHANGE COLUMN TYPE TO BE THE SAME AS IN USERS.CSV


# 2. CREATE CSV FILE FOR ALL TWEETS

path1 = config::get('path-dir')[['data-raw']]
write.csv(tableOfAllTweets, paste(path1, "/tweets.csv", sep=""), row.names = FALSE)

# 3. UPDATE USERS.CSV, 
#    ADDING FIRST AND LAST TWEET ID AND DATE FOR EACH USER,
#    ALSO CHANGE COLUMN NAMES IN THIS FILE


# READING USERS.CSV AS DATA.TABLE
# AND CHANGING COLUMN NAMES
tableOfAllUsers = fread(paste(path1, "/users.csv", sep=""))

tableOfAllUsers[, data.public_metrics.listed_count := NULL] 

colNamesNewUsers =  c("name", "fullName",
                 "description", "userId", "verification",
                 "followersCount", "followingCount", "tweetCount", 
                 "lastUpdate")

setnames(tableOfAllUsers, colNamesNewUsers)

tableOfAllUsers[, userId := as.character(userId)]

# FIRST AND LAST TWEET AND DATES OF THESE TWEETS - NEW COLUMNS
#NUMBER OF USER IN TWEETS.CSV AND USERS.CSV IS NOT EQUAL

summaryTweets = tableOfAllTweets[, .(lastTweetId = max(tweetId), 
                                    firstTweetId = min(tweetId),
                                    lastTweetDate = max(as.Date(date)),
                                    firstTweetDate = min(as.Date(date))), by = userId]





tableOfAllUsers =merge(tableOfAllUsers, summaryTweets, by = "userId")



path1 = config::get('path-dir')[['data-raw']]
write.csv(tableOfAllUsers, paste(path1, "/users_clean.csv", sep=""), row.names = FALSE)

 
 

