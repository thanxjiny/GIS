
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

pkg = c('dplyr','ggplot2','ggmap')

sapply(pkg,require,character.only = T)


# error 해결  ##Google now requires an API key.

#install.packages('devtools')
#library('devtools')
#install_github('dkahle/ggmap')
#library('ggmap')

#AIzaSyDxUJrNLqzesrLkcT8H4BvEoX2nQP9l-xs

register_google('AIzaSyCg2ceZXU60KOTidn_9Bs6lWPomohuEJLk')

#■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
# introduction ----
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
