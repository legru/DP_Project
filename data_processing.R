library(data.table)
# To remove...
# library(dplyr)
# library(reshape2)

# Required geographic abstractions
source("geography.R")

### Load data  ---------------------------------------------------

# dir.project= "C:/Users/Massimo/OneDrive/Documents/GitHub/Coursera/DataScience/DataProducts/Project"
dir.project= "."
dir.data= "Data"

file.Yearly= "unhcr_popstats_export_asylum_seekers_all_data.csv"
file.Monthly= "unhcr_popstats_export_asylum_seekers_monthly_all_data.csv"
file.Monthly.2015="unhcr_popstats_export_asylum_seekers_monthly_2015_11_22_010602.csv"
file.poc= "unhcr_popstats_export_persons_of_concern_all_data.csv"
file.countryCodes= "country_codes.csv"

## function defined to avoid duplications and to make the code a bit more readable
read.data= function(name_file) {
  # find complete file path
  file_path= paste(dir.data,name_file,sep="/")
  # return data read with appropriate parameters
  data= fread(file_path,
              header=T,skip=3,
              na.strings=c("NA","N/A","null","*",""," "))
  data[is.na(data)]=0
  data}

# ----------------------------------------------------------------
# read all yearly statistics on asylud data
yearly.asyl_seek= read.data(file.Yearly)
# make the columns names more readable
setnames(yearly.asyl_seek,
         c("Year",
           "Host.Country",
           "Origin",
           "RSD.procedure.type...level",
           "Total.persons.pending.start.year",
           "of.which.UNHCR.assisted",
           "Applied.during.year",
           "statistics.filter.decisions_recognized",
           "statistics.filter.decisions_other",
           "Rejected",
           "Otherwise.closed",
           "Total.decisions",
           "Total.persons.pending.end.year",
           "of.which.UNHCR.assisted.1") )

# ----------------------------------------------------------------
# read all montly statistics on asylumm seeking data
monthly.asyl_seek= read.data(file.Monthly.2015)
# make the columns names more readable
setnames(monthly.asyl_seek,c("Host.Country",
                             "Origin",
                             "Year",
                             "Month",
                             "Value"))

# ----------------------------------------------------------------
# read data about "persons of concern"
poc.data= read.data(file.poc)
# make the columns names more readable
setnames(poc.data, c("Year",
                     "Host.Country",
                     "Origin",
                     "Refugees",
                     "Asylum.seekers",
                     "Returned.refugees",
                     "Internally.displaced.persons..IDPs.",
                     "Returned.IDPs",
                     "Stateless.persons",
                     "Others.of.concern",
                     "Total.Population"))
# set the key for the data
setkey(poc.data,"Origin","Host.Country","Year")

# ----------------------------------------------------------------
# mapping of country codes
countryCodes.data= fread(paste(dir.data,file.countryCodes,sep="/"),header=T)
setkey(countryCodes.data,CountryName)

# ----------------------------------------------------------------
## generate the mapping between countries names used by UNHBC and the 3 letters code
country_name.code.mapping= countryCodes.data[-(1:30),.(CountryName,UN)]

###  Relevant Data Tables #####################################################################

#---  Additional Geographic Definitions ----------------------------------

AllWorld= union(poc.data$Host.Country,poc.data$Origin)
RestWorld= setdiff(AllWorld,c(Europe, MiddleEast, NorthAfrica))


#### Using POC data -------------------------------------

# --- extract yearly data of refugees from Syria
poc.from_Syria.Yearly= poc.data[Origin==Syria]


# --- extract data on different destinations

poc.from_Syria.to_Neighbors=      poc.from_Syria.Yearly[Host.Country %in% SyriaNeighbors]

poc.from_Syria.to_RestMiddleEast= poc.from_Syria.Yearly[Host.Country %in% RestMiddleEast]

poc.from_Syria.to_NorthAfrica=    poc.from_Syria.Yearly[Host.Country %in% NorthAfrica]

poc.from_Syria.to_Europe=         poc.from_Syria.Yearly[Host.Country %in% Europe]

poc.from_Syria.to_RestWorld=      poc.from_Syria.Yearly[Host.Country %in% RestWorld]



### Data for charts ############################################################################


#### Histogram1: Distribution of Syrian refugees by Geographic Area ---------------------------

# Data for the distribution of refugees in 2014 (The last year for whicch  data  is  available)


# --- extract 2014 data

poc.from_Syria.2014= poc.from_Syria.Yearly[Year==2014]

poc.from_Syria.to_Neighbors.2014= poc.from_Syria.to_Neighbors[Year==2014]

poc.from_Syria.to_RestMiddleEast.2014= poc.from_Syria.to_RestMiddleEast[Year==2014]

poc.from_Syria.to_NorthAfrica.2014= poc.from_Syria.to_NorthAfrica[Year==2014]

poc.from_Syria.to_Europe.2014= poc.from_Syria.to_Europe[Year==2014]

poc.from_Syria.to_RestWorld.2014= poc.from_Syria.to_RestWorld[Year==2014]


#---  Data to display  --------------------------------------------------
refugees.host_areas= data.frame(
  GeoArea= c(Syria, Syria_Neighbors_Name, Rest_Middle_East_Name,
             North_Africa_Name, Europe_Name, Rest_World_Name),
  Refugees= c(poc.from_Syria.2014[,sum(Internally.displaced.persons..IDPs.)],
              poc.from_Syria.to_Neighbors.2014[,sum(Refugees)],
              poc.from_Syria.to_RestMiddleEast.2014[,sum(Refugees)],
              poc.from_Syria.to_NorthAfrica.2014[,sum(Refugees)],
              poc.from_Syria.to_Europe.2014[,sum(Refugees)],
              poc.from_Syria.to_RestWorld.2014[, sum(Refugees)]),
  Asylum.seekers= c(0, # Syrians do not need to ask for asylum in their own land
                    poc.from_Syria.to_Neighbors.2014[,sum(Asylum.seekers)],
                    poc.from_Syria.to_RestMiddleEast.2014[,sum(Asylum.seekers)],
                    poc.from_Syria.to_NorthAfrica.2014[,sum(Asylum.seekers)],
                    poc.from_Syria.to_Europe.2014[,sum(Asylum.seekers)],
                    poc.from_Syria.to_RestWorld.2014[,sum(Asylum.seekers) ] ),
  Total.Population= c(poc.from_Syria.2014[,sum(Internally.displaced.persons..IDPs.)],
                      #poc.from_Syria.2014[,sum(Total.Population)], # This results in a sum of everything
                      poc.from_Syria.to_Neighbors.2014[,sum(Total.Population)],
                      poc.from_Syria.to_RestMiddleEast.2014[,sum(Total.Population)],
                      poc.from_Syria.to_NorthAfrica.2014[,sum(Total.Population)],
                      poc.from_Syria.to_Europe.2014[,sum(Total.Population)],
                      poc.from_Syria.to_RestWorld.2014[,sum(Total.Population)] ) )

row.names(refugees.host_areas)=c(Syria, Syria_Neighbors_Name, Rest_Middle_East_Name,
                                  North_Africa_Name, Europe_Name, Rest_World_Name)





#
#
# #### map1: Distribution of Syrian refugees across the different countries ---------------------------
# # this map should contain the total number of Syriann refugees that n 2014
#
# ##--- Extract relevaant data: host country and total population there
# map1.data= data.frame(Host.Country= poc.from_Syria.2014$Host.Country,
#                       Total.Population= poc.from_Syria.2014$Total.Population)
# ##--- replace host country name with country code
# map1.data= mutate(map1.data,
#                   Host.Country= sapply(map1.data$Host.Country,
#                                       function(country){
#                                         country_name.code.mapping[as.character(country),]
#                                       }))
#
#
# ### --- Asyylum seekers time series -------------------------------------------------------
#
#
#
# month2number <- function (month) {
#   month=as.character(month)
#   if (month=="January")   {return("01")}
#   if (month=="February")  {return("02")}
#   if (month=="March")     {return("03")}
#   if (month=="April")     {return("04")}
#   if (month=="May")       {return("05")}
#   if (month=="June")      {return("06")}
#   if (month=="July")      {return("07")}
#   if (month=="August")    {return("08")}
#   if (month=="September") {return("09")}
#   if (month=="October")   {return("10")}
#   if (month=="November")  {return("11")}
#   if (month=="December")  {return("12")}
# }
#
# # reformat the date variable to work a bit better
# monthly.asyl_seek$Date=
#   apply(monthly.asyl_seek,1,
#         function(y) {
#           paste(y[3],month2number(y[4]),sep = "-")})
# # eliminate two redundant columns
# monthly.asyl_seek$Year=NULL
# monthly.asyl_seek$Month=NULL
#
# # Get the list of asylum seekers from Syria
# monthly.asyl_seek.from_Syria= filter(monthly.asyl_seek, Origin==Syria)
#
# # from Syria to European/EU contries and Germany
# monthly.asyl_seek.from_Syria.to_Europe= filter(monthly.asyl_seek.from_Syria,Host.Country %in% Europe)
# monthly.asyl_seek.from_Syria.to_EU= filter(monthly.asyl_seek.from_Syria,Host.Country %in% EU)
# monthly.asyl_seek.from_Syria.to_Germany= filter(monthly.asyl_seek.from_Syria,Host.Country ==Germany)
#
# # #############################################################
# # ## Prepare data for Senkley chart
# #
# #
# # # get the list of month
# # months= unique(sort(monthly.asyl_seek.from_Syria$Date))
# #
# # ## recast the frame to a wide format with countries as headers
# # monthly.asyl_seek.from_Syria.to_Europe_countries=
# #   dcast(data=monthly.asyl_seek.from_Syria.to_Europe,
# #          formula= Origin + Date ~ Host.Country,
# #          fill= 0,
# #          value.var = "Value")
# #
# # # use date as index of the table
# # rownames(monthly.asyl_seek.from_Syria.to_Europe_countries)=
# #   monthly.asyl_seek.from_Syria.to_Europe_countries$Date
# #
# # #### create link/node structure for the Sankley graph
# # ### the objective is to build a graph where Syria -> Europe/EU -> Countries
# #
# # ## -----------------------------------------------------
# # ## build the link and node data structure
# #
# # ## nodes list
# # nodes_sankley_syrian_asylum_requests=
# #   c(Syria,
# #     Europe_Name,
# #     EU_Name,
# #     names(monthly.asyl_seek.from_Syria.to_Europe_countries)[-c(1,2)])
# #
# # ## invese list for quick access
# # inv_nodes_sankley_syrian_asylum_requests=
# #   1:length(nodes_sankley_syrian_asylum_requests)
# # names(inv_nodes_sankley_syrian_asylum_requests)=
# #   nodes_sankley_syrian_asylum_requests
# #
# # ## build the link structure
# #
# #
# #
# # ### only for developmet,  this input should come from a slider
# # month= last(months)
# #
# #
# # links_sankley_syrian_asylum_requests=
# #   matrix(ncol = 3,  byrow = T,
# #          data=c(
# #            # link Syria -> Europe
# #            c(inv_nodes_sankley_syrian_asylum_requests[Syria],
# #              inv_nodes_sankley_syrian_asylum_requests[Europe_Name],
# #              sum(filter(monthly.asyl_seek.from_Syria.to_Europe,Date==month)$Value)),
# #            # link Europe -> EU
# #            c(inv_nodes_sankley_syrian_asylum_requests[Europe_Name],
# #              inv_nodes_sankley_syrian_asylum_requests[EU_Name],
# #              sum(filter(monthly.asyl_seek.from_Syria.to_EU,Date==month)$Value)),
# #            # link Syria -> European (inclluding EU) countries
# #            sapply(Europe,
# #                   function(country) {
# #                     #  select the start of the llnk
# #                     from= Europe_Name
# #                     if (country %in% EU) {
# #                       from= EU_Name}
# #                     from= inv_nodes_sankley_syrian_asylum_requests[from]
# #                     # select the end of the link
# #                     to= inv_nodes_sankley_syrian_asylum_requests[country]
# #                     # select the weight of the  link
# #                     weight= {
# #                       n=  monthly.asyl_seek.from_Syria.to_Europe_countries[month,country]
# #                       if (is.null(n)) {NA}
# #                       else {n}
# #                     }
# #                     #  build the link
# #                     print(paste(country, from, to, weight, sep=" "))
# #                     # check whether it is a valid link
# #                     link=
# #                       if (is.na(from) | is.na(weight) | weight==0) { c(NA, NA, NA)}
# #                     else {c(from, to, weight)}
# #                     ## return the link consructed
# #                     link
# #                   })
# #          ) )
# #
# # to.keep1= !is.na(links_sankley_syrian_asylum_requests[,2])
# # to.keep2= !is.na(links_sankley_syrian_asylum_requests[,3])
# # to.keep3= !is.na(links_sankley_syrian_asylum_requests[,3]==0)
# # to.keep= to.keep1 & to.keep2  & to.keep3
# # links_sankley_syrian_asylum_requests[to.keep]
#
# #
# # # ### find all refugees that go into Europe
# # # monthly.asyl_seek.from_Syria_to_Europe= monthly.asyl_seek.from_Syria[monthly.asyl_seek.from_Syria$Host.Coutry %in% Europe,]
# # #
# # # # Add information of whether the country is in the EU or Europe
# # # # THis is a bit redundant information but saves computation during reactive plotting
# # # monthly.asyl_seek.from_Syria_to_Europe$Europe_EU= apply(monthly.asyl_seek.from_Syria_to_Europe,1,
# # #                                                         function(record) {
# # #                                                           if (record["Host.Country"] %in% EU) {"EU"}
# # #                                                           else {Europe}
# # #                                                         })
# #
# #
# # ## create link node structure
# #
# # # ### find all refugees that go into Europe in a given month
# # # asyl_seek.from_Syria_to_Europe_in_month=
# # #   monthly.asyl_seek.from_Syria_to_Europe[monthly.asyl_seek.from_Syria_to_Europe$Date==month,]
# #
# # #################################################################
# #
# # syrian_asylum_requests_in_Europe_in_month= monthly.asyl_seek.from_Syria.to_Europe_countries[month,]
# #
# #
# # monthly.asyl_seek.from_Syria.to_Europe_countries$Europe=
# #   sum(filter(monthly.asyl_seek.from_Syria.to_Europe,Date==month)$Value)
# # monthly.asyl_seek.from_Syria.to_Europe_countries$EU=
# #   sum(filter(monthly.asyl_seek.from_Syria.to_EU,Date==month)$Value)
# #
# # nodes_sankley_syrian_asylum_requests= c(Syria,
# #                                         names(syrian_asylum_requests_in_Europe_in_month))
# #
# # inv_nodes_sankley_syrian_asylum_requests=1:length(nodes_sankley_syrian_asylum_requests)
# # names(inv_nodes_sankley_syrian_asylum_requests)=nodes_sankley_syrian_asylum_requests
# #
# # links_sankley_syrian_asylum_requests=
# #   matrix(ncol = 3,  byrow = T,
# #          data=c(
# #            # link Syria -> Europe
# #            c(Syria,
# #              inv_nodes_sankley_syrian_asylum_requests[Europe_Name],
# #              join.syrian_asylum_requests_in_Europe[month,Europe_Name]),
# #            # link Syria -> EU
# #            c(Syria,
# #              inv_nodes_sankley_syrian_asylum_requests[EU_Name],
# #              join.syrian_asylum_requests_in_Europe[month,EU_Name]),
# #            # link Syria -> European (inclluding EU) countries
# #            sapply(Europe,
# #                   function(country) {
# #                     from= Europe_Name
# #                     if (country %in% EU) {
# #                       from= EU_Name}
# #                     #  build the link
# #                     c(
# #                       inv_nodes_sankley_syrian_asylum_requests[from],
# #                       inv_nodes_sankley_syrian_asylum_requests[country],
# #                       monthly.asyl_seek.from_Syria.to_Europe_countries[month,country]
# #                     )
# #                   })
# #          ) )
# #
