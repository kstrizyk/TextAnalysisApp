path = config::get('path-dir')[['data-twitter']]

library(data.table)
library(jsonlite)


#  HOW TO READ DATA1 TO DATATABLE?

files = list.files(path)

#FUNCTION TURNING JSON FILE TO TABLE
JSON_to_table<- function(file_name){
  full_path = paste(path, file_name, sep = "/")
  dt = fromJSON(full_path)
  dt_table = as.data.table(dt$data)
  return(dt_table)
}

listOfAll = lapply(files, JSON_to_table)
tableOfAll = rbindlist(listOfAll, use.names = TRUE)



#WE NEED TO ADD 2 EXTRA COLUMNS FOR EACH USER IN USERS.CSV
#COLUMNS SHOULD CONTAIN INFO ABOUT LAST AND FIRST TWEET FOR EACH USER
  #PROBLEM: IN DATA.TABLE WE HAVE USER.ID, IN CSV FILE WE HAVE USER.NAME

