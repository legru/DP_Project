# library(rMaps)
# crosslet(
#   x = "country", 
#   y = c("web_index", "universal_access", "impact_empowerment", "freedom_openness"),
#   data = web_index
# )
# 
# ichoropleth(Crime ~ State, data = subset(violent_crime, Year == 2010))
# ichoropleth(Crime ~ State, data = violent_crime, animate = "Year")
# ichoropleth(Crime ~ State, data = violent_crime, animate = "Year", play = TRUE)
# 
# #co.co= read.csv("C:/Users/paolucci/OneDrive/Documents/GitHub/Coursera/DataScience/DataProducts/Project/Data/country_codes.csv")
# co.co= read.csv("C:/Users/Massimo/OneDrive/Documents/GitHub/Coursera/DataScience/DataProducts/Project/Data/country_codes.csv")
# 
# ichoropleth(NUM~UN,data = co.co,map = 'world',labels = F,pal = rev(brewer.pal(5,"Spectral")))
# ichoropleth(NUM~UN,data = co.co,map = 'world',labels = F,pal = brewer.pal(5,"Spectral"))
# ichoropleth(NUM~UN,data = co.co,map = 'world',labels = F,pal = "YlOrRd")
# ichoropleth(NUM~UN,data = co.co,map = 'world',labels = F,pal = rev("Spectral"))
# ichoropleth(Crime ~ State, data = violent_crime, animate = "Year")
# 
