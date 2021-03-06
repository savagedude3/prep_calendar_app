# Prep Calendar App

library(shiny)
library(lubridate)

ui <- fluidPage(
  dateInput(inputId = "prepDate",
            label = "Choose Prep Date",
            value = today()),
  selectInput(inputId = "prepType",
              label = "Choose Prep Type",
              choices = c("Rt Coculture", "Ms Astro","Lenti Prep","Lenti Titer","custom")),
  textInput(inputId = "customSchedule",
            label = "Type Custom Schedule with a comma between each DIV including an extra comma for each intervening DIV",
            value = "DIV 0: prep day,,DIV 2: feed neurons w/ AraC,DIV 3: feed neurons"),
  
  tableOutput(outputId = "table"),
  
  # Button
  downloadButton("downloadData", "Download")
)

server <- function(input, output) {
  
  doCalc <- function() {
    prepTasks <- character(101)
    
    if (input$prepType == "Rt Coculture"){
      prepTasks[1] = "DIV 0: prep day";
      prepTasks[3] = "DIV 2: feed neurons w/ AraC";
      prepTasks[4] = "DIV 3: feed neurons";
      prepTasks[6] ="DIV 5: feed astros w/ AraC";
      prepTasks[7] ="DIV 6: feed neurons";
      prepTasks[8] = "DIV 7: astro passage";
      prepTasks[10] = "DIV 9: transfect astros & feed neurons";
      prepTasks[12] = "DIV 11: co-culture";
      prepTasks[14] = "DIV 13: fix and primary";
      prepTasks[15] = "DIV 14: secondary and mounting";
    }
    
    if (input$prepType == "Ms Astro"){
      #has to be DIV + 1 since R starts at 1
      prepTasks[1] = "DIV 0: Prep Day"
      prepTasks[2] = "DIV 1: feed astros w/ AraC"
      prepTasks[4] = "DIV 3: feed astros"
      prepTasks[6] = "DIV 5: astro shakeoff"
      prepTasks[7] = "DIV 6: feed astros"
      prepTasks[8] = "DIV 7: astro passage"
      prepTasks[9] = "DIV 8: transduce astros"
      prepTasks[11] = "DIV 10: feed astros w/ Puro"
      prepTasks[13] = "DIV 12: feed astros w/ Puro"
      prepTasks[16] = "DIV 15: Collect RNA"
    }
    
    if (input$prepType == "Lenti Prep"){
      #has to be DIV + 1 since R starts at 1
      prepTasks[1] = "DIV 0: Passage Cells"
      prepTasks[2] = "DIV 1: Transfect Cells"
      prepTasks[3] = "DIV 2: Replace Media"
      prepTasks[4] = "DIV 3: Collection 1"
      prepTasks[5] = "DIV 4: Collection 2"
    }
    
    if (input$prepType == "Lenti Titer"){
      #has to be DIV + 1 since R starts at 1
      prepTasks[1] = "DIV 0: Passage Cells"
      prepTasks[2] = "DIV 1: Transduce Cells"
      prepTasks[3] = "DIV 2: DNaseI Treatment"
      prepTasks[5] = "DIV 4: Collect DNA"
    }
    
    if (input$prepType == "custom"){
      
      customString <- input$customSchedule
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
    
    dateVector <- seq(input$prepDate, input$prepDate + 100, by="days")
    
    calDataFrame <- data.frame(prepTasks)
    calDataFrame <- cbind(calDataFrame, as.character(dateVector))
    
    cleanDF <- calDataFrame[complete.cases(calDataFrame), ]
    
    colnames(cleanDF) <- c("Subject", "Start date")
    
    return(cleanDF)
  }
  
  doCalcDayNames <- function(){
    tempDF <- doCalc()
    Day_of_the_Week <- wday(tempDF$`Start date`, label = TRUE)
    cbind(tempDF, Day_of_the_Week)
  }
  
  output$table <- renderTable({
    doCalcDayNames()
  })
  
  # Downloadable csv of selected dataset ----
  output$downloadData <- downloadHandler(
    filename = function() {
      paste(input$prepType, ".csv", sep = "")
    },
    content = function(file) {
      write.csv(doCalc(), file, row.names = FALSE)
    }
  )
}

shinyApp(ui = ui, server = server)