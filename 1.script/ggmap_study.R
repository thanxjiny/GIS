### idea
# 1. 병의원 내원 환자 분포도 : 점 선 연결결
# 2. 고의사고 혐의자 주요사고 분포도 : Marker Clusters




#■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
# Topic : GIS
#         
# Date : 2020. 10.05
# Author : DJ KIM
# URL : https://kuduz.tistory.com/1042
#■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■

#■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
# Load packages ----
#■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■

#install.packages("ggmap")

rm(list = ls())
gc(reset = T)
getwd()
setwd("C:/DJ/R/02.project/GIS")

#install.packages("vctrs")

pkg = c('dplyr','ggplot2','ggmap', 'tidyverse','leaflet','raster', 'rgdal', 'rmapshaper')

sapply(pkg,require,character.only = T)

#install.packages('tidyverse')
#library('tidyverse')
#library('leaflet')
#install.packages('raster')
#install.packages('rgdal')
#install.packages('rmapshaper')
#install.packages("rgdal")

# error 해결  ##Google now requires an API key.

#install.packages('devtools')
#library('devtools')
#install_github('dkahle/ggmap')
#library('ggmap')

#AIzaSyDxUJrNLqzesrLkcT8H4BvEoX2nQP9l-xs

register_google('AIzaSyBFflbVkqvEtd_tqlFfBtSR0x36PZlsMgw')

#■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
# R로 점 찍고, 선 긋고, 색칠하기 -----
# URL : https://kuduz.tistory.com/1042
#■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■

ggmap(get_map(location='south korea', zoom=7))

myLocation <- c(lon=128.25, lat=35.95)

### 위도 (latitude), 경도 (longtitude)

ggmap(get_map(location=myLocation, zoom=7))

m = get_googlemap('Seoul', zoom = 17, maptype = 'roadmap')

ggmap(m)

#'terrain' 'roadmap' 'satellite' 'hybrid'

map <- get_map(location='South Korea', zoom=7, maptype='roadmap', color='bw')

ggmap(map)

### 점 찍기

wifi <- read.csv("./0.data/wifi.csv", header=T, as.is=T)

# 점 찍기 geom_point
ggmap(map) + geom_point(data=wifi, aes(x=lon, y=lat, color=company))

# 밀도 stat_density_2d
ggmap(map) + stat_density_2d(data=wifi, aes(x=lon, y=lat))

ggmap(map) + stat_density_2d(data=wifi, aes(x=lon, y=lat, fill=..level.., alpha=..level..),
                             geom='polygon', size=2, bins=30) #alpha :투명도 

p = ggmap(map) + stat_density_2d(data=wifi, aes(x=lon, y=lat, fill=..level.., alpha=..level..),
                                  geom='polygon', size=7, bins=28)

p + scale_fill_gradient(low='yellow', high='red')

p + scale_fill_gradient(low='yellow', high='red', guide=F) + 
  scale_alpha(range=c(0.02, 0.8), guide=F)

airport <- read.csv("./0.data/airport.csv", header=T, as.is=T)
route <- read.csv("./0.data/route.csv", header=T, as.is=T)

ggmap(map) + geom_point(data=airport, aes(x=lon, y=lat))

geocode(c('incheon airport', 'gimpo airport'))

p <- ggmap(map) + geom_point(data=airport, aes(x=lon, y=lat))
p + geom_line(data=route, aes(x=lon, y=lat, group=id))

head(route[order(route$id),])


#■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
# <leaflet>R로 인터렉티브 지도 그리기  ------
# URL : https://kuduz.tistory.com/1196
#■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■

leaflet() %>%
  setView(lng=126.9784, lat=37.566, zoom=11) %>%
  addTiles()

# data load
sb <- read.csv('./0.data/starbucks.csv') %>% as_tibble

#address                                           sido  sigungu code    lat  long SIG_CD
#<chr>                                             <chr> <chr>   <chr> <dbl> <dbl>  <int>
#  1 "강원도 강릉시 경강로 2096 (임당동)033-645-7835 " 강원  강릉    강릉   37.8  129.  42150

# 점 찍기  
#경도(long) 위도(lat)

leaflet(sb) %>%
  setView(lng=126.9784, lat=37.566, zoom=11) %>%
  addProviderTiles('CartoDB.Positron') %>% #### 지도 스타일 
  addCircles(lng=~long, lat=~lat, color='#006633') ### 점 찍기

# 점 색 달리 찍기 
pal <- colorFactor("viridis", sb$sigungu)

leaflet(sb) %>%
  setView(lng=126.9784, lat=37.566, zoom=11) %>%
  addProviderTiles('CartoDB.Positron') %>%
  addCircles(lng=~long, lat=~lat, color=~pal(sigungu))

# 마커로 표기
leaflet(sb) %>%
  setView(lng=127.7669, lat=35.90776, zoom=11) %>%
  addProviderTiles('CartoDB.Positron') %>%
  addMarkers(lng=~long, lat=~lat, label=~address)


# 선 긋기
sb %>%
  filter(lat==min(lat) | lat==max(lat)) %>%
  mutate(group=1) %>%
  leaflet() %>%
  setView(lng=127.7669,lat=35.90776, zoom=6) %>%
  addProviderTiles('CartoDB.Positron') %>%
  addCircles(lng=~long, lat=~lat) %>%
  addPolylines(lng=~long, lat=~lat, group=~group, weight=.5)

#■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
# <leaflet> ----
## https://rstudio.github.io/leaflet/map_widget.html
#■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■

# <ch0> basic

m <- leaflet() %>%
  addTiles() %>%  # Add default OpenStreetMap map tiles
  addMarkers(lng=174.768, lat=-36.852, popup="The birthplace of R")
m  # Print the map

# <ch1> the map widget ------
# Set value for the minZoom and maxZoom settings.
leaflet(options = leafletOptions(minZoom = 0, maxZoom = 18))

df = data.frame(Lat = 1:10, Long = rnorm(10))
leaflet(df) %>% addCircles()

leaflet(df) %>% addCircles(lng = ~Long, lat = ~Lat)

leaflet() %>% addCircles(data = df)
leaflet() %>% addCircles(data = df, lat = ~ Lat, lng = ~ Long)

library(sp)
Sr1 = Polygon(cbind(c(2, 4, 4, 1, 2), c(2, 3, 5, 4, 2)))
Sr2 = Polygon(cbind(c(5, 4, 2, 5), c(2, 3, 2, 2)))
Sr3 = Polygon(cbind(c(4, 4, 5, 10, 4), c(5, 3, 2, 5, 5)))
Sr4 = Polygon(cbind(c(5, 6, 6, 5, 5), c(4, 4, 3, 3, 4)), hole = TRUE)
Srs1 = Polygons(list(Sr1), "s1")
Srs2 = Polygons(list(Sr2), "s2")
Srs3 = Polygons(list(Sr4, Sr3), "s3/4")
SpP = SpatialPolygons(list(Srs1, Srs2, Srs3), 1:3)
leaflet(height = "300px") %>% addPolygons(data = SpP)

library(maps)
mapStates = map("state", fill = TRUE, plot = FALSE)
leaflet(data = mapStates) %>% addTiles() %>%
  addPolygons(fillColor = topo.colors(10, alpha = NULL), stroke = FALSE)

m = leaflet() %>% addTiles()
df = data.frame(
  lat = rnorm(100),
  lng = rnorm(100),
  size = runif(100, 5, 20),
  color = sample(colors(), 100)
)
m = leaflet(df) %>% addTiles()
m %>% addCircleMarkers(radius = ~size, color = ~color, fill = FALSE)
m %>% addCircleMarkers(radius = runif(100, 4, 10), color = c('red'))

# <ch2> base maps -------

m <- leaflet() %>% setView(lng = -71.0589, lat = 42.3601, zoom = 12)
m %>% addTiles()

## Third-Party Tiles (addProviderTiles)

m %>% addProviderTiles(providers$Stamen.Toner)
m %>% addProviderTiles(providers$CartoDB.Positron)

m %>% addProviderTiles('CartoDB.Positron')

m %>% addProviderTiles(providers$Esri.NatGeoWorldMap)

## WMS Tiles
leaflet() %>% addTiles() %>% setView(-93.65, 42.0285, zoom = 4) %>%
  addWMSTiles(
    "http://mesonet.agron.iastate.edu/cgi-bin/wms/nexrad/n0r.cgi",
    layers = "nexrad-n0r-900913",
    options = WMSTileOptions(format = "image/png", transparent = TRUE),
    attribution = "Weather data © 2012 IEM Nexrad"
  )

## Combining Tile Layers
m %>% addProviderTiles(providers$MtbMap) %>%
  addProviderTiles(providers$Stamen.TonerLines,
                   options = providerTileOptions(opacity = 0.35)) %>%
  addProviderTiles(providers$Stamen.TonerLabels)

# <ch3> markers -------

data(quakes)

## Icon Markers(Show first 20 rows from the `quakes` dataset)
leaflet(data = quakes[1:20,]) %>% addTiles() %>%
  addMarkers(~long, ~lat, popup = ~as.character(mag), label = ~as.character(mag))

## Customizing Marker Icons

greenLeafIcon <- makeIcon(
  iconUrl = "http://leafletjs.com/examples/custom-icons/leaf-green.png",
  iconWidth = 38, iconHeight = 95,
  iconAnchorX = 22, iconAnchorY = 94,
  shadowUrl = "http://leafletjs.com/examples/custom-icons/leaf-shadow.png",
  shadowWidth = 50, shadowHeight = 64,
  shadowAnchorX = 4, shadowAnchorY = 62
)

leaflet(data = quakes[1:4,]) %>% addTiles() %>%
  addMarkers(~long, ~lat, icon = greenLeafIcon)

quakes1 <- quakes[1:10,]

leafIcons <- icons(
  iconUrl = ifelse(quakes1$mag < 4.6,
                   "http://leafletjs.com/examples/custom-icons/leaf-green.png",
                   "http://leafletjs.com/examples/custom-icons/leaf-red.png"
  ),
  iconWidth = 38, iconHeight = 95,
  iconAnchorX = 22, iconAnchorY = 94,
  shadowUrl = "http://leafletjs.com/examples/custom-icons/leaf-shadow.png",
  shadowWidth = 50, shadowHeight = 64,
  shadowAnchorX = 4, shadowAnchorY = 62
)

leaflet(data = quakes1) %>% addTiles() %>%
  addMarkers(~long, ~lat, icon = leafIcons)

##  multiple parameters 
# Make a list of icons. We'll index into it based on name.
oceanIcons <- iconList(
  ship = makeIcon("ferry-18.png", "ferry-18@2x.png", 18, 18),
  pirate = makeIcon("danger-24.png", "danger-24@2x.png", 24, 24)
)

# Some fake data
df <- sp::SpatialPointsDataFrame(
  cbind(
    (runif(20) - .5) * 10 - 90.620130,  # lng
    (runif(20) - .5) * 3.8 + 25.638077  # lat
  ),
  data.frame(type = factor(
    ifelse(runif(20) > 0.75, "pirate", "ship"),
    c("ship", "pirate")
  ))
)

leaflet(df) %>% addTiles() %>%
  # Select from oceanIcons based on df$type
  addMarkers(icon = ~oceanIcons[type])


## Awesome Icons
# first 20 quakes
df.20 <- quakes[1:20,]

getColor <- function(quakes) {
  sapply(quakes$mag, function(mag) {
    if(mag <= 4) {
      "green"
    } else if(mag <= 5) {
      "orange"
    } else {
      "red"
    } })
}

icons <- awesomeIcons(
  icon = 'ios-close',
  iconColor = 'black',
  library = 'ion',
  markerColor = getColor(df.20)
)

leaflet(df.20) %>% addTiles() %>%
  addAwesomeMarkers(~long, ~lat, icon=icons, label=~as.character(mag))

# Marker Clusters

leaflet(quakes) %>% addTiles() %>% addMarkers(
  clusterOptions = markerClusterOptions()
)

# Circle Markers
leaflet(df) %>% addTiles() %>% addCircleMarkers()


# Create a palette that maps factor levels to colors
pal <- colorFactor(c("navy", "red"), domain = c("ship", "pirate"))

leaflet(df) %>% addTiles() %>%
  addCircleMarkers(
    radius = ~ifelse(type == "ship", 6, 10),
    color = ~pal(type),
    stroke = FALSE, fillOpacity = 0.5
  )

# <ch4> Popups -------

content <- paste(sep = "<br/>",
                 "<b><a href='http://www.samurainoodle.com'>Samurai Noodle</a></b>",
                 "606 5th Ave. S",
                 "Seattle, WA 98138"
)

leaflet() %>% addTiles() %>%
  addPopups(-122.327298, 47.597131, content,
            options = popupOptions(closeButton = FALSE)
  )

# <ch5> Labels ----

library(htmltools)

df <- read.csv(textConnection(
  "Name,Lat,Long
Samurai Noodle,47.597131,-122.327298
Kukai Ramen,47.6154,-122.327157
Tsukushinbo,47.59987,-122.326726"))

leaflet(df) %>% addTiles() %>%
  addMarkers(~Long, ~Lat, label = ~htmlEscape(Name))


# Change Text Size and text Only and also a custom CSS
leaflet() %>% addTiles() %>% setView(-118.456554, 34.09, 13) %>%
  addMarkers(
    lng = -118.456554, lat = 34.105,
    label = "Default Label",
    labelOptions = labelOptions(noHide = T)) %>%
  addMarkers(
    lng = -118.456554, lat = 34.095,
    label = "Label w/o surrounding box",
    labelOptions = labelOptions(noHide = T, textOnly = TRUE)) %>%
  addMarkers(
    lng = -118.456554, lat = 34.085,
    label = "label w/ textsize 15px",
    labelOptions = labelOptions(noHide = T, textsize = "15px")) %>%
  addMarkers(
    lng = -118.456554, lat = 34.075,
    label = "Label w/ custom CSS style",
    labelOptions = labelOptions(noHide = T, direction = "bottom",
                                style = list(
                                  "color" = "red",
                                  "font-family" = "serif",
                                  "font-style" = "italic",
                                  "box-shadow" = "3px 3px rgba(0,0,0,0.25)",
                                  "font-size" = "12px",
                                  "border-color" = "rgba(0,0,0,0.5)"
                                )))

# Labels without markers

# <ch6> Lines and Shapes -------

#library(rgdal)

# From https://www.census.gov/geo/maps-data/data/cbf/cbf_state.html
states <- readOGR("shp/cb_2013_us_state_20m.shp",
                  layer = "cb_2013_us_state_20m", GDAL1_integer64_policy = TRUE)


neStates <- subset(states, states$STUSPS %in% c(
  "CT","ME","MA","NH","RI","VT","NY","NJ","PA"
))

leaflet(neStates) %>%
  addPolygons(color = "#444444", weight = 1, smoothFactor = 0.5,
              opacity = 1.0, fillOpacity = 0.5,
              fillColor = ~colorQuantile("YlOrRd", ALAND)(ALAND),
              highlightOptions = highlightOptions(color = "white", weight = 2,
                                                  bringToFront = TRUE))
# Highlighting shapes
library(albersusa)

fullsize <- usa_sf()
object.size(fullsize)

# Circles

cities <- read.csv(textConnection("
City,Lat,Long,Pop
Boston,42.3601,-71.0589,645966
Hartford,41.7627,-72.6743,125017
New York City,40.7127,-74.0059,8406000
Philadelphia,39.9500,-75.1667,1553000
Pittsburgh,40.4397,-79.9764,305841
Providence,41.8236,-71.4222,177994
"))

leaflet(cities) %>% addTiles() %>%
  addCircles(lng = ~Long, lat = ~Lat, weight = 1,
             radius = ~sqrt(Pop) * 30, popup = ~City
  )

## sample (seoul)

lon 126.978
lat 37.566


cities <- read.csv(textConnection("
City,Lat,Long,Pop
Seul,37.566,126.978,645
"))

# Rectangles

leaflet() %>% addTiles() %>%
  addRectangles(
    lng1=-118.456554, lat1=34.078039,
    lng2=-118.436383, lat2=34.062717,
    fillColor = "transparent"
  )

 ##lng1, lng2, lat1, and lat2 vector arguments that define the corners of the rectangles. 





