centro = function(indicador, separador, eh.normal, arquivo.encode, nome.indicador){
  df = read.csv(file=indicador, fileEncoding=arquivo.encode, stringsAsFactors=F, header=T, sep=separador)
  #NOME_MESO  ,	NOME_MICRO, ESTADO
  df$COD_MUNICIPIO = NULL;
  df$COD_MESO = NULL;
  df$COD_MICRO = NULL;
  df$NOME_MUNICIPIO = NULL;
  df$COD_UF = NULL;
  df$NOME_UF = NULL;
  names(df)[names(df) == 'Ano'] <- 'ANO'
  #COD_MUNICIPIO  COD_MESO	NOME_MESO	COD_MICRO	NOME_MICRO	NOME_MUNICIPIO	ANO	VALOR
  
  df$Municipio = NULL;
  df$Função = NULL;
  if(eh.normal){
    centro.meso <<- aggregate(df, list(REGIAO = df$NOME_MESO, ANO = df$ANO), mean)
    centro.micro <<- aggregate(df, list(REGIAO = df$NOME_MICRO, ANO = df$ANO), mean)
    centro.estado <<- aggregate(df, list( ANO = df$ANO), mean)
  }else{
    centro.meso <<- aggregate(df, list(REGIAO = df$NOME_MESO, ANO = df$ANO), median)
    centro.micro <<- aggregate(df, list(REGIAO = df$NOME_MICRO, ANO = df$ANO), median)
    centro.estado <<- aggregate(df, list( ANO = df$ANO), median)
  }
 
  centro.estado$REGIAO = "Paraíba"
  centro.regioes = rbind(centro.meso, centro.micro, centro.estado)
  centro.regioes$NOME_MESO = NULL
  centro.regioes$NOME_MICRO = NULL
  centro.regioes$ANO = NULL
  colnames(centro.regioes)[3] <- nome.indicador
  return(centro.regioes)
}



zz= read.csv(file="data/INDICADOR_101.csv", fileEncoding="latin1", stringsAsFactors=F, header=T, sep=";")
###########################Indicadores Financeiros################################
indicador_001 = centro("data/INDICADOR_001.csv", ";", eh.normal=F, "UTF-8", "indicador_001")
indicador_002 = centro("data/INDICADOR_002.csv", ";", eh.normal=F, "UTF-8", "indicador_002")
indicador_004 = centro("data/INDICADOR_004.csv", ";", eh.normal=F, "UTF-8", "indicador_004")
indicador_007 = centro("data/INDICADOR_007.csv", ";", eh.normal=F, "UTF-8", "indicador_007")
indicador_009 = centro("data/INDICADOR_009.csv", ";", eh.normal=F, "UTF-8", "indicador_009")
indicador_020 = centro("data/INDICADOR_020.csv", ";", eh.normal=F, "UTF-8", "indicador_020")
indicador_021 = centro("data/INDICADOR_021.csv", ";", eh.normal=F, "UTF-8", "indicador_021")
indicador_035 = centro("data/INDICADOR_035.csv", ";", eh.normal=F, "UTF-8", "indicador_035")
indicador_041 = centro("data/INDICADOR_041.csv", ";", eh.normal=F, "UTF-8", "indicador_041")

indicador_101 = centro("data/INDICADOR_101.csv", ",", eh.normal=F, "UTF-8", "indicador_101")
indicador_102 = centro("data/INDICADOR_102.csv", ",", eh.normal=F, "UTF-8", "indicador_102")
indicador_103 = centro("data/INDICADOR_103.csv", ",", eh.normal=F, "UTF-8", "indicador_103")
indicador_104 = centro("data/INDICADOR_104.csv", ",", eh.normal=F, "UTF-8", "indicador_104")
indicador_105 = centro("data/INDICADOR_105.csv", ",", eh.normal=F, "UTF-8", "indicador_105")
indicador_106 = centro("data/INDICADOR_106.csv", ",", eh.normal=F, "UTF-8", "indicador_106")
indicador_107 = centro("data/INDICADOR_107.csv", ",", eh.normal=F, "UTF-8", "indicador_107")
indicador_108 = centro("data/INDICADOR_108.csv", ",", eh.normal=F, "UTF-8", "indicador_108")
indicador_109 = centro("data/INDICADOR_109.csv", ",", eh.normal=F, "UTF-8", "indicador_109")
indicador_110 = centro("data/INDICADOR_110.csv", ",", eh.normal=F, "UTF-8", "indicador_110")
indicador_111 = centro("data/INDICADOR_111.csv", ",", eh.normal=F, "UTF-8", "indicador_111")
indicador_112 = centro("data/INDICADOR_112.csv", ",", eh.normal=F, "UTF-8", "indicador_112")
indicador_113 = centro("data/INDICADOR_113.csv", ",", eh.normal=F, "UTF-8", "indicador_113")
indicador_114 = centro("data/INDICADOR_114.csv", ",", eh.normal=F, "UTF-8", "indicador_114")

indicador_201 = centro("data/INDICADOR_201.csv", ",", eh.normal=F, "UTF-8", "indicador_201")
indicador_202 = centro("data/INDICADOR_202.csv", ",", eh.normal=F, "UTF-8", "indicador_202")
indicador_203 = centro("data/INDICADOR_203.csv", ",", eh.normal=F, "UTF-8", "indicador_203")
indicador_204 = centro("data/INDICADOR_204.csv", ",", eh.normal=F, "UTF-8", "indicador_204")
indicador_205 = centro("data/INDICADOR_205.csv", ",", eh.normal=F, "UTF-8", "indicador_205")
indicador_206 = centro("data/INDICADOR_206.csv", ",", eh.normal=F, "UTF-8", "indicador_206")
indicador_207 = centro("data/INDICADOR_207.csv", ",", eh.normal=F, "UTF-8", "indicador_207")
indicador_208 = centro("data/INDICADOR_208.csv", ",", eh.normal=F, "UTF-8", "indicador_208")

############################Merge dados financeiros#############################
centro.aux = merge(merge(indicador_101, indicador_102, by = c("REGIAO", "ANO"), all = T), merge(indicador_103, indicador_104, by = c("REGIAO", "ANO"),all = T),  by = c("REGIAO", "ANO"), all = T)
centro.aux2 = merge(merge(indicador_105, indicador_106, by = c("REGIAO", "ANO"),all = T), merge(indicador_107, indicador_108, by = c("REGIAO", "ANO"), all=T),  by = c("REGIAO", "ANO"), all=T)
centro.aux3 = merge(merge(indicador_109, indicador_110, by = c("REGIAO", "ANO"), all = T), merge(indicador_111, indicador_112, by=c("REGIAO", "ANO"), all = T),by = c("REGIAO", "ANO"), all = T)
#centro.aux4 = merge(centro.aux3, gps, by= c("REGIAO", "ANO"), incomparables = NA)

centro.financeiro = merge(merge(centro.aux, centro.aux2, by = c("REGIAO", "ANO"),all = T), merge(centro.aux3, indicador_113, by = c("REGIAO", "ANO"),all = T), by = c("REGIAO", "ANO"),all = T)
centro.financeiro = merge(centro.financeiro, indicador_114, by = c("REGIAO", "ANO"),all = T)
#write.csv(centro, "centro_para_indicadores_financeiros_agrupados_por_ano_e_regiao.csv", row.names=F, fileEncoding = "UTF-8")

##########################Merge dados Saude#####################################


centro.aux = merge(merge(indicador_001, indicador_002, by = c("REGIAO", "ANO"),all = T), merge(indicador_004, indicador_007, by = c("REGIAO", "ANO"),all = T),  by = c("REGIAO", "ANO"),all = T)
centro.aux2 = merge(merge(indicador_009, indicador_020, by = c("REGIAO", "ANO"),all = T), merge(indicador_021, indicador_035, by = c("REGIAO", "ANO"),all = T),  by = c("REGIAO", "ANO"),all = T)
centro.saude = merge(merge(centro.aux, centro.aux2, by = c("REGIAO", "ANO"),all = T), indicador_041, by = c("REGIAO", "ANO"),all = T)


##########################Merge novos dados###################
centro.aux = merge(merge(indicador_201, indicador_202, by = c("REGIAO", "ANO"), all = T), merge(indicador_203, indicador_204, by = c("REGIAO", "ANO"),all = T),  by = c("REGIAO", "ANO"), all = T)
centro.aux2 = merge(merge(indicador_205, indicador_206, by = c("REGIAO", "ANO"),all = T), merge(indicador_207, indicador_208, by = c("REGIAO", "ANO"), all=T),  by = c("REGIAO", "ANO"), all=T)
centro.novos.ind = merge(centro.aux, centro.aux2, by = c("REGIAO", "ANO"),all = T)


############################Juntar tudo
todas.centro = merge(centro.saude, centro.financeiro, by=c("REGIAO", "ANO"),all = T)




write.csv(todas.centro, "atuais/centro_para_todos_indicadores_agrupados_por_ano_e_regiao.csv", row.names=F, fileEncoding = "UTF-8")