rm(list=ls())

# Executa getDeputadoId.R para obter lista de ids deputados 
source("~/hackathonCamara/cotaParlamentar/getDeputadoId.R")
listaId<-deputadoId$id;rm(list=(setdiff(ls(),"listaId")))

# url base
url<-"http://www.camara.gov.br/cota-parlamentar/cota-analitico?nuDeputadoId=PPPP&numMes=MMMM&numAno=AAAA&numSubCota="

# 'Le' e 'Escreve' todas as urls validas na pasta "~/hackatonCamara/cotaUrl"
options(timeout=500)
getUrlCota<-function(anoIni,anoFim,listaIdDep){
  pathInFolder<-file.path("~/hackathonCamara/cotaUrl")
  i=1
  for (depId in listaIdDep){
    for (ano in anoIni:anoFim){
      for (mes in 1:12){
        siteIn<-url
        siteIn<-gsub("MMMM",mes,siteIn)
        siteIn<-gsub("AAAA",ano,siteIn)
        siteIn<-gsub("PPPP",depId,siteIn)
        print(paste(depId,ano,mes,i,siteIn));i=i+1
        truePageRead<-try(readLines(siteIn))
        if(class(truePageRead) != "try-error"){
          siteRead<-readLines(siteIn)
          mesChar<-paste("0",mes,sep="")
          mesChar<-substr(mesChar,nchar(mesChar)-1,nchar(mesChar))
          print(mesChar)
          pathInFile<-file.path(pathInFolder,paste("cota",ano,mesChar,depId,sep=""))
          writeLines(siteRead,pathInFile)
        }
      }
    }
  }
}


getUrlCota(2007,2013,listaId)
