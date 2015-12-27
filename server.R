
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#
#require(rCharts)
library(shiny)
library(ggplot2)


## import modules ----------------------------------------------

# additional geographic names
source("geography.R")

# data processing functions
source("data_processing.R")

## Definition of Plotting functions -----------------------------

refugees_chart= function(data, column, showAsPie=T) {

  pieChart= function(data, column) {
    pie =
      if (column=="Refugees") {
        ggplot(data = data, #refugees.host_areas,
               aes(x = factor(1),
                   y = Refugees.pc,
                   fill= GeoArea ) ) }
    else {
      ggplot(data = data, #refugees.host_areas,
             aes(x = factor(1),
                 y = AsylSeek.pc,
                 fill= GeoArea ) ) }
    pie = pie + geom_bar(stat="identity")
    pie = pie + coord_polar(theta="y")
    pie = pie + theme(legend.text=element_text(size=15))
    pie = pie + xlab("") + ylab("")
    pie
  }

  barChart= function(data, column) {
    # set aestetic
    chart =
      if (column=="Refugees") {
        ggplot(data = data, #refugees.host_areas,
               aes(x = GeoArea, #as.factor(GeoArea), #factor(1),
                   y = Refugees,
                   fill= GeoArea ) ) }
    else {
      ggplot(data = data, #refugees.host_areas,
             aes(x = GeoArea, #as.factor(GeoArea), #factor(1),
                 y = Asylum.seekers,
                 fill= GeoArea ) ) }
    # add layers
    chart = chart + geom_bar(stat="identity")
    chart = chart + theme(axis.text.x=element_text(angle=-90,
                                                   size = 12,
                                                   colour = "black"),
                          legend.text=element_text(size=16),
                          legend.title=NULL)
    chart = chart + xlab("") + ylab( if (column=="Refugees") "Number of Refugees"
                                     else "Number of Asylum Seekers" )
    chart
  }

  chart=
    if (showAsPie) {pieChart(data,column)}
  else {barChart(data,column)}

  chart
}

shinyServer(function(input, output) {

  # generate the graph
  output$RefugeesChart <- renderPlot( {
    # within the reactive context of the refugees chart

    # select chart type
    showAsPie=T
    # set the type of plot
    if (input$bar.pie==1) {
      # Pie chart selected
      showAsPie=T
    } else {
      # bar chart selected
      showAsPie=F
    }

    # select data type
    column="Refugees"
    # set the type of plot
    if (input$refugees.asylum==1) {
      # Refugees selected
      column="Refugees"
    } else {
      # Asylum.seekers selected
      column="Asylum.seekers"
    }

    # rows selection
    refugees.host_areas= refugees.host_areas[input$area,]

    # graph preparation
    refugees.chart= refugees_chart(refugees.host_areas[input$area,], column, showAsPie)
    return(refugees.chart)
  } )
})
