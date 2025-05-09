library(magrittr)
library(readr)
library(performance)
library(ggplot2)
library(dplyr)

dataset <- read.csv("android-simplified.csv")



model <-  lm( positives ~ ., data = dataset %>%
                select(total,size,
                       times_submitted,harmless_votes,malicious_votes,positives))
# Vemos que positives no podemos predicirlo de forma eficiente usando los dem�s atributos

plot(dataset %>%
       select(total,size,
              times_submitted,harmless_votes,malicious_votes,positives))
# Podemos verlo de forma m�s visual en la representaci�n.

summary(model) # Ningun estadistico respalda este modelo.
  
model <-  lm( harmless_votes ~ malicious_votes, data = dataset)
summary(model)


# Malicious votes est� muy relacionada con Harmless votes y un poco con positivies.
# No es fiable porque solo representa 3 casos aislados y todos los que son 0. Osea, cuando
# no hay harmless_votes no suele haber malicious_votes, algo de sentido comun si los archivos
# que se suben no tienen nada raro.

dataset2 %>%
  select(total,size,
         times_submitted,harmless_votes,malicious_votes,positives, Lionic, McAfee) %>%
  filter(malicious_votes > 0 | harmless_votes > 0)


# Despu�s de darles muchas vueltas no llego a nada concluyente. Muchos tipos de datos no 
# son numerico, demasiadas filas NAs. Se necesita de una preparaci�n muy alta.
# Tras la preparaci�n tampoco queda nada concluyente.



android <- dataset %>%
          select(total, size, times_submitted, harmless_votes, malicious_votes, positives) %>%
          cbind(dataset %>%
            select(contains("scans.")) %>%
            mutate_all(~replace(., !is.na(.), 1)) %>%
            mutate_all(~replace(., is.na(.), 0)))
plot(android)


