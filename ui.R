require(rCharts)
library(shiny)
library(shinythemes)

source("geography.R")

issue_description= function (){
  fluidRow(
    fluidRow(
      column(width = 6, offset = 1,
             p("The war in Syria is  producing an immense humanitaria  catastrophy. Millions of people are
                 displaced from their homes."),
             p("Images  coming from the EU borders give the  impression  of  a huge  amount of people moving
                 desperatly towrds  Europe.  There is the impression that our noral life will be overrun by the wave
                 of refugees,"),
             br() ),
      column(width=2,# offset = 1,
             img(src = "Wave.jpg",height = 200)) ),
    br(),
    fluidRow(
      column(width = 6,offset = 1,
             p("Some think that it is a moral  imperative  to  host  the Syrian  refugees.  But many still
                 wonder: Why  are they  coming  here?  Can somebody else host them? "),
             p("... and some still think that we need to close ourselves and protect us against this wave
                 of people comming.  We need a fortress Europe"),
             h3("In this  simple project..."),
             p("...I want  to look  at  data  to understand the situation a bit better"),
             p("I will look at questions such as..."),
             tags$ul(
               tags$li( p("Where are the Syrian refugess really?") ),
               tags$li( p("How many  of them  come to  Europe?") ),
               tags$li( p("How many  of them do  go to  other Arab countries?") )
             ),
             br(),
             p("I have no pretence to give any political answer to the issue, nor to prove a point,  but I hope
                 to build a web app that allows to look at the data and understand it."),
             h2("Data"),
             p("Although the analysis presented here is quite simplistic, the data was downloaded
                 from unhcr.org which is the web site of UNHCR: the UN Refugees Agency"),
             br(),
             br() ),
      column(3,
             img(src = "Police.jpg",height = 450))
    ) )

}

analysis_description= function () {

  refugees_histogram= function() {
    fluidRow(
      fluidRow(
        column(width=3,
               wellPanel(
                 checkboxGroupInput("hgrm1",
                                    label = h3("Data to display"),
                                    choices = list("Refugees" = 1,
                                                   "Asylum Seekers" = 2,
                                                   # "Internally displaced" = 3,
                                                   "Total Population"= 4),
                                    selected = c(1,2,4) ),  # c(1,2,3,4) ),

                 checkboxGroupInput("area",
                                    label = h3("Region to display"),
                                    choices = list("Syria"= Syria,
                                                   "Syria Neighbors"= "Syria Neighbors",
                                                   "Rest of Middle East"= "Rest of Middle East",
                                                   "North Africa" = "North Africa",
                                                   "Europe" = "Europe",
                                                   "Rest of the World"= "Rest of the World"),
                                    selected = c(
                                      Syria, "Syria Neighbors", "Rest of Middle East",
                                      "North Africa", "Europe", "Rest of the World") ) ) ),
        column(6, mainPanel(
          showOutput("RefugeesBarChart", "Highcharts")
          ) ) ),
      fluidRow(
        column(width=4,
               h4("How to use"),
               p("Chcke and uncheck the bodxes
                 to visualize different aspects of the data") ),
        column(width=4,
               h4("How to read the chart"),
               p("The data distinguishes the refugees from the asylum seekers.
                 Refugees seek temporary refuge,  asylum seekers look for a (somewhat) permanent solution.
                 Note that the data does not say why in some areas refugees do not seek asylum:
                 For example: if Syrians can live in arabic
                 without asking for asylum then the corresponding values are low") ) ) )
  }

  column(width=10, #,offset = 1,
         refugees_histogram() )
}

geography_description= function () {
}

sources_description= function () {
}

about_description= function() {
  fluidRow(
    p("The requirements for the project are the following:"),
    tags$ol(
      tags$li(
        tags$em("Some form of input (widget: textbox, radio button, checkbox, ..."),
        p("Used:"),
        tags$ol(tags$li("Tabbing") ) ),
      tags$li("Some operation on the ui input in sever.R"),
      tags$li("Some reactive output displayed as a result of server calculations"),
      tags$li(
        tags$em("You must also include enough documentation so that a novice user could use your application."),
        tags$em("The documentation should be at the Shiny website itself. Do not post to an external link") )
    ) )
}


shinyUI(fluidPage(
  theme = "bootstrap.css",#shinytheme("readable"),
  fluidRow(
    img(src= "Migrants2.png",
        hight= 50)),

  titlePanel(title= "Where are the Syrian refugees going?"),
  tabsetPanel(
    tabPanel(tags$strong("Issue"),
             issue_description() ),
    tabPanel("Analysis",
             analysis_description() ),
    tabPanel("Geography",
             geography_description() ),
    tabPanel("Sources",
             sources_description() ),
    tabPanel("About Project",
             about_description() ) ) ) )
