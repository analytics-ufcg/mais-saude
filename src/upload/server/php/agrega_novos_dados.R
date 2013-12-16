###############
# bibliotecas #
###############
require(gdata)
require(plyr)
require(Hmisc)

ordenaDataFrame = function(data) {
  data$NOME_MUNICIPIO = as.character(data$NOME_MUNICIPIO)
  data$ANO = as.character(data$ANO)
  data = arrange(data, data$NOME_MUNICIPIO, data$ANO)
  return (data)
}


#junta a tabela nova na tabela default
addTabela = function(tabela.default, tabela.nova) {
  ano = setdiff(tabela.nova$ANO, tabela.default$ANO)
  tabela.nova = ordenaDataFrame(tabela.nova)
  if(length(ano) != 0) {
    for (i in ano) {
      tabela.default = rbind.fill(tabela.default, tabela.nova[tabela.nova$ANO == i,])
    }
  }
  else {
    tabela.default[,colnames(tabela.nova)[10:11]] = tabela.nova[,10:11]
  }
  return (ordenaDataFrame(tabela.default))
}



####################################################################################################################

args <- commandArgs(trailingOnly = TRUE)

#Tabela do indicador novo
tabela.nova <- read.csv(args[1])

#tabela do indicador antigo
tabela.default <- read.csv(args[2])

tabela.final = addTabela(tabela.default, tabela.nova)

#salva data frame
write.csv(x=tabela.final, file=args[3], row.names=F)