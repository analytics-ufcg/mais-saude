#script que adiciona novos dados ao sistema, a partir de uma tabela com o indicador a ser atualizado o script atualiza a tabela dos indicadores e dos desvios
# e a tabela das medianas. O script recebe como entrada da linha de comando 6 argumentos:

#1: endereço da nova tabela a ser adicionadac("INDICADOR_EXEMPLO - tabela com indicador_62 com anos 2012 e 2013.csv")
#2: endereço da tabela default do sistema com os valores dos indicadores e dos desvios("tabela_com_todos_os_indicadores_selecionados_e_desvios.csv")
#3: endereço da tabela default com os valores das medianas("medianas_para_todos_os_indicadores_agrupados_por_ano_e_regiao.csv")
#4: endereço com o nome da nova tabela com os novos dados dos indicadores
#5: endereço com o nome da nova tabela com as medianas
#6: endereço do  bin do perl ("C:/strawberry/perl/bin/perl.exe") 

#Rscript agrega_novos_dados_nas_tabelas_de_indicadores_e_medianas.R 1.xls saida/1.csv saida/2.csv saida2/1.csv saida2/2.csv C:/strawberry/perl/bin/perl.exe

###############
# bibliotecas #
###############
require(gdata)
require(plyr)
require(Hmisc)

#install.packages("Hmisc")

#---------------------------------------------------------------------------------------------------------------------------------#
#-----------------------------------------------------------FUNCOES---------------------------------------------------------------#
#---------------------------------------------------------------------------------------------------------------------------------#

####Funcoes para mediana da Paraiba e das meso e micro regioes

#Caclula a mediana com base nos dados e no nome da regiÃ£o desejada
calcMedian = function(data, nome.regiao) {
  nome.coluna = colnames(data)[ncol(data)]
  colnames(data)[ncol(data)] = "INDICADOR"
  tabela = with(data,aggregate(INDICADOR, list(data[,nome.regiao],data$ANO), FUN= median,na.rm=T))
  colnames(tabela) = c("REGIAO", "ANO", nome.coluna)
  return(tabela)
}


#Calcula a mediana para a micro a meso e a paraiba e retorna em um data.frame agrupadas por ano
agregaMedianas = function(data2) {
  tabela2 = rbind(calcMedian(data2,"NOME_MICRO"), calcMedian(data2,"NOME_MESO"), calcMedian(data2,"NOME_UF"))
  return(tabela2)
}


#processa cada indicador com as funcoes anteriores e agrega todos em um unico data frame
#recebe tabela do novo indicador, tabela de mediana default
processaIndicador <- function(df.indicador, arquivo.principal){
  anos.existentes = unique(arquivo.principal$ANO) 
  ano.indicador = unique(df.indicador$ANO)
  inter = intersect(anos.existentes,ano.indicador)
  presente = setdiff(ano.indicador,anos.existentes)
  if(length(presente) == 0){
    tabela.nova = arquivo.principal
    tabela.nova$ID = paste(tabela.nova[,1],tabela.nova[,2])
    medianas = agregaMedianas(df.indicador)
    nome <- colnames(medianas[3])
    medianas$ID <- paste(medianas[,1],medianas[,2])
    index.indicador <- match(tabela.nova$ID,medianas$ID)
    index <- which(!is.na(index.indicador))
    tabela.nova[,nome][index] <- medianas[,nome][index.indicador[!is.na(index.indicador)]] 
    tabela.nova = tabela.nova[,-ncol(tabela.nova)]
    return(tabela.nova) 
  }else{
    df.indicador <- subset(df.indicador, df.indicador$ANO %nin% anos.existentes)
    df.medianas = agregaMedianas(df.indicador)
    nome.id <- colnames(df.medianas[3])# pega o nome do Identificador
    print(colnames(df.medianas)) #INDICADOR, ID
    matriz.indicadores <- data.frame(matrix(NA,ncol=15,nrow = nrow(df.medianas)))
    tabela = cbind(df.medianas[,c(1,2)],matriz.indicadores)
    colnames(tabela) = colnames(arquivo.principal)
    df.medianas$ID <- paste(df.medianas[,1],df.medianas[,2])
    tabela$ID <-  paste(tabela[,1],tabela[,2])
    index.match <- match(tabela$ID,df.medianas$ID)
    index2 <- which(!is.na(index.match))
    tabela[,nome.id][index2] <- df.medianas[,nome.id][index.match[!is.na(index.match)]] 
    tabela = tabela[,-ncol(tabela)]
    data.principal = rbind(arquivo.principal,tabela)
    return(data.principal)
  }
}

########################################################################################################################################################################


############Funcoes para os indicadores e os desvios dos indicadores e agregação

#Ordena um dataframe pelo nome do municipio depois pelo ano
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


#Recebe um valor do indicador, as tabelas de media e desvio padrao, e o ano do indicador. Retorna quantos desvios o valor esta da média
classifyOutLiers <- function(obValue, list.quantiles, ano, data.frame){
  if(!is.na(obValue)) {#####Mudar essas ordens, melhor do meio para o final
    if(obValue == list.quantiles$q0){
      return(0)
    }
    if(obValue > list.quantiles$q4){
      return(4)
    }
    if(obValue > list.quantiles$q3){
      return(3)
    }
    if(obValue > list.quantiles$q2){
      return(2)
    }
    if(obValue > list.quantiles$q1){
      return(1)
    }
    
    if(obValue < list.quantiles$q4.neg){
      return(-4)
    }
    if(obValue < list.quantiles$q3.neg){
      return(-3)
    }
    if(obValue < list.quantiles$q2.neg){
      return(-2)
    }
    if(obValue < list.quantiles$q1.neg){
      return(-1)
    }
  }
  else {
    return(NA)
  }
}
#resultado = 13.9136439130487
data.frame.fronteiras <<- data.frame(stringsAsFactors = FALSE)
data.frame.todas.cidades.ano <<- data.frame(stringsAsFactors = FALSE)
#recebe o data frame com um indicador e retorna um novo data frame com uma nova coluna informando se o indicador e outlier. Remove NAs dos indicadores.
generateOutlierColumn <- function(data.df, referencial.outlier, sem.cg.jp, nome.indicador, eh.normal){ 
  
  data.sem.nas = na.omit(data.df,stringsAsFactors = FALSE)
  if(sem.cg.jp == T){
    data.frame.todas.cidades.ano <<- data.frame(stringsAsFactors = FALSE)
    data.frame.todas.cidades.ano <<- rbind(data.frame.todas.cidades.ano, data.sem.nas)
    if(eh.normal)
    {
      print("uhuuuu eu sou normal!!!")
      central = mean(data.sem.nas$VALOR)
    }else{
      central = median(data.sem.nas$VALOR)
    }
    list.quantiles <<- list(indicador = nome.indicador,
    ano = data.df$ANO[1],
    q4 = quantile(data.sem.nas$VALOR, 0.999),
    q3 = quantile(data.sem.nas$VALOR, 0.978),
    q2 = quantile(data.sem.nas$VALOR, 0.842),
    q1 = quantile(data.sem.nas$VALOR, 0.5),
    q0 = central,
    q1.neg = quantile(data.sem.nas$VALOR, 0.5),
    q2.neg = quantile(data.sem.nas$VALOR, 0.158),
    q3.neg = quantile(data.sem.nas$VALOR, 0.021),
    q4.neg = quantile(data.sem.nas$VALOR, 0.001)
    )
    
    
  }
  if(sem.cg.jp == F)
  {
    data.frame.todas.cidades.ano <<- rbind(data.frame.todas.cidades.ano, data.sem.nas)
    list.quantiles["max"] = max(data.frame.todas.cidades.ano$VALOR)
    list.quantiles["min"] = min(data.frame.todas.cidades.ano$VALOR)
    data.frame.fronteiras <<- rbind(data.frame.fronteiras, list.quantiles)
  }
  #meanAno = aggregate(data.sem.nas[,ncol(data.sem.nas)], list(data.sem.nas$Ano), mean)
  #sdAno = aggregate(data.sem.nas[,ncol(data.sem.nas)], list(data.sem.nas$Ano), sd)
  class <- Vectorize(classifyOutLiers,c("obValue", "ano"))(data.df$VALOR, list.quantiles, data.df$ANO, data.df)#################pegando coluna por numero##############
  #inverte a ordem caso maior seja pior
  if(referencial.outlier == "PIOR") {
    class = -1 * class
  }
  #print(data.df)
  #print(class)
  data.df = cbind(data.df, class)
  
  colnames(data.df)[9] = paste("DESVIOS_", referencial.outlier, "_", colnames(data.df)[8], sep="")#################pegando coluna por numero##############
  return(data.df)
}

getIndicadorCategoria = function(tabela.nova, tabela.indicador){
  categoria = tabela.indicador[tabela.indicador$indice==colnames(tabela.nova)[10],]$categoria
  return (as.character(categoria))
}

###############################################----Minha parte------#############################################


indicador_01 = gerarIntervalos("data/INDICADOR_001.csv", F, T, F, "UTF-8", ";", 8, 2, "MELHOR", eh.normal=c(F,F,F,F,F,F), "indicador_001")
indicador_02 = gerarIntervalos("data/INDICADOR_002.csv", F, T, F, "UTF-8", ";", 8, 2, "MELHOR", eh.normal=c(F,F,F,F,F,F), "indicador_002")
indicador_04 = gerarIntervalos("data/INDICADOR_004.csv", F, T, F, "UTF-8", ";", 8, 2, "MELHOR", eh.normal=c(F,F,F,F,F,F), "indicador_004")
indicador_07 = gerarIntervalos("data/INDICADOR_007.csv", F, T, F, "UTF-8", ";", 8, 2, "MELHOR", eh.normal=c(F,F,F,F,F,F), "indicador_007")
indicador_09 = gerarIntervalos("data/INDICADOR_009.csv", F, T, F, "UTF-8", ";", 8, 2, "MELHOR", eh.normal=c(F,F,F,F,F,F), "indicador_009")
indicador_20 = gerarIntervalos("data/INDICADOR_020.csv", F, F, F, "UTF-8", ";", 8, 2, "MELHOR", eh.normal=c(F,F,F,F,F,F), "indicador_020")
indicador_21 = gerarIntervalos("data/INDICADOR_021.csv", F, F, F, "UTF-8", ";", 8, 2, "MELHOR", eh.normal=c(F,F,F,F,F,F), "indicador_021")
indicador_35 = gerarIntervalos("data/INDICADOR_035.csv", F, T, F, "UTF-8", ";", 8, 2, "MELHOR", eh.normal=c(F,F,F,F,F,F), "indicador_035")
indicador_41 = gerarIntervalos("data/INDICADOR_041.csv", F, T, F, "UTF-8", ";", 8, 2, "MELHOR", eh.normal=c(F,F,F,F,F,F), "indicador_041")

indicador_101 = gerarIntervalos("data/INDICADOR_101.csv", T, T, F, "UTF-8", ",", 8, 2, "MELHOR", eh.normal=c(F,F,F,F,F,F), "indicador_101")
indicador_102 = gerarIntervalos("data/INDICADOR_102.csv", T, T, F, "UTF-8", ",", 8, 2, "MELHOR", eh.normal=c(F,F,F,F,F,F), "indicador_102")
indicador_103 = gerarIntervalos("data/INDICADOR_103.csv", T, T, F, "UTF-8", ",", 8, 2, "MELHOR", eh.normal=c(F,F,F,F,F,F), "indicador_103")
indicador_104 = gerarIntervalos("data/INDICADOR_104.csv", T, T, F, "UTF-8", ",", 8, 2, "MELHOR", eh.normal=c(F,F,F,F,F,F), "indicador_104")
indicador_105 = gerarIntervalos("data/INDICADOR_105.csv", T, T, F, "UTF-8", ",", 8, 2, "MELHOR", eh.normal=c(F,F,F,F,F,F), "indicador_105")
indicador_106 = gerarIntervalos("data/INDICADOR_106.csv", T, T, F, "UTF-8", ",", 8, 2, "MELHOR", eh.normal=c(F,F,F,F,F,F), "indicador_106")
indicador_107 = gerarIntervalos("data/INDICADOR_107.csv", T, T, F, "UTF-8", ",", 8, 2, "MELHOR", eh.normal=c(F,F,F,F,F,F), "indicador_107")
indicador_108 = gerarIntervalos("data/INDICADOR_108.csv", T, T, F, "UTF-8", ",", 8, 2, "MELHOR", eh.normal=c(F,F,F,F,F,F), "indicador_108")
indicador_109 = gerarIntervalos("data/INDICADOR_109.csv", T, T, F, "UTF-8", ",", 8, 2, "MELHOR", eh.normal=c(F,F,F,F,F,F), "indicador_109")
indicador_110 = gerarIntervalos("data/INDICADOR_110.csv", T, T, F, "UTF-8", ",", 8, 2, "MELHOR", eh.normal=c(F,F,F,F,F,F), "indicador_110")
indicador_111 = gerarIntervalos("data/INDICADOR_111.csv", T, T, F, "UTF-8", ",", 8, 2, "MELHOR", eh.normal=c(F,F,F,F,F,F), "indicador_111")
indicador_112 = gerarIntervalos("data/INDICADOR_112.csv", T, T, F, "UTF-8", ",", 8, 2, "MELHOR", eh.normal=c(F,F,F,F,F,F), "indicador_112")
indicador_113 = gerarIntervalos("data/INDICADOR_113.csv", T, T, F, "UTF-8", ",", 8, 2, "MELHOR", eh.normal=c(F,F,F,F,F,F), "indicador_113")
indicador_114 = gerarIntervalos("data/INDICADOR_114.csv", T, T, F, "UTF-8", ",", 8, 2, "MELHOR", eh.normal=c(F,F,F,F,F,F), "indicador_114")


indicador_201 = gerarIntervalos("data/INDICADOR_201.csv", F, F, T, "UTF-8", ",", 8, 7, "MELHOR", eh.normal=c(F,F,F,F,F,F), "indicador_201")
indicador_202 = gerarIntervalos("data/INDICADOR_202.csv", F, F, T, "UTF-8", ",", 8, 7, "MELHOR", eh.normal=c(F,F,F,F,F,F), "indicador_202")
indicador_203 = gerarIntervalos("data/INDICADOR_203.csv", F, T, T, "UTF-8", ",", 8, 7, "MELHOR", eh.normal=c(F,F,F,F,F,F), "indicador_203")
indicador_204 = gerarIntervalos("data/INDICADOR_204.csv", F, T, T, "UTF-8", ",", 8, 7, "MELHOR", eh.normal=c(F,F,F,F,F,F), "indicador_204")
indicador_205 = gerarIntervalos("data/INDICADOR_205.csv", F, T, T, "UTF-8", ",", 8, 7, "MELHOR", eh.normal=c(F,F,F,F,F,F), "indicador_205")
indicador_206 = gerarIntervalos("data/INDICADOR_206.csv", F, F, T, "UTF-8", ",", 8, 7, "MELHOR", eh.normal=c(F,F,F,F,F,F), "indicador_206")
indicador_207 = gerarIntervalos("data/INDICADOR_207.csv", F, F, T, "UTF-8", ",", 8, 7, "MELHOR", eh.normal=c(F,F,F,F,F,F), "indicador_207")
indicador_208 = gerarIntervalos("data/INDICADOR_208.csv", F, T, T, "UTF-8", ",", 8, 7, "MELHOR", eh.normal=c(F,F,F,F,F,F), "indicador_208")

gerarIntervalos = function(arquivo, com.2007, com.2012, soh.2010,  encode.arq, separador, col.valor, col.ano, categoria.indicador, eh.normal, nome.indicador){
  

  #df = read.csv(file="Downloads/INDICADOR_1.csv", fileEncoding="UTF-8", stringsAsFactors=F, header=T)
  df = read.csv(file=arquivo, fileEncoding=encode.arq, stringsAsFactors=F, header=T, sep = separador)
  
  df$Municipio = NULL
  df$Função = NULL
  df$COD_UF = NULL
  df$NOME_UF = NULL
  colnames(df)[col.ano] <- "ANO"  #alguns dataframes vem com Ano e n ANO
  colnames(df)[col.valor] <- "VALOR"
  
  
  
  df.sem.CG.e.JP = subset(df, df$COD_MUNICIPIO!=250750 & df$COD_MUNICIPIO!=250400)
  df.CG.e.JP = subset(df, df$COD_MUNICIPIO==250750 | df$COD_MUNICIPIO==250400)
  
  
  
          ##########FF###############
  
  df.sem.CG.e.JP.2007 = df.sem.CG.e.JP[df.sem.CG.e.JP$ANO == 2007,]
  df.sem.CG.e.JP.2008 = df.sem.CG.e.JP[df.sem.CG.e.JP$ANO == 2008,]
  df.sem.CG.e.JP.2009 = df.sem.CG.e.JP[df.sem.CG.e.JP$ANO == 2009,]
  df.sem.CG.e.JP.2010 = df.sem.CG.e.JP[df.sem.CG.e.JP$ANO == 2010,]
  df.sem.CG.e.JP.2011 = df.sem.CG.e.JP[df.sem.CG.e.JP$ANO == 2011,]
  df.sem.CG.e.JP.2012 = df.sem.CG.e.JP[df.sem.CG.e.JP$ANO == 2012,]
  

  
  
  df.CG.e.JP.2007 = df.CG.e.JP[df.CG.e.JP$ANO == 2007,]
  df.CG.e.JP.2008 = df.CG.e.JP[df.CG.e.JP$ANO == 2008,]
  df.CG.e.JP.2009 = df.CG.e.JP[df.CG.e.JP$ANO == 2009,]
  df.CG.e.JP.2010 = df.CG.e.JP[df.CG.e.JP$ANO == 2010,]
  df.CG.e.JP.2011 = df.CG.e.JP[df.CG.e.JP$ANO == 2011,]
  df.CG.e.JP.2012 = df.CG.e.JP[df.CG.e.JP$ANO == 2012,]
  
  if(soh.2010 == F){

    if(com.2007){
      saida.sem.CG.e.JP.2007 = generateOutlierColumn(df.sem.CG.e.JP.2007, categoria.indicador, T, nome.indicador, eh.normal[1])#tem que ser nessa ordem: sem e depois com
      saida.CG.e.JP.2007 = generateOutlierColumn(df.CG.e.JP.2007, categoria.indicador, F, nome.indicador, eh.normal[1])
    }
    
    saida.sem.CG.e.JP.2008 = generateOutlierColumn(df.sem.CG.e.JP.2008, categoria.indicador, T, nome.indicador, eh.normal[2])#tem que ser nessa ordem: sem e depois com
    saida.CG.e.JP.2008 = generateOutlierColumn(df.CG.e.JP.2008, categoria.indicador, F, nome.indicador, eh.normal[2])
    
    saida.sem.CG.e.JP.2009 = generateOutlierColumn(df.sem.CG.e.JP.2009, categoria.indicador, T, nome.indicador, eh.normal[3])#tem que ser nessa ordem: sem e depois com
    saida.CG.e.JP.2009 = generateOutlierColumn(df.CG.e.JP.2009, categoria.indicador, F, nome.indicador, eh.normal[3])
    
    saida.sem.CG.e.JP.2010 = generateOutlierColumn(df.sem.CG.e.JP.2010, categoria.indicador, T, nome.indicador, eh.normal[4])#tem que ser nessa ordem: sem e depois com
    saida.CG.e.JP.2010 = generateOutlierColumn(df.CG.e.JP.2010, categoria.indicador, F, nome.indicador, eh.normal[4])
    
    saida.sem.CG.e.JP.2011 = generateOutlierColumn(df.sem.CG.e.JP.2011, categoria.indicador, T, nome.indicador, eh.normal[5])#tem que ser nessa ordem: sem e depois com
    saida.CG.e.JP.2011 = generateOutlierColumn(df.CG.e.JP.2011, categoria.indicador, F, nome.indicador, eh.normal[5])
    
    if(com.2012){
      saida.sem.CG.e.JP.2012 = generateOutlierColumn(df.sem.CG.e.JP.2012, categoria.indicador, T, nome.indicador, eh.normal[6])#tem que ser nessa ordem: sem e depois com
      saida.CG.e.JP.2012 = generateOutlierColumn(df.CG.e.JP.2012, categoria.indicador, F, nome.indicador, eh.normal[6])
    }
    #print(saida.sem.CG.e.JP.2011)
    
    #rbind depois ordenar
    saida.2007 = data.frame()
    if(com.2007){
      saida.2007 = rbind(saida.sem.CG.e.JP.2007, saida.CG.e.JP.2007)
      saida.2007 = saida.2007[with(saida.2007, order(NOME_MUNICIPIO, ANO)), ]
    }
    
    saida.2008 = rbind(saida.sem.CG.e.JP.2008, saida.CG.e.JP.2008)
    saida.2008 = saida.2008[with(saida.2008, order(NOME_MUNICIPIO, ANO)), ]
    
    saida.2009 = rbind(saida.sem.CG.e.JP.2009, saida.CG.e.JP.2009)
    saida.2009 = saida.2009[with(saida.2009, order(NOME_MUNICIPIO, ANO)), ]
    
    saida.2010 = rbind(saida.sem.CG.e.JP.2010, saida.CG.e.JP.2010)
    saida.2010 = saida.2010[with(saida.2010, order(NOME_MUNICIPIO, ANO)), ]
    
    saida.2011 = rbind(saida.sem.CG.e.JP.2011, saida.CG.e.JP.2011)
    saida.2011 = saida.2011[with(saida.2011, order(NOME_MUNICIPIO, ANO)), ]
   
    saida.2012 = data.frame()
    if(com.2012){
      saida.2012 = rbind(saida.sem.CG.e.JP.2012, saida.CG.e.JP.2012)
      saida.2012 = saida.2012[with(saida.2012, order(NOME_MUNICIPIO, ANO)), ]
    }
    
    saida = rbind(saida.2007, saida.2008,saida.2009,saida.2010,saida.2011,saida.2012)
    saida = saida[with(saida, order(NOME_MUNICIPIO, ANO)), ]
  }
  else{
    saida.sem.CG.e.JP.2010 = generateOutlierColumn(df.sem.CG.e.JP.2010, categoria.indicador, T, nome.indicador, eh.normal[4])#tem que ser nessa ordem: sem e depois com
    saida.CG.e.JP.2010 = generateOutlierColumn(df.CG.e.JP.2010, categoria.indicador, F, nome.indicador, eh.normal[4])
    saida.2010 = rbind(saida.sem.CG.e.JP.2010, saida.CG.e.JP.2010)
    saida.2010 = saida.2010[with(saida.2010, order(NOME_MUNICIPIO, ANO)), ]
    saida = saida.2010
  }
  
  
  #write.csv(saida, "atuais/gps.csv", row.names=F)
  return(saida)
}



write.csv(saida.2007, "rpec_2007.csv", row.names=F)
write.csv(saida.2008, "rpec_2008.csv", row.names=F)
write.csv(saida.2009, "rpec_2009.csv", row.names=F)
write.csv(saida.2010, "rpec_2010.csv", row.names=F)
write.csv(saida.2011, "rpec_2011.csv", row.names=F)
write.csv(saida.2012, "rpec_2012.csv", row.names=F)
 







#######################remover primeira coluna####################

#------------------------Indicadores Saude-------------------------#

indicador_1 = read.csv(file="atuais/indicador_01.csv", fileEncoding="UTF-8", stringsAsFactors=F, header=T)
indicador_2 = read.csv(file="atuais/indicador_02.csv", fileEncoding="UTF-8", stringsAsFactors=F, header=T)
indicador_4 = read.csv(file="atuais/indicador_04.csv", fileEncoding="UTF-8", stringsAsFactors=F, header=T)
indicador_7 = read.csv(file="atuais/indicador_07.csv", fileEncoding="UTF-8", stringsAsFactors=F, header=T)
indicador_9 = read.csv(file="atuais/indicador_09.csv", fileEncoding="UTF-8", stringsAsFactors=F, header=T)
indicador_20 = read.csv(file="atuais/indicador_020.csv", fileEncoding="UTF-8", stringsAsFactors=F, header=T)
indicador_21 = read.csv(file="atuais/indicador_021.csv", fileEncoding="UTF-8", stringsAsFactors=F, header=T)
indicador_35 = read.csv(file="atuais/indicador_035.csv", fileEncoding="UTF-8", stringsAsFactors=F, header=T)
indicador_41 = read.csv(file="atuais/indicador_041.csv", fileEncoding="UTF-8", stringsAsFactors=F, header=T)

indicador_1 = indicador_1[,-1]
indicador_2 = indicador_2[,-1]
indicador_4 = indicador_4[,-1]
indicador_7 = indicador_7[,-1]
indicador_9 = indicador_9[,-1]
indicador_20 = indicador_20[,-1]
indicador_21 = indicador_21[,-1]
indicador_35 = indicador_35[,-1]
indicador_41 = indicador_41[,-1]

colnames(indicador_1)[8] <- "indicador_1"
colnames(indicador_2)[8] <- "indicador_2"
colnames(indicador_4)[8] <- "indicador_4"
colnames(indicador_7)[8] <- "indicador_7"
colnames(indicador_9)[8] <- "indicador_9"
colnames(indicador_20)[8] <- "indicador_20"
colnames(indicador_21)[8] <- "indicador_21"
colnames(indicador_35)[8] <- "indicador_35"
colnames(indicador_41)[8] <- "indicador_41"



merge.aux1 = merge(merge(indicador_1, indicador_2, by=c("COD_MUNICIPIO",  "ANO",	"COD_MESO",	"NOME_MESO",	"COD_MICRO",	"NOME_MICRO",	"NOME_MUNICIPIO"), all = T),
                   merge(indicador_4, indicador_7, by=c("COD_MUNICIPIO",  "ANO",  "COD_MESO",	"NOME_MESO",	"COD_MICRO",	"NOME_MICRO",	"NOME_MUNICIPIO"), all = T),
                   by=c("COD_MUNICIPIO",  "ANO",  "COD_MESO",	"NOME_MESO",	"COD_MICRO",	"NOME_MICRO",	"NOME_MUNICIPIO"), all = T)

merge.aux2 = merge(merge(indicador_9, indicador_20, by=c("COD_MUNICIPIO",  "ANO",  "COD_MESO",	"NOME_MESO",	"COD_MICRO",	"NOME_MICRO",	"NOME_MUNICIPIO"), all = T),
                   merge(indicador_21, indicador_35, by=c("COD_MUNICIPIO",  "ANO",  "COD_MESO",	"NOME_MESO",	"COD_MICRO",	"NOME_MICRO",	"NOME_MUNICIPIO"), all = T),
                   by=c("COD_MUNICIPIO",  "ANO",  "COD_MESO",	"NOME_MESO",	"COD_MICRO",	"NOME_MICRO",	"NOME_MUNICIPIO"), all = T)

merge.aux2.1 = merge(merge.aux2, indicador_41,  by=c("COD_MUNICIPIO",  "ANO",  "COD_MESO",	"NOME_MESO",	"COD_MICRO",	"NOME_MICRO",	"NOME_MUNICIPIO"), all = T)
merge.ind.saude = merge(merge.aux1, merge.aux2.1,  by=c("COD_MUNICIPIO",  "ANO",  "COD_MESO",	"NOME_MESO",	"COD_MICRO",	"NOME_MICRO",	"NOME_MUNICIPIO"), all = T)



#------------------------Indicadores Saude-------------------------#


gps = read.csv(file="atuais/gps.csv", fileEncoding="UTF-8", stringsAsFactors=F, header=T)
gps.corrente = read.csv(file="atuais/gpscorr.csv", fileEncoding="UTF-8", stringsAsFactors=F, header=T)
rgts = read.csv(file="atuais/rgts.csv", fileEncoding="UTF-8", stringsAsFactors=F, header=T)
invsaude = read.csv(file="atuais/invSaude.csv", fileEncoding="UTF-8", stringsAsFactors=F, header=T)
gtscor = read.csv(file="atuais/gtscor.csv", fileEncoding="UTF-8", stringsAsFactors=F, header=T)
gtscap = read.csv(file="atuais/gtscap.csv", fileEncoding="UTF-8", stringsAsFactors=F, header=T)
gsatb = read.csv(file="atuais/gsatb.csv", fileEncoding="UTF-8", stringsAsFactors=F, header=T)
gsaha = read.csv(file="atuais/gsaha.csv", fileEncoding="UTF-8", stringsAsFactors=F, header=T)
gsspt = read.csv(file="atuais/gsspt.csv", fileEncoding="UTF-8", stringsAsFactors=F, header=T)
gsv = read.csv(file="atuais/gsv.csv", fileEncoding="UTF-8", stringsAsFactors=F, header=T)
gsve = read.csv(file="atuais/gsve.csv", fileEncoding="UTF-8", stringsAsFactors=F, header=T)
gsag = read.csv(file="atuais/gsag.csv", fileEncoding="UTF-8", stringsAsFactors=F, header=T)
gp = read.csv(file="atuais/gp.csv", fileEncoding="UTF-8", stringsAsFactors=F, header=T)
rpec = read.csv(file="atuais/rpec.csv", fileEncoding="UTF-8", stringsAsFactors=F, header=T)

gps = gps[,-1]
gps.corrente = gps.corrente[,-1]
rgts = rgts[,-1]
gtscor = gtscor[,-1]
gtscap = gtscap[,-1]
gsatb = gsatb[,-1]
gsaha = gsaha[,-1]
gsspt = gsspt[,-1]
gsv = gsv[,-1]
gsve = gsve[,-1]
gsag = gsag[,-1]
gp = gp[,-1]
rpec = rpec[,-1]

colnames(gps)[8] <- "gps"
colnames(gps.corrente)[8] <- "gps.corrente"
colnames(rgts)[8] <- "rgts"
colnames(invsaude)[8] <- "invsaude"
colnames(gtscor)[8] <- "gtscor"
colnames(gtscap)[8] <- "gtscap"
colnames(gsatb)[8] <- "gsatb"
colnames(gsaha)[8] <- "gsaha"
colnames(gsspt)[8] <- "gsspt"
colnames(gsv)[8] <- "gsv"
colnames(gsve)[8] <- "gsve"
colnames(gsag)[8] <- "gsag"
colnames(gp)[8] <- "gp"
colnames(rpec)[8] <- "rpec"




merge.aux1 = merge(merge(gps, gps.corrente, by=c("COD_MUNICIPIO",  "ANO",  "COD_MESO",	"NOME_MESO",	"COD_MICRO",	"NOME_MICRO",	"NOME_MUNICIPIO"), all = T),
                   merge(rgts, gtscor, by=c("COD_MUNICIPIO",  "ANO",  "COD_MESO",	"NOME_MESO",	"COD_MICRO",	"NOME_MICRO",	"NOME_MUNICIPIO"), all = T),
                   by=c("COD_MUNICIPIO",  "ANO",  "COD_MESO",	"NOME_MESO",	"COD_MICRO",	"NOME_MICRO",	"NOME_MUNICIPIO"), all = T)

merge.aux2 = merge(merge(gtscap, gsatb, by=c("COD_MUNICIPIO",  "ANO",  "COD_MESO",	"NOME_MESO",	"COD_MICRO",	"NOME_MICRO",	"NOME_MUNICIPIO"), all = T),
                   merge(gsaha, gsspt, by=c("COD_MUNICIPIO",  "ANO",  "COD_MESO",	"NOME_MESO",	"COD_MICRO",	"NOME_MICRO",	"NOME_MUNICIPIO"), all = T),
                   by=c("COD_MUNICIPIO",  "ANO",  "COD_MESO",	"NOME_MESO",	"COD_MICRO",	"NOME_MICRO",	"NOME_MUNICIPIO"), all = T)

merge.aux3 = merge(merge(gsv, gsve, by=c("COD_MUNICIPIO",  "ANO",  "COD_MESO",  "NOME_MESO",	"COD_MICRO",	"NOME_MICRO",	"NOME_MUNICIPIO"), all = T),
                   merge(gsag, gp, by=c("COD_MUNICIPIO",  "ANO",  "COD_MESO",	"NOME_MESO",	"COD_MICRO",	"NOME_MICRO",	"NOME_MUNICIPIO"), all = T),
                   by=c("COD_MUNICIPIO",  "ANO",  "COD_MESO",	"NOME_MESO",	"COD_MICRO",	"NOME_MICRO",	"NOME_MUNICIPIO"), all = T)

merge.aux.3.1 = merge(merge.aux3, rpec, by=c("COD_MUNICIPIO",  "ANO",  "COD_MESO",  "NOME_MESO",	"COD_MICRO",	"NOME_MICRO",	"NOME_MUNICIPIO"), all = T)

merge.ind.fin = merge(merge(merge.aux1, merge.aux2, by=c("COD_MUNICIPIO",  "ANO",  "COD_MESO",  "NOME_MESO",	"COD_MICRO",	"NOME_MICRO",	"NOME_MUNICIPIO"), all = T),
                    merge.aux.3.1, by=c("COD_MUNICIPIO",  "ANO",  "COD_MESO",	"NOME_MESO",	"COD_MICRO",	"NOME_MICRO",	"NOME_MUNICIPIO"), all = T)


merge.ind.fin = merge(merge.ind.fin, invsaude,  by=c("COD_MUNICIPIO",  "ANO",  "COD_MESO",  "NOME_MESO",  "COD_MICRO",	"NOME_MICRO",	"NOME_MUNICIPIO"), all = T)

#----------------------Merge final---------------------

merge.final = merge(merge.ind.saude, merge.ind.fin, , by=c("COD_MUNICIPIO",  "ANO",  "COD_MESO",  "NOME_MESO",	"COD_MICRO",	"NOME_MICRO",	"NOME_MUNICIPIO"), all = T)


write.csv(merge.final, "atuais/tabelona_dos_desvios.csv", fileEncoding = "UTF-8", row.names = F)


########################################################
#a = generateOutlierColumn(df, getIndicadorCategoria(df,tabela.indicador))

#lista indicando se para um indicador quanto maior (MELHOR/PIOR), com base na ordem em que aparecem na lista "indicadorFiles"
indice.indicador = c("INDICADOR_1 - Cobertura Populacional estimada pelas equipes de atenção básica", "INDICADOR_2-Proporcao internacoes por condicoes sensiveis a atencao basica",
                     "INDICADOR_4-Cobertura populacional estimada pelas equipes basicas de saude bucal", "INDICADOR_7-Razao de procedimentos ambulatoriais de media complexidade e populacao residente", 
                     "INDICADOR_9-Razao de procedimentos ambulatoriais de alta complexidade e populacao residente", "INDICADOR_20-Proporcao de parto normal", 
                     "INDICADOR_21-Proporcao de nascidos vivos de maes com 7 ou mais consultas de pre-natal", "INDICADOR_35-Proporcao de vacinas do Calendario Basico de Vacinacao da Crianca com coberturas vacinais alcancadas", 
                     "INDICADOR_41-Percentual de acoes de vigilância sanitaria consideradas necessarias realizadas")

indicador.categoria = c("MELHOR", "MELHOR","MELHOR","MELHOR","MELHOR","MELHOR","MELHOR","MELHOR","MELHOR")

tabela.indicador = data.frame(indice = indice.indicador, categoria = indicador.categoria)
#############################################------/Minha parte-------#############################################


####################################################################################################################

args <- commandArgs(trailingOnly = TRUE) 
#indicador (1), tabela de desvios(2), mediana(3), desvios novos(4), mediana nova(5), caminho perl(6)

#args = c("INDICADOR_188_EXEMPLO.csv", "tabela_com_todos_os_indicadores_selecionados_e_desvios.csv", "medianas_para_todos_os_indicadores_agrupados_por_ano_e_regiao.csv", "tabela_com_todos_os_indicadores_selecionados_e_desvios.csv", "medianas_para_todos_os_indicadores_agrupados_por_ano_e_regiao.csv")



#lista indicando se para um indicador quanto maior (MELHOR/PIOR), com base na ordem em que aparecem na lista "indicadorFiles"
indice.indicador = c("INDICADOR_62", "INDICADOR_199", "INDICADOR_200", "INDICADOR_329", "INDICADOR_333", "INDICADOR_181", "INDICADOR_182", "INDICADOR_188", "INDICADOR_189", "INDICADOR_289", "INDICADOR_290", "INDICADOR_202", "INDICADOR_184", "INDICADOR_7", "INDICADOR_201")
indicador.categoria = c("MELHOR", "MELHOR", "MELHOR", "PIOR", "MELHOR", "PIOR", "PIOR", "MELHOR", "MELHOR", "MELHOR", "PIOR", "PIOR", "PIOR", "NEUTRO", "MELHOR")

tabela.indicador = data.frame(indice = indice.indicador, categoria = indicador.categoria)


#################################################
###Caminho do perl
perl.path <- args[6]

#Tabela do indicador novo
#tabela.nova <- read.xls(xls=args[1],perl=args[6])
tabela.nova <- read.csv(args[1])

#tabela do indicador antigo
tabela.default <- read.csv(args[2])

#####################################################processamento das medianas
#Tabela default da mediana
mediana_default <- read.csv(args[3])

#realizar processamento da mediana
dffinal <- processaIndicador(tabela.nova,mediana_default)

#salva data frame mediana
#con<-file(args[5],encoding="utf8")
write.csv(dffinal, args[5], row.names=F)


##############################################Processamento dos novos indicadores

#adiciona desvios na tabela
tabela.nova = generateOutlierColumn(tabela.nova, getIndicadorCategoria(tabela.nova,tabela.indicador))


tabela.final = addTabela(tabela.default,tabela.nova)

#salva data frame
#con<-file(args[4],encoding="utf8")
write.csv(tabela.final, args[4], row.names=F)