rm(list=ls())
#source("~/hackathonCamara/cotaUrl/getCotaUrl.R")
length(list.files("~/hackathonCamara/cotaUrl"))
library(XML)

getTableCota<-function(folder){
  tableOut<-c()
  pathInFolder<-file.path("~/hackathonCamara/cotaUrl")
  for (fileIn in list.files(folder)){
    print(fileIn)
    pathInFile<-file.path(pathInFolder,fileIn)
    fileTabs <- readHTMLTable(pathInFile)
    if (length(fileTabs)>1){
      for (i in 1:length(fileTabs)){
        #print(i)
        tableIn<-data.frame(fileTabs[i],stringsAsFactors=FALSE)
        if (!("NULL.Passageiro" %in% names(tableIn))){
          tableIn<-tableIn[tableIn[1]!="TOTAL",
                           c("NULL.CNPJ.CPF","NULL.Nome.do.Fornecedor",
                             "NULL.NF.Recibo","NULL.Valor.Reembolsado")]
          names(tableIn)<-c("cnpj","razao","recibo","valor")
          tableIn$ano<-as.numeric(substr(fileIn,5,8))
          tableIn$mes<-as.numeric(substr(fileIn,9,10))
          tableIn$id<-as.numeric(substr(fileIn,11,16))
          tableOut<-rbind(tableOut,tableIn)
        }
        rm(tableIn)
      }
    }
  }
  tableOut$cnpj<-as.character(tableOut$cnpj)
  tableOut$razao<-as.character(tableOut$razao)
  tableOut$recibo<-as.character(tableOut$recibo)
  tableOut$valor<-as.character(tableOut$valor)
  tableOut$valor<-gsub("[.]","",tableOut$valor)
  tableOut$valor<-gsub(",",".",tableOut$valor)
  tableOut$valor<-substr(tableOut$valor,4,nchar(tableOut$valor))
  tableOut$valor<-as.numeric(tableOut$valor)
  return(tableOut)
}

getTablePassagem<-function(folder){
  tableOut<-c()
  pathInFolder<-file.path("~/hackathonCamara/cotaUrl")
  for (fileIn in list.files(folder)){
    print(fileIn)
    pathInFile<-file.path(pathInFolder,fileIn)
    fileTabs <- readHTMLTable(pathInFile)
    if (length(fileTabs)>1){
      for (i in 1:length(fileTabs)){
        print(i)
        tableIn<-data.frame(fileTabs[i],stringsAsFactors=FALSE)
        if ("NULL.Passageiro" %in% names(tableIn)){
          tableIn<-tableIn[tableIn[1]!="TOTAL",
                           c("NULL.CNPJ.CPF","NULL.Nome.do.Fornecedor","NULL.NF.Recibo",
                             "NULL.Data.de.Emissão","NULL.Passageiro","NULL.Trecho","NULL.Valor.Reembolsado")]
          names(tableIn)<-c("cnpj","razao","recibo","data","passageiro","trecho","valor")
          tableIn$ano<-as.numeric(substr(fileIn,5,8))
          tableIn$mes<-as.numeric(substr(fileIn,9,10))
          tableIn$id<-as.numeric(substr(fileIn,11,16))
          tableOut<-rbind(tableOut,tableIn)  
        }
        rm(tableIn)
      }
    }
  }
  tableOut$cnpj<-as.character(tableOut$cnpj)
  tableOut$razao<-as.character(tableOut$razao)
  tableOut$recibo<-as.character(tableOut$recibo)
  tableOut$valor<-as.character(tableOut$valor)
  tableOut$valor<-gsub("[.]","",tableOut$valor)
  tableOut$valor<-gsub(",",".",tableOut$valor)
  tableOut$valor<-substr(tableOut$valor,4,nchar(tableOut$valor))
  tableOut$valor<-as.numeric(tableOut$valor)
  return(tableOut)
}

cotaParlamentar<-getTableCota("~/hackathonCamara/cotaUrl")
passagensParlamentar<-getTablePassagem("~/hackathonCamara/cotaUrl")

