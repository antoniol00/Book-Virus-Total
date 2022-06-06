library(readr)
library(magrittr)
library(dplyr)
library(ggplot2)
android <- read_csv("Book-Virus-Total/android.csv")

colnames(android)

#Vamos a quedarnos con las columnas mas importantes

android <- android %>%
  select(scan_date,first_seen,last_seen,total,size,
         times_submitted,harmless_votes,malicious_votes,positives,
         submission.submitter_country,additional_info.exiftool.FileType,
         additional_info.androguard.TargetSdkVersion,
         contains(".result"))

write.csv(android,file="android-simplified.csv")

# Visualizamos datos
plot(android %>%
       select(scan_date,first_seen,last_seen,total,size,
     times_submitted,harmless_votes,malicious_votes,positives))
