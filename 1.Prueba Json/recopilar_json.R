library(jsonlite)
library(curl)
library(tidyjson)
library(dplyr)

ficheros <- Sys.glob("Android/*.json")

first = TRUE

for (file in ficheros){
    json_data <- read_json(file)
    if(first){
      android <- json_data %>% spread_all()
      first = FALSE
    }else {
      android <- bind_rows(android,json_data %>% spread_all())
    }
}
android <- apply(android,2,as.character)
write.csv(android,file="android.csv")
rm(file)
rm(first)
rm(json_data)
rm(ficheros)

