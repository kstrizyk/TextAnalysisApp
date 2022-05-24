path = config::get('path-dir')[['data-twitter']]

library(data.table)
library(jsonlite)


files = list.files(path)

file1 = files[1]

full_path = paste(path, file1, sep ="/")


data1 = read_json(full_path)
class(data1)
length(data1)
names(data1)
data1[['data']]
#  HOW TO READ DATA1 TO DATATABLE?

