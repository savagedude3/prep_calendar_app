#practice with dates

#dates from R4ds https://r4ds.had.co.nz/dates-and-times.html?q=date#prerequisites-10

#Google Calendar import format https://support.google.com/calendar/answer/37118?co=GENIE.Platform%3DDesktop&hl=en#zippy=%2Ccreate-or-edit-a-csv-file

library(lubridate)

prepDay <- ymd(20210630)
print(prepDay + 1)

lastDIV <- 100

prepTasks <- character(101)

customDF <- "DIV 0: prep day,,DIV 2: feed neurons w/ AraC,DIV3:feed neurons"


#placeholder for app if statement
if (TRUE){
  
  
  customString <- customDF
  splitString <- unlist(strsplit(customString, ","))
  
  for (i in 1:length(splitString)) {
    prepTasks[i] = splitString[[i]]
  }
}


for (i in 1:length(prepTasks)) {
  if (prepTasks[i] == "" || is.na(prepTasks[i])){
    prepTasks[i] = NA
  }
}


dateVector <- seq(prepDay, prepDay + lastDIV, by="days")

calDataFrame <- data.frame(prepTasks)
calDataFrame <- cbind(calDataFrame, dateVector)


cleanDF <- calDataFrame[complete.cases(calDataFrame), ]

colnames(cleanDF) <- c("Subject", "Start date")
