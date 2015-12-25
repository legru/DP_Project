
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#
require(rCharts)
library(shiny)


## import modules

# additional geographic names
source("geography.R")

# data processing functions
source("data_processing.R")

shinyServer(function(input, output) {

  # generate the graph
  output$RefugeesBarChart <- renderChart2( {  ## <- IMPORTANT HERE: use renderChart2
    # within the reactive context of the first histogram

    # column selection
    if (!(1 %in% input$hgrm1)) { refugees.host_areas$Refugees=NULL }
    if (!(2 %in% input$hgrm1)) { refugees.host_areas$Asylum.seekers=NULL }
    # if (!(3 %in% input$hgrm1)) { refugees.host_areas$Internally.displaced=NULL }
    if (!(4 %in% input$hgrm1)) { refugees.host_areas$Total.Population=NULL }

    # rows selection
    refugees.host_areas= refugees.host_areas[input$area,]

    # graph preparation
    host_areas.chart <- Highcharts$new()
    host_areas.chart$chart(type = "column")
    host_areas.chart$title(text = "Distribution of Refugees by Geographic Area (in 2014)")
    host_areas.chart$xAxis(categories = rownames(refugees.host_areas))
    host_areas.chart$yAxis(title = list(text = "Number of Refugees"))
    host_areas.chart$data(refugees.host_areas)
    host_areas.chart$legend(symbolWidth = 80)
    return(host_areas.chart)
 } )
})
