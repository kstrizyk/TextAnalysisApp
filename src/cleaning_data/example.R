path = config::get('path-dir')[['data-twitter']]

library(data.table)
library(jsonlite)

#  HOW TO READ DATA1 TO DATATABLE?

files = list.files(path)


JSON_to_table<- function(files, i){
  full_path = paste(path, files[i], sep = "/")
  dt = jsonlite::fromJSON(full_path)
  dt_table = data.table::as.data.table(dt$data)
  return(dt_table)
}

dt_long = data.table()

for (i in 1:length(files)){
 name = paste0("table", i) # czy potrzebujemy pojedynczych data.table dla kazdego pliku?
 assign(name, JSON_to_table(files, i))
 dt_long = bind_rows(dt_long, JSON_to_table(files, i))
}


