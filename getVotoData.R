rm(list=ls())

getTse<-function(folder){
  filesList<-list.files(path = folder)
  dataOut<-data.frame()
  for (i in 1:length(filesList)){
    print(i)
    fileInUse<-file.path(folder, filesList[i])
    fileExtesion<-substr(fileInUse,(nchar(fileInUse)-2),nchar(fileInUse))
    if (fileExtesion=="txt"){
      fileLines<-length(readLines(fileInUse, n=10))
      if (fileLines>9){
        fileOut<-read.table(fileInUse, sep=";", quote="\"",fill = TRUE,fileEncoding="latin1")
        dataOut<-rbind(dataOut,fileOut)        
      }
    } 
  }
  tableout<-data.frame(dataOut)
}

voto2010b<-getTse("~/hackathonCamara/votoDeputados/votacao_candidato_munzona_2010")
voto2010<-voto2010b[voto2010b$V11==6,]
voto2010<-voto2010[voto2010$V21==1 | voto2010$V21==5,]
voto2010<-voto2010[,c(3,6,8,14,23,29)]
head

names(voto2010)<-c("ano","uf","cod.tse","deputado","partido","voto")

voto2010<-aggregate(voto2010$voto,by=list(voto2010$ano,
                                          voto2010$uf,
                                          voto2010$cod.tse,
                                          voto2010$deputado,
                                          voto2010$partido),FUN=sum)
names(voto2010)<-c("ano","uf","cod.tse","deputado","partido","voto")

municTseIbge <- read.csv("~/hackathonCamara/votoDeputados/municTseIbge.txt", sep=";")
municTseIbge<-municTseIbge[municTseIbge$ano==2010,c(2,6,5,4)]
names(municTseIbge)[2]<-"cod.munic"
head(voto2010)
head(municTseIbge)
voto2010<-merge(voto2010,municTseIbge,by="cod.tse",all.x=TRUE,all.y=FALSE)
rm(municTseIbge)

source("hackathonCamara/cadmun.R")
voto2010<-merge(voto2010,latlong,by="cod.munic",all.x=TRUE,all.y=FALSE)
head(voto2010)




voto2010$post<-paste("VOTOS NO MUNICÍPIO:",voto2010$voto)
voto2010$deputado<-paste(voto2010$deputado," (",voto2010$partido.sigla,"-",voto2010$autor.uf,")",sep="")
voto2010Camara<-voto2010[,c("latitude","longitude","deputado","post")]
voto2010$string.latlong<-paste('a:2:{s:3:"lat";d:',voto2010$latitude,';s:3:"lon";d:',voto2010$longitude,';}',sep="")
voto2010$id<-(1:nrow(voto2010Camara)+2000)
head(voto2010)
voto2010<-voto2010[1:1000,]

wpvoto2010Location<-voto2010[,c("id","string.latlong")]
names(wpvoto2010Location)<-c("post_id","meta_value")
wpvoto2010Location$meta_key<-"_mpv_location"
wpvoto2010Location<-wpvoto2010Location[,c(1,3,2)]
head(wpvoto2010Location)

wpvoto2010Map<-data.frame(voto2010$id)
names(wpvoto2010Map)<-"post_id"
wpvoto2010Map$meta_key<-"_mpv_inmap"
wpvoto2010Map$meta_value<-"61"
head(wpvoto2010Map)

wpvoto2010Location<-voto2010[,c("id","string.latlong")]
names(wpvoto2010Location)<-c("post_id","meta_value")
wpvoto2010Location$meta_key<-"_mpv_location"
wpvoto2010Location<-wpvoto2010Location[,c(1,3,2)]
head(wpvoto2010Location)

wpvoto2010Meta<-rbind(wpvoto2010Map,wpvoto2010Location)
wpvoto2010Meta<-wpvoto2010Meta[order(wpvoto2010Meta$post_id),]
wpvoto2010Meta$meta_id<-1:nrow(wpvoto2010Meta)+20000
wpvoto2010Meta$meta_id<-as.character(wpvoto2010Meta$meta_id)
wpvoto2010Meta$post_id<-as.character(wpvoto2010Meta$post_id)
wpvoto2010Meta<-wpvoto2010Meta[,c(4,1:3)]
head(wpvoto2010Meta)

wpvoto2010<-data.frame(voto2010$id)
names(wpvoto2010)<-"id"
wpvoto2010$id<-as.character(wpvoto2010$id)
wpvoto2010$post_author<-"1"
wpvoto2010$post_date<-"2013-10-31 21:43:47"
wpvoto2010$post_date_gmt<-"2013-10-31 21:43:47"
wpvoto2010$post_content<-voto2010$post
wpvoto2010$post_title<-voto2010$deputado
wpvoto2010$post_excerpt<-""
wpvoto2010$post_status<-"publish"
wpvoto2010$comment_status<-"open"
wpvoto2010$ping_status<-"open"
wpvoto2010$post_password<-""
wpvoto2010$post_name<-paste("emenda",voto2010$deputado)
wpvoto2010$to_ping<-""
wpvoto2010$pinged<-""
wpvoto2010$post_modified<-"2013-10-31 21:43:47"
wpvoto2010$post_modified_gmt<-"2013-10-31 21:43:47"
wpvoto2010$post_content_filtered<-""
wpvoto2010$post_parent<-"0"
wpvoto2010$guid<-paste("http://camarapelobrasil.site50.net/?p=",wpvoto2010$id,sep="")
wpvoto2010$menu_order<-"0"
wpvoto2010$post_type<-"post"
wpvoto2010$post_mime_type<-""
wpvoto2010$comment_count<-""

write.table(wpvoto2010,"wpvoto2010.txt",sep=";",row.names=FALSE,col.names=FALSE)
write.table(wpvoto2010Meta,"wpvoto2010Meta.txt",sep=";",row.names=FALSE,col.names=FALSE)

write.table(voto2010,"~/hackathonCamara/votoDeputados/voto2010.txt",sep=";")