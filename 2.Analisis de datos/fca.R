library(fcaR)
library(readr)
library(magrittr)
library(dplyr)
library(arules)
android <- read_csv("android-simplified.csv")

#Transformamos a matriz de 0 y 1
android <- android %>%
  select(contains("scans.")) %>%
  mutate_all(~replace(., !is.na(.), 1)) %>%
  mutate_all(~replace(., is.na(.), 0))

#Creamos contexto formal
fc <- FormalContext$new(android)
atr_original <- fc$attributes
fc$objects

#Agrupamos y reducimos
fc <- fc$clarify(TRUE)
fc <- fc$reduce(TRUE)

fc #EXTRAEMOS INFORMACION

# Hay antivirus que nunca han detectado nada
atr_mod <- fc$attributes
setdiff(atr_original,atr_mod) #quitando avast, avg, trendmicro-*

#Hay dos pares de antivirus que detectan lo mismo -> mismo motor
atr_mod[c(39,40)]
android %>% select("scans.Avast.result", "scans.AVG.result")
android %>% select("scans.TrendMicro-HouseCall.result", "scans.TrendMicro.result")

#Hay objetos que son exactamente iguales

obj_mod <- fc$objects
obj_mod[155:length(obj_mod)]

#Buscamos conceptos e implicaciones
fc$find_concepts()
fc$find_implications()

fc$concepts$plot()
fc$implications$cardinality()

rules <- fc$implications$to_arules()

rules_subset <- subset(rules, subset = support>0.8)
length(rules_subset)

inspect(rules_subset[1]@lhs)
inspect(rules_subset[1]@rhs)
android %>% select("scans.AhnLab-V3.result", "scans.ESET-NOD32.result")
inspect(rules_subset[2]@lhs)
inspect(rules_subset[2]@rhs)
android %>% select("scans.DrWeb.result", "scans.ESET-NOD32.result")

fc$implications$apply_rules(c("composition","generalization"))



