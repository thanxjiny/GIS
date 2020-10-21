
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
# R로 인터렉티브 지도 그리기  ------
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
  setView(lng=127.7669, lat=35.90776, zoom=6) %>%
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


# 색칠하기
korea <- shapefile('./0.data/SIG_201703/TL_SCCO_SIG.shp')

korea2 <- ms_simplify(korea)





