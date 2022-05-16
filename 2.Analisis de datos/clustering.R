library(dplyr)
library(magrittr)
library(arules)
library(cluster)
library(factoextra)
library(readr)

# Importamos los datos simplificados

android <- read_csv('Book-Virus-Total/android-simplified.csv') 

# Eliminamos las columnas con NAs
# Adicionalmente vamos a cambiar los NAs de la columna "additional_info.androguard.TargetSdkVersion"
# por la media de las versiones (necesitamos truncar el resultado) 
# y los de la columna "submission.submitter_country" por "Unknown"
android <- android %>%
           select(-c(scan_date, first_seen, last_seen, submission.submitter_country, additional_info.exiftool.FileType,contains(".result"))) %>%
           mutate(additional_info.androguard.TargetSdkVersion=
                    ifelse(is.na(additional_info.androguard.TargetSdkVersion),
                                 trunc(mean(additional_info.androguard.TargetSdkVersion, na.rm=TRUE)),
                                      additional_info.androguard.TargetSdkVersion))

# Buscamos cual es el mejor numero de clusters
android %>%
  fviz_nbclust(FUNcluster = kmeans, method = "wss",
                      diss = dist(android, method = "manhattan"))
# Como podemos apreciar, el tamaño optimo de cluster es 5:

# Hacemos el kmeans para encontrar los grupos:
grpAnd <- kmeans(android, centers = 5)

grpAnd

orden <- order(grpAnd$cluster)
data.frame(android$...1[orden], grpAnd$cluster[orden])
#Vemos el tamaño de cada cluster
grpAnd$size
# Visualizamos los clusters obtenidos
fviz_cluster(grpAnd, data =android)

#En la grafica podemos encontrar valores muy dispersos como la fila 4, 45, 40, 70, 162, 85, 103, 50, 64,
# Vamos a prescindir de ellos para encontrar grupos más cercanos entre ellos.
# Al eliminar estas filas, las columnas malicious_votes y harmless_votes es costante, por lo que
# las vamos a eliminar
android <- android %>%
            filter(!...1  %in% c(4, 45, 40, 70,  162, 85, 103, 50, 64)) %>%
            select(-c(harmless_votes,malicious_votes))

# Repetimos el proceso de buscar el mejor numero de clusters:
android %>%
  fviz_nbclust(FUNcluster = kmeans, method = "wss",
               diss = dist(android, method = "manhattan"))

grpAnd <- kmeans(android, centers = 3)

orden <- order(grpAnd$cluster)
data.frame(android$...1[orden], grpAnd$cluster[orden])

grpAnd$size
# Visualizamos los clusters obtenidos
fviz_cluster(grpAnd, data =android)
