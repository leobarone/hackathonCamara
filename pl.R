rm(list=ls())
library(XML)
url<-"http://www.camara.leg.br/sileg/Prop_lista.asp?Pagina=1&formulario=formPesquisaPorAssunto&Ass1=seca&co1=+AND+&Ass2=&co2=+AND+&Ass3=&Submit2=Pesquisar&sigla=&Numero=&Ano=&Autor=&Relator=&dtInicio=&dtFim=&Comissao=&Situacao=&pesqAssunto=1&OrgaoOrigem=todos"
s<-readLines(url)

head(s,600)
cleanSiteIn<-function(vetorProp){
  vetorProp<-gsub("<p><strong>Autor:</strong>","",vetorProp)
  vetorProp<-gsub("</p><p><b>Data de apresentação: </b>","|",vetorProp)
  vetorProp<-gsub("<br /><b>Ementa: </b>","|",vetorProp)
  vetorProp<-gsub("</p>","",vetorProp)
}

proposicoesSeca<-c()
for (i in 1:16){
  print(i)
  url<-gsub("XXX",i,url)
  siteIn<-readLines(url)
  siteIn<-siteIn[464:length(siteIn)]
  siteIn<-siteIn[grep("<p><strong>Autor:</strong>",siteIn)]  
  siteIn<-cleanSiteIn(siteIn)
  write.table(siteIn,"temp.txt",quote=FALSE)
  dataIn<-read.table("temp.txt",sep="|",skip=1,fill=TRUE)
  names(dataIn)<-c("autor","data","PL")
  proposicoesSeca<-rbind(proposicoesSeca,dataIn)
  rm(siteIn)
}
  
write.table(proposicoesSeca,"ementaPropSeca.txt",sep="\t",row.names=FALSE)

write.table(siteIn,"urlPLseca.txt",sep="/t",row.names=FALSE)

head(siteIn,60)

tableIn<-readHTMLTable(siteIn)