#!/usr/bin/RScript

args	<- commandArgs(TRUE)

require("stats")

file_name	<- args[1]
index_ano = 4
index_indicador = 10

normality_results_file_name  <- args[2]
norm_results <- read.csv(normality_results_file_name)

gerarIntervalos(file_name, F, T, F, "UTF-8", ";", index_indicador, index_ano, "MELHOR", norm_results)

data = read.csv(file_name)

indicador_01 = gerarIntervalos("data/INDICADOR_001.csv", F, T, F, "UTF-8", ";", 8, 2, "MELHOR", eh.normal=c(F,F,F,F,F,F), "indicador_001")

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

