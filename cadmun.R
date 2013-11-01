#rm(list=ls())
library(foreign)
latlong<-read.dbf("/home/lasagna/hackathonCamara/CADMUN.DBF")
codUf <- read.csv("~/codUf", sep=";",header=FALSE)
codUf<-codUf[,1:2]
names(codUf)<-c("cod.uf","uf")
latlong<-latlong[,c("UFCOD","MUNNOMEX","MUNCODDV","LATITUDE","LONGITUDE","CAPITAL")]
names(latlong)<-c("cod.uf","munic","cod.munic","latitude","longitude","capital")
latlong$cod.uf<-as.numeric(as.character(latlong$cod.uf))
latlong<-merge(latlong,codUf,by="cod.uf",all.x=TRUE,all.y=FALSE)
latlong$cod.munic<-as.numeric(as.character(latlong$cod.munic))
latlong<-latlong[latlong$lat!=0,]
latlong<-latlong[,c(3:5)]
write.table(latlong,"latlong.txt",sep=";",row.names=FALSE,quote=FALSE,fileEncoding="utf-8")
head(latlong)
unique(sort(latlong$uf))