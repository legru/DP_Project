require(rCharts)
library(shiny)
library(shinythemes)

source("geography.R")

issue_description= function () {
  fluidRow(
    fluidRow(
      column(width = 6, offset = 1,
             p("The war in Syria is  producing an immense humanitaria  catastrophy. Millions of people are
                 displaced from their homes."),
             p("Images  coming from the EU borders show  a huge  amount of people moving
                 desperatly towrds  Europe.  There is the impression that our noral life will be overrun by the wave
                 of refugees,"),
             br(),
             h2("Below is presentd data provided by unhcr.org. UNHCR is the UN Refugees Agency"),
             p("By clicking on the shaded controls you can visualize different aspects of the data,
               and answer questions such as \"Where are the Syrian Refugees?\", \"How many are them?\", etc.
               "),
             br() ),
      column(width=2,# offset = 1,
             img(src = "Wave.jpg",height = 200) ) ) ) }

refugees_bar.pie_Chart= function() {

  display_control= function (instructions, control){
    fluidRow(
      tags$em(
        tags$small( instructions ) ),
      wellPanel( control ) ) }

  chart= function() {
    fluidRow(
      column(width=3, offset = 1,

             display_control( tags$div( p("Here you can selct how to visualize the data."),
                                        tags$ul(
                                          tags$li(p("Pie charts give a better intuition of proportions.")),
                                          tags$li(p(" Bar charts show better the corresponding amounts.")) )  ),
                              radioButtons("bar.pie",
                                           label = h3("Select Chart Type"),
                                           choices = list("Pie chart" = 1, "Bar Chart" = 2),
                                           selected = 1) ),

             display_control(tags$div( p("Looking at data in detail"),
                                       tags$ul(
                                         tags$li(p("Refugeees gives a count of peple seeking temporary refuge")),
                                         tags$li(p("Asylum seekers look for the permission to live in another country") ) ) ),
                             radioButtons("refugees.asylum",
                                          label = h3("Select Data Type"),
                                          choices = list("Refugees" = 1, "Asylum Seekers"  = 2),
                                          selected =1) ) ),

      column(width=3,
             display_control( tags$div(p("Here you can compare data from different regions"),
                                       tags$ul(
                                         tags$li("Syria provides the count of internally displaced people"),
                                         tags$li("Syria Neighbors counts refugees in Syria's bordering countries"),
                                         tags$li("Rest of Middle East counts refugees in the rest of the Middle East"),
                                         tags$li("North Africa counts refugees in North African countries"),
                                         tags$li("Europe counts refugees in Europe"),
                                         tags$li("Rest of the World counts refugees in the rest of the World combined") ) ),
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

      column(5, mainPanel(
        plotOutput("RefugeesChart",height = 600,width = 600) ) ) ) }

  chart() }

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
  column(width=11,offset=1,
    img(src= "Migrants2.png",
        hight= 1050)),

  titlePanel(title= "Where are the Syrian refugees going?"),
  tabsetPanel(
    tabPanel(tags$strong("Issue"),
             tags$div(
               issue_description(),
               br(),
               refugees_bar.pie_Chart() ) ),
    tabPanel("Sources",
             sources_description() ),
    tabPanel("About Project",
             about_description() ) ) ) )
