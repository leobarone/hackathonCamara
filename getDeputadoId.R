rm(list=ls())

urlId<-"http://www.camara.gov.br/cota-parlamentar/lista-deputados-partido-uf?partidoSelecionado=QQ&ufSelecionada=UFUF"

getDeputadoId<-function(site){
  ufList<-c("AC","AL","AP","AM","BA","CE","DF","ES","GO","MA","MT","MS","MG","PA","PB","PR","PE","PI","RJ","RN","RS","RO","RR","SC","SP","SE","TO")
  deputadoId<-c()
  for (uf in ufList){
    urlIn<-gsub("UFUF",uf,site) 
    page<-readLines(urlIn)
    linhas<-grep("nuDeputadoId=",page)
    nlinhas<-length(linhas)
    linhas<-(c(linhas,linhas+1,linhas+2))
    page<-page[linhas]
    page <- x <- iconv(page, "UTF-8", "latin1")
    page[1:nlinhas]<-substr(page[1:nlinhas],67,nchar(page[1:nlinhas])-2)
    page[(nlinhas+1):(nlinhas*2)]<-substr(page[(nlinhas+1):(nlinhas*2)],15,nchar(page[(nlinhas+1):(nlinhas*2)])-2)
    page[(nlinhas*2+1):(nlinhas*3)]<-substr(page[(nlinhas*2+1):(nlinhas*3)],15,nchar(page[(nlinhas*2+1):(nlinhas*3)])-10)
    deputadoUf<-data.frame(matrix(page,ncol=3),stringsAsFactors=FALSE)
    names(deputadoUf)<-c("id","deputado","partido")
    deputadoId<-rbind(deputadoId,deputadoUf)
  }
  return(deputadoId)
}

deputadoId<-getDeputadoId(urlId)
deputadoId$id<-as.numeric(deputadoId$id)
deputadoId$uf<-substr(deputadoId$partido,nchar(deputadoId$partido)-1,nchar(deputadoId$partido))
deputadoId$partido<-substr(deputadoId$partido,1,nchar(deputadoId$partido)-3)

#write.table(deputadoId,"deputadoIdCamara.txt",sep=";")

