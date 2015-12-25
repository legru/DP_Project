# This file contains the geographic nammes and abstractions that are needed 
# to identify important geographic areas

### geographic names constants that appear in the code
Syria= "Syrian Arab Rep."

Germany= "Germany"

Syria_Neighbors_Name= "Syria Neighbors"
Rest_Middle_East_Name= "Rest of Middle East"
North_Africa_Name=  "North Africa"
Europe_Name= "Europe"
EU_Name= "EU"
Rest_World_Name= "Rest of the World"

#### Geographic Area definitions

SyriaNeighbors=c("Turkey", "Iraq", "Jordan", "Israel", "Lebanon")

ArabicPeninusula= c("Kuwait",  "United Arab Emirates", 
                    "Yemen", "Saudi Arabia", "Bahrain")

MiddleEast= c(ArabicPeninusula, "Afghanistan", "Egypt", "Iraq", "Iran (Islamic Rep. of)", 
              "Israel", "Jordan", "Lebanon", "Syrian Arab Rep.", "Turkey")

RestMiddleEast= setdiff(MiddleEast,c(Syria, SyriaNeighbors))
#   c(ArabicPeninusula, "Afghanistan", "Egypt", "Iraq", "Iran (Islamic Rep. of)", 
#                   "Israel", "Jordan", "Lebanon", "Turkey")

EU= c("Austria", "Belgium", "Bulgaria", "Croatia", "Cyprus", "Czech Rep.", 
      "Denmark", "Estonia", "Finland", "France", Germany, "Greece", "Hungary", 
      "Ireland", "Italy", "Latvia", "Lithuania", "Luxembourg", "Malta", 
      "Netherlands", "Poland", "Portugal", "Romania", "Slovakia", "Slovenia", 
      "Spain", "Sweden", "United Kingdom")

Europe= c(EU, "Albania", "Belarus", "Bosnia and Herzegovina", "Iceland", 
          "Liechtenstein", "Monaco", "Montenegro", "Norway", "Rep. of Moldova", 
          "Russian Federation", "Serbia and Kosovo (S/RES/1244 (1999))", 
          "Switzerland", "The former Yugoslav Republic of Macedonia", "Ukraine")

NorthAfrica= c("Algeria", "Libya", "Tunisia", "Morocco")
