# assuming we have nothing loaded
# read in data from data folder - put into object called "data"
data <- read.csv("data/cleanedData.csv")

# load libraries 
library(leaflet)
library(mapview)
library(webshot2) # needed to save map!

# make map
map <- leaflet() %>%
  addProviderTiles("Esri.WorldTopoMap") %>%
  # add circles & call in data
  addCircleMarkers(data = data,
                   lat = ~decimalLatitude,
                   lng = ~decimalLongitude,
                   radius = 3,
                   color = "brown",
                   fillOpacity = 0.8) %>%
  addLegend(position = "topright",
            title = "Species Occurences from GBIF",
            labels = "Habronattus americanus",
            colors = "brown")

# save the map
mapshot2(map, file = "output/leafletTest.png")

  