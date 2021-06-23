# Prep Calendar App

library(shiny)
library(lubridate)

ui <- fluidPage(
  dateInput(inputId = "prepDate",
            label = "Choose Prep Date",
            value = today()),
  selectInput(inputId = "prepType",
              label = "Choose Prep Type",
              choices = c("Rt Coculture", "Ms Astro")),
  
  tableOutput(outputId = "table"),
  
  # Button
  downloadButton("downloadData", "Download")
)

server <- function(input, output) {
  
  doCalc <- function() {
    prepTasks <- character(101)
    
    if (input$prepType == "Rt Coculture"){
      prepTasks[1] = "prep day";
      prepTasks[3] = "feed neurons w/ AraC";
      prepTasks[4] = "feed neurons";
      prepTasks[6] ="feed astros w/ AraC";
      prepTasks[7] ="feed neurons";
      prepTasks[8] = "astro passage";
      prepTasks[10] = "transfect astros & feed neurons";
      prepTasks[11] = "co-culture";
      prepTasks[13] = "fix and primary";
      prepTasks[14] = "secondary and mounting";
    }
    
    if (input$prepType == "Ms Astro"){
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
    }
    
    
    for (i in 1:length(prepTasks)) {
      if (prepTasks[i] == ""){
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
  
  output$table <- renderTable({
    doCalc()
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