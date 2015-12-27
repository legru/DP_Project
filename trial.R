library(ggplot2)

source("data_processing.R")

# short.damage.percent <-
#   data.frame(EVTYPE=short.damage.sum$EVTYPE,
#              percent= short.damage.sum$sum*100/damages.total)
# #compile the plot
# pie = ggplot(data=short.damage.percent,
#              aes(x=factor(1),
#                  y=percent,
#                  fill = EVTYPE))
# # draw a par chart
# pie=pie + geom_bar(stat="identity")
# # twist it
# pie = pie + coord_polar(theta="y")
# # fix labels
# pie = pie + ylab("Damages produced (in percentage)") + xlab(" ")

# total_refugees= sum(refugees.host_areas$Refugees)
#
# refugees.host_areas$Refugees.pc= refugees.host_areas$Refugees*100/sum(refugees.host_areas$Refugees)
# refugees.host_areas$AsylSeek.pc= refugees.host_areas$Asylum.seekers*100/sum(refugees.host_areas$Asylum.seekers)
# refugees.host_areas$TotPop.pc= refugees.host_areas$Total.Population*100/sum(refugees.host_areas$Total.Population)
#
# refugees.host_areas$GeoArea= factor(refugees.host_areas$GeoArea,
#                                     levels = c("Syrian Arab Rep.", "Syria Neighbors", "Rest of Middle East",
#                                                "North Africa", "Europe", "Rest of the World"))


refugees_chart= function(column, showAsPie=T) {

  pieChart= function(column) {
    pie =
      if (column=="Refugees") {
        ggplot(data = refugees.host_areas,
               aes(x = factor(1),
                   y = Refugees.pc,
                   fill= GeoArea ) ) }
    else {
      ggplot(data = refugees.host_areas,
             aes(x = factor(1),
                 y = AsylSeek.pc,
                 fill= GeoArea ) ) }
    pie = pie + geom_bar(stat="identity")
    pie = pie + coord_polar(theta="y")
    pie
  }

  barChart= function(column) {
    # set aestetic
    chart =
      if (column=="Refugees") {
        ggplot(data = refugees.host_areas,
               aes(x = GeoArea, #as.factor(GeoArea), #factor(1),
                   y = Refugees,
                   fill= GeoArea ) ) }
    else {
      ggplot(data = refugees.host_areas,
             aes(x = GeoArea, #as.factor(GeoArea), #factor(1),
                 y = Asylum.seekers,
                 fill= GeoArea ) ) }
    # add layers
    chart = chart + geom_bar(stat="identity")
    chart = chart + theme(axis.text.x=element_text(angle=-90))
    chart = chart + xlab("")
    chart = chart + ylab( if (column=="Refugees") "Number of Refugees"
                          else "Number of Asylum Seekers" )
    chart
  }

  chart=
    if (showAsPie) {pieChart(column)}
  else {barChart(column)}

  chart
}

refugees_chart(column = "Refugees", showAsPie=F)
refugees_chart(column = "Asylum.seekers", showAsPie=F)
refugees_chart(column = "Refugees")
refugees_chart(column = "Asylum.seekers")


data= "Asylum.seekers"
data= "Refugees"

showPie=T
pie = ggplot(data = refugees.host_areas,
             aes(x = factor(1),
                 y = Refugees.pc, #AsylSeek.pc,
                 # y = refugees.host_areas[,"Asylum.seekers"]*100/sum(refugees.host_areas[,"Asylum.seekers"]),
                 fill= GeoArea # refugees.host_areas$GeoArea
                 #fill= GeoArea
             ))
pie = pie + geom_bar(stat="identity")
if (showPie) { pie = pie + coord_polar(theta="y") }
pie
