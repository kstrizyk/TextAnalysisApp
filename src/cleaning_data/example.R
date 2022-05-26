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
colNamesNew =  c("creationDate", "userId", 
                 "text", "tweetId", "retweetCount", 
                 "replyCount", "likeCount", "quoteCount")
setnames(tableOfAllTweets, colNamesNew)


# 2. CREATE CSV FILE FOR ALL TWEETS

# 3. UPDATE USERS.CSV, 
#    ADDING FIRST AND LAST TWEET ID AND DATE FOR EACH USER,
#    ALSO CHANGE COLUMN NAMES IN THIS FILE

