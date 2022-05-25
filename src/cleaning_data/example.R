path = config::get('path-dir')[['data-twitter']]

library(data.table)
library(jsonlite)
library(dplyr) #IS IT IN SETUP??

#  HOW TO READ DATA1 TO DATATABLE?

files = list.files(path)

#FUNCTION TURNING JSON FILE TO TABLE
JSON_to_table<- function(files, i){
  full_path = paste(path, files[i], sep = "/")
  dt = jsonlite::fromJSON(full_path)
  dt_table = data.table::as.data.table(dt$data)
  return(dt_table)
}

#TABLE OF ALL FILES
dt_long = data.table()

#LOOP CREATING ONE LARGE TABLE FO ALL FILES
for (i in 1:length(files)){
 name = paste0("table", i) # czy potrzebujemy pojedynczych data.table dla kazdego pliku?
 assign(name, JSON_to_table(files, i))
 dt_long = bind_rows(dt_long, JSON_to_table(files, i))
}

#WE NEED TO ADD 2 EXTRA COLUMNS FOR EACH USER IN USERS.CSV
#COLUMNS SHOULD CONTAIN INFO ABOUT LAST AND FIRST TWEET FOR EACH USER
  #PROBLEM: IN DATA.TABLE WE HAVE USER.ID, IN CSV FILE WE HAVE USER.NAME
