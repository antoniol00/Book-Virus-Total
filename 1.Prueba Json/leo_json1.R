library(jsonlite)
library(curl)
library(tidyjson)
library(dplyr)

file <- "Android/0ae56408c62a25c828a3c304e30328c162c5382965ce1507f16543cb399bb971.json"

json_data <- read_json(file)

item <- json_data %>% spread_all()

json_data %>% gather_object %>% json_types %>% count(name, type)

colnames(item) # Vemos toda los atributos de cada fichero

 