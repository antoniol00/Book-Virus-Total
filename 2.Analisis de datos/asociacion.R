library(readr)
android <- read_csv("Book-Virus-Total/android-simplified.csv")

library(arules)
library(arulesViz)

android <- android %>%
  select(first_seen,total,size,times_submitted,harmless_votes,
         malicious_votes,positives,submission.submitter_country,
         additional_info.exiftool.FileType)

#Discretizamos valores numéricos

summary(android$first_seen)
android$first_seen <- ordered(cut(android$first_seen, as.POSIXlt(c("2012-12-18 03:26:17","2018-07-10 06:31:39","2020-05-15 10:44:33","2021-11-03 08:17:04","2021-11-03 09:25:14"))),
                              labels = c("btw2012-2018","btw2018-2020","btw2020-2021","last2021"))
android$total <- discretize(android$total,method="frequency",breaks=4,
                          labels = c("few","less","more","most"))
summary(android$size)
android$size <- ordered(cut(android$size, c("1152","611482","2669106","4518866","178355426")),
                              labels = c("LessThan597KB","MoreThan597KBLessThan2.54MB","MoreThan2.54MBLessThan4.3MB","MoreThan4.3MB"))
android$times_submitted <- discretize(android$times_submitted,method="interval",breaks=4,
                            labels = c("few","less","more","most"))

android$harmless_votes <- discretize(android$harmless_votes,method="interval",breaks=4,
                                     labels = c("few","less","more","most"))
android$malicious_votes <- discretize(android$malicious_votes,method="interval",breaks=4,
                                      labels = c("few","less","more","most"))
android$positives <- discretize(android$positives,method="interval",breaks=4,
                                labels = c("few","less","more","most"))
# Eliminamos valores NA

android <- android %>% na.omit()

#Extraemos reglas
rules <- android %>% apriori(parameter = list(minlen=3))

summary(rules)

rules_red <- rules[!is.redundant(rules)]

rules_sorted <- sort(rules_red, by="lift")
inspect(head(rules_sorted))


rules_subset <- subset(rules_sorted,
                       lhs %in% c("additional_info.exiftool.FileType=ZIP") &
                      lift > 1.05)
inspect(head(rules_subset))

plot(rules_subset, method="graph", engine="graphviz")

