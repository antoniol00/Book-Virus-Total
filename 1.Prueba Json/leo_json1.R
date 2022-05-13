library(jsonlite)
library(curl)
library(tidyjson)
library(dplyr)

file <- "0ae56408c62a25c828a3c304e30328c162c5382965ce1507f16543cb399bb971.json"
#json_data <- fromJSON(txt = file)
#View(json_data)


json_data <- fromJSON(file) 
glimpse(json_data)

json_data %>% json_lengths()

json_data %>%  json_complexity()




json_data1 <- read_json(file)

glimpse(json_data1)


t1 <- json_data1 %>% gather_object
t1  

tbl <- json_data1 %>%
  spread_all()
tbl



json_data1 %>% json_lengths()

 

json_data1 %>%  json_complexity()


json_data1 %>% gather_object %>% json_types %>% count(name, type)


# https://github.com/colearendt/tidyjson
# https://cran.microsoft.com/snapshot/2017-08-01/web/packages/tidyjson/vignettes/introduction-to-tidyjson.html
# https://rdrr.io/cran/tidyjson/f/vignettes/introduction-to-tidyjson.Rmd
# https://hendrikvanb.gitlab.io/2018/07/nested_data-json_to_tibble/


 