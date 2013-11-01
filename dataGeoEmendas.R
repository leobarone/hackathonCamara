rm(list=ls())

# Importa dados extraidos no SIGA BRASIL
pasta<-list.files("~/hackathonCamara/emendas/emendasSiga")
emendas<-c()
for (i in 1:length(pasta)){
  dataIn<-read.table(file.path("~/hackathonCamara/emendas/emendasSiga",
                               pasta[i]),sep=";",header=TRUE)
  names(dataIn)<-c("regiao","uf","localidade","cod.localidade","tipo.localidade","populacao","emenda","emenda.modalidade",
                   "emenda.tipo","emenda.justificativa","valor","valor.cancelamento","autor.cod","autor","autor.uf","autor.tipo",
                   "partido.sigla","mod.aplic.cod","mod.aplic","mod.aplic.desc")
  dataIn$ano<-as.numeric(substr(pasta[i],2,5))
  emendas<-rbind(emendas,dataIn)
  rm(dataIn,i)
}
rm(pasta)

# Seleciona apenas emendas de deputados federais para municipios (localidade, nao organizacao) e para partidos validos
emendas<-emendas[emendas$tipo.localidade=="MUNICÍPIO",]
emendas<-emendas[emendas$autor.tipo=="DEPUTADO FEDERAL",]
emendas<-emendas[emendas$tipo.localidade=="MUNICÍPIO",]
emendas$cod.munic<-emendas$cod.localidade

# Adiciona numero do partido como variavel
listaPartidos <- read.csv("~/hackathonCamara/emendas/listaPartidos.txt",sep=";")
listaPartidos<-listaPartidos[,c(4,3)]
names(listaPartidos)<-c("partido.sigla","partido")
listaPartidos$partido.sigla<-as.character(listaPartidos$partido.sigla)
emendas$partido.sigla[emendas$partido.sigla=="PC DO B"]<-"PC do B"
emendas<-merge(emendas,listaPartidos,by="partido.sigla",all.x=TRUE,all.y=FALSE)

municTseIbge<-read.table("~/hackathonCamara/emendas/municTseIbge2.txt",sep=";",header=TRUE)
municTseIbge<-municTseIbge[municTseIbge$ano==2010,c(6,5)]
names(municTseIbge)<-c("cod.munic","municIbge")
municTseIbge$munic<-as.character(municTseIbge$munic)
emendas<-merge(emendas,municTseIbge,by="cod.munic",all.x=TRUE,all.y=FALSE)
rm(listaPartidos,municTseIbge)

emendas$municipio<-paste(emendas$municIbge,"-",emendas$uf)
listaMunicipiosEmendas<-sort(unique(emendas$municipio))

#library(ggmap)
#geoMunicEmenda<-geocode(listaMunicipiosEmendas[1:2])

emendas$cod.munic<-as.numeric(emendas$cod.localidade)

source("hackathonCamara/cadmun.R")

emendas<-merge(emendas,latlong,by="cod.munic",all.x=TRUE,all.y=FALSE)
#emendasCartodb<-emendas[,c("municipio","latitude","longitude","valor","autor","partido","autor.uf","emenda.justificativa")]
#write.table(emendasCartodb,"~/hackathonCamara/emendasCartodb.csv",sep=";",row.names = FALSE)
#emendasCartodbSj<-emendas[,c("municipio","latitude","longitude","valor","autor","partido","autor.uf")]
#write.table(emendasCartodbSj,"~/hackathonCamara/emendasCartodbSj.csv",sep=";",row.names = FALSE)
#head(emendas[,setdiff(names(emendas),c("emenda.justificativa","post"))])
#write.table(emendasCamara,"~/hackathonCamara/emendasIndividuais.txt",sep=";",row.names = FALSE)
  

emendas$post<-paste("VALOR DA EMENDA:",emendas$valor,"; ANO FISCAL:", emendas$ano, "; JUSTIFICATIVA:", emendas$emenda.justificativa)
emendas$deputado<-paste(emendas$autor," (",emendas$partido.sigla,"-",emendas$autor.uf,")",sep="")
emendasCamara<-emendas[,c("latitude","longitude","deputado","post")]
emendas$string.latlong<-paste('a:2:{s:3:"lat";d:',emendas$latitude,';s:3:"lon";d:',emendas$longitude,';}',sep="")
emendas$id<-(1:nrow(emendasCamara)+10000)
emendas<-emendas[8001:nrow(emendas),]

wpEmendasLocation<-emendas[,c("id","string.latlong")]
names(wpEmendasLocation)<-c("post_id","meta_value")
wpEmendasLocation$meta_key<-"_mpv_location"
wpEmendasLocation<-wpEmendasLocation[,c(1,3,2)]
head(wpEmendasLocation)

wpEmendasMap<-data.frame(emendas$id)
names(wpEmendasMap)<-"post_id"
wpEmendasMap$meta_key<-"_mpv_inmap"
wpEmendasMap$meta_value<-"5"
head(wpEmendasMap)

wpEmendasLocation<-emendas[,c("id","string.latlong")]
names(wpEmendasLocation)<-c("post_id","meta_value")
wpEmendasLocation$meta_key<-"_mpv_location"
wpEmendasLocation<-wpEmendasLocation[,c(1,3,2)]
head(wpEmendasLocation)

wpEmendasMeta<-rbind(wpEmendasMap,wpEmendasLocation)
wpEmendasMeta<-wpEmendasMeta[order(wpEmendasMeta$post_id),]
wpEmendasMeta$meta_id<-1:nrow(wpEmendasMeta)+500000
wpEmendasMeta$meta_id<-as.character(wpEmendasMeta$meta_id)
wpEmendasMeta$post_id<-as.character(wpEmendasMeta$post_id)
wpEmendasMeta<-wpEmendasMeta[,c(4,1:3)]
head(wpEmendasMeta)

wpEmendas<-data.frame(emendas$id)
names(wpEmendas)<-"id"
wpEmendas$id<-as.character(wpEmendas$id)
wpEmendas$post_author<-"1"
wpEmendas$post_date<-"2013-10-31 21:43:47"
wpEmendas$post_date_gmt<-"2013-10-31 21:43:47"
wpEmendas$post_content<-emendas$post
wpEmendas$post_title<-eme*ndas$deputado
wpEmendas$post_excerpt<-""
wpEmendas$post_status<-"publish"
wpEmendas$comment_status<-"open"
wpEmendas$ping_status<-"open"
wpEmendas$post_password<-""
wpEmendas$to_ping<-""
wpEmendas$pinged<-""
wpEmendas$post_modified<-"2013-10-31 21:43:47"
wpEmendas$post_modified_gmt<-"2013-10-31 21:43:47"
wpEmendas$post_content_filtered<-""
wpEmendas$post_parent<-"0"
wpEmendas$guid<-paste("http://camarapelobrasil.site50.net/?p=",wpEmendas$id,sep="")
wpEmendas$menu_order<-"0"
wpEmendas$post_type<-"post"
wpEmendas$post_mime_type<-""
wpEmendas$comment_count<-""

write.table(wpEmendas,"wpEmendas.txt",sep=";",row.names=FALSE,col.names=FALSE)
write.table(wpEmendasMeta,"wpEmendasMeta.txt",sep=";",row.names=FALSE,col.names=FALSE)

unique(emendas$deputado)