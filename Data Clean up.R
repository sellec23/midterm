library(stringr)
library(plyr)
library(dplyr)
library(lubridate)
library(tidyverse)

# Macrozooplankton data ----
#read in  data

z <- Zoops[,which(unlist(lapply(Zoops, function(x)!all(is.na(x)))))] #using the "lapply" function from the "dplyr" package, remove fields which contain all "NA" values

#create new fields with decimal degree latitude and longitude values
z = unite(z, "lat", c("Lat_Deg", "Lat_Min"), sep ="°")
lat = str_split_fixed(string = z$lat, pattern = "°", n = 2) #split degrees and miutes
lat = (as.numeric(lat[,2])/60) + as.numeric(lat[,1])
z$Lat_DecDeg = lat


z = unite(z, "lon", c("Lon_Deg", "Lon_Min"), sep ="°")
lon = str_split_fixed(string = z$lon, pattern = "°", n = 2) #split degrees and miutes
lon = (as.numeric(lon[,2])/60) + as.numeric(lon[,1]) * -1 
z$Lon_DecDeg = lon

# create a date-time field

z$dateTime <- str_c(z$Tow_Date," ",z$Tow_Time,":00")
z$dateTime <- as.POSIXct(strptime(z$dateTime, format = "%Y-%m-%d %H:%M:%S", tz = "America/Los_Angeles")) #Hint: look up input time formats for the 'strptime' function
z$tow_date <- NULL; z$tow_time <- NULL

#export data as tab delimited file

write.table(z, file = "Zoops.txt", row.names = F)

#Egg data Set-----

e = read.csv(file= "erdCalCOFIcufes_bb4a_5c83_ad3a.csv", header = T )

#turn these character fields into date-time field
e$stop_time_UTC <- as.POSIXct(strptime(e$stop_time_UTC, format = "%Y-%m-%d %H:%M:%S", tz = "America/Los_Angeles"))
e$time_UTC <- gsub(x = e$time_UTC, pattern = "T", replacement = " ")
e$time_UTC <- gsub(x = e$time_UTC, pattern = "Z", replacement = " ")
e$time_UTC <- as.POSIXct(strptime(e$time_UTC, format = "%Y-%m-%d %H:%M:%S", tz = "America/Los_Angeles"))


#export data

write.table(e, file = "Eggs.txt", row.names = F)
