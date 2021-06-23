#practice with dates

#dates from R4ds https://r4ds.had.co.nz/dates-and-times.html?q=date#prerequisites-10

#Google Calendar import format https://support.google.com/calendar/answer/37118?co=GENIE.Platform%3DDesktop&hl=en#zippy=%2Ccreate-or-edit-a-csv-file

library(lubridate)

prepDay <- ymd(20210630)
print(prepDay + 1)

lastDIV <- 15

prepTasks <- character(lastDIV + 1)

#has to be DIV + 1 since R starts at 1
prepTasks[1] = "Prep Day"
prepTasks[2] = "feed astros w/ AraC"
prepTasks[4] = "feed astros"
prepTasks[6] = "astro shakeoff"
prepTasks[7] = "feed astros"
prepTasks[8] = "astro passage"
prepTasks[9] = "transduce astros"
prepTasks[11] = "feed astros w/ Puro"
prepTasks[13] = "feed astros w/ Puro"
prepTasks[16] = "Collect RNA"


for (i in 1:length(prepTasks)) {
  if (prepTasks[i] == ""){
    prepTasks[i] = NA
  }
}


dateVector <- seq(prepDay, prepDay + lastDIV, by="days")

calDataFrame <- data.frame(prepTasks)
calDataFrame <- cbind(calDataFrame, dateVector)


cleanDF <- calDataFrame[complete.cases(calDataFrame), ]

colnames(cleanDF) <- c("Subject", "Start date")
