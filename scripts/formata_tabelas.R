#Script que formata todos os indicadores pra mesma formatacao, a padrao utilizada na versao do mais edu

base = read.csv("base_tabela.csv")

indicador = read.csv("INDICADOR_101.csv", sep = ";")

colnames(indicador) = c("COD_MUNICIPIO","COD_MESO","NOME_MESO","COD_MICRO","NOME_MICRO","NOME_MUNICIPIO","ANO","INDICADOR_101")
indicador = merge(base, indicador, by = c("COD_MUNICIPIO","ANO"), all = T)

indicador = indicador[c("COD_UF","NOME_UF","COD_MUNICIPIO","ANO","COD_MESO.x","NOME_MESO.x","COD_MICRO.x","NOME_MICRO.x","NOME_MUNICIPIO.x","INDICADOR_101","COD_MESO.y","NOME_MESO.y","COD_MICRO.y","NOME_MICRO.y","NOME_MUNICIPIO.y")]  
indicador = indicador[ ,1:10]
nrow(indicador)
colnames(indicador) = c("COD_UF","NOME_UF","COD_MUNICIPIO","ANO","COD_MESO","NOME_MESO","COD_MICRO","NOME_MICRO","NOME_MUNICIPIO","INDICADOR_101")
write.csv(indicador, "INDICADOR_101.csv", row.names = F)

##### 102
indicador = read.csv("INDICADOR_102.csv", sep = ",")
indicador[1,]

colnames(indicador) = c("COD_MUNICIPIO","NOME_MUNICIPIO","ANO","CATEGORIA","VALOR","POP","INDICADOR_102")
indicador = merge(base, indicador, by = c("COD_MUNICIPIO","ANO"), all = T)
indicador = indicador[c("COD_UF","NOME_UF","COD_MUNICIPIO","ANO","COD_MESO","NOME_MESO","COD_MICRO","NOME_MICRO","NOME_MUNICIPIO.x","INDICADOR_102","NOME_MUNICIPIO.y","CATEGORIA","VALOR","POP")]  
indicador = indicador[ ,1:10]
nrow(indicador)
colnames(indicador) = c("COD_UF","NOME_UF","COD_MUNICIPIO","ANO","COD_MESO","NOME_MESO","COD_MICRO","NOME_MICRO","NOME_MUNICIPIO","INDICADOR_102")
write.csv(indicador, "INDICADOR_102.csv", row.names = F)

##### indicador 103
indicador = read.csv("INDICADOR_103.csv", sep = ",", fileEncoding = "latin1")
indicador[1,]

colnames(indicador) = c("COD_MUNICIPIO","COD_MESO","NOME_MESO","COD_MICRO","NOME_MICRO","NOME_MUNICIPIO","ANO","INDICADOR_103")
indicador = merge(base, indicador, by = c("COD_MUNICIPIO","ANO"), all = T)
indicador = indicador[c("COD_UF","NOME_UF","COD_MUNICIPIO","ANO","COD_MESO.x","NOME_MESO.x","COD_MICRO.x","NOME_MICRO.x","NOME_MUNICIPIO.x","INDICADOR_103","COD_MESO.y","NOME_MESO.y","COD_MICRO.y","NOME_MICRO.y","NOME_MUNICIPIO.y")]  
indicador = indicador[ ,1:10]
nrow(indicador)
colnames(indicador) = c("COD_UF","NOME_UF","COD_MUNICIPIO","ANO","COD_MESO","NOME_MESO","COD_MICRO","NOME_MICRO","NOME_MUNICIPIO","INDICADOR_103")
write.csv(indicador, "INDICADOR_103.csv", row.names = F)

##### indicador 104
indicador = read.csv("INDICADOR_104.csv", sep = ";")
indicador[1,]

colnames(indicador) = c("COD_MUNICIPIO","ANO","MUNICIPIO","INDICADOR_104")
indicador = merge(base, indicador, by = c("COD_MUNICIPIO","ANO"), all = T)
indicador = indicador[c("COD_UF","NOME_UF","COD_MUNICIPIO","ANO","COD_MESO","NOME_MESO","COD_MICRO","NOME_MICRO","NOME_MUNICIPIO","INDICADOR_104","MUNICIPIO")]  
indicador = indicador[ ,1:10]
nrow(indicador)
colnames(indicador) = c("COD_UF","NOME_UF","COD_MUNICIPIO","ANO","COD_MESO","NOME_MESO","COD_MICRO","NOME_MICRO","NOME_MUNICIPIO","INDICADOR_104")
write.csv(indicador, "INDICADOR_104.csv", row.names = F)

##### indicador 105
indicador = read.csv("INDICADOR_105.csv", sep = ",")
indicador[1,]

colnames(indicador) = c("COD_MUNICIPIO","COD_MESO","NOME_MESO","COD_MICRO","NOME_MICRO","NOME_MUNICIPIO","ANO","INDICADOR_105")
indicador = merge(base, indicador, by = c("COD_MUNICIPIO","ANO"), all = T)
indicador = indicador[c("COD_UF","NOME_UF","COD_MUNICIPIO","ANO","COD_MESO.x","NOME_MESO.x","COD_MICRO.x","NOME_MICRO.x","NOME_MUNICIPIO.x","INDICADOR_105","COD_MESO.y","NOME_MESO.y","COD_MICRO.y","NOME_MICRO.y","NOME_MUNICIPIO.y")]  
indicador = indicador[ ,1:10]
nrow(indicador)
colnames(indicador) = c("COD_UF","NOME_UF","COD_MUNICIPIO","ANO","COD_MESO","NOME_MESO","COD_MICRO","NOME_MICRO","NOME_MUNICIPIO","INDICADOR_105")
write.csv(indicador, "INDICADOR_105.csv", row.names = F)

##### indicador 106
indicador = read.csv("INDICADOR_106.csv", sep = ",")

indicador[1,]

colnames(indicador) = c("COD_MUNICIPIO","COD_MESO","NOME_MESO","COD_MICRO","NOME_MICRO","NOME_MUNICIPIO","ANO","INDICADOR_106")
indicador = merge(base, indicador, by = c("COD_MUNICIPIO","ANO"), all = T)
indicador = indicador[c("COD_UF","NOME_UF","COD_MUNICIPIO","ANO","COD_MESO.x","NOME_MESO.x","COD_MICRO.x","NOME_MICRO.x","NOME_MUNICIPIO.x","INDICADOR_106","COD_MESO.y","NOME_MESO.y","COD_MICRO.y","NOME_MICRO.y","NOME_MUNICIPIO.y")]  
indicador = indicador[ ,1:10]
nrow(indicador)
colnames(indicador) = c("COD_UF","NOME_UF","COD_MUNICIPIO","ANO","COD_MESO","NOME_MESO","COD_MICRO","NOME_MICRO","NOME_MUNICIPIO","INDICADOR_106")
write.csv(indicador, "INDICADOR_106.csv", row.names = F)

##### indicador 107
indicador = read.csv("INDICADOR_107.csv", sep = ",")
indicador[1,]

colnames(indicador) = c("COD_MUNICIPIO","COD_MESO","NOME_MESO","COD_MICRO","NOME_MICRO","NOME_MUNICIPIO","ANO","INDICADOR_107")
indicador = merge(base, indicador, by = c("COD_MUNICIPIO","ANO"), all = T)
indicador = indicador[c("COD_UF","NOME_UF","COD_MUNICIPIO","ANO","COD_MESO.x","NOME_MESO.x","COD_MICRO.x","NOME_MICRO.x","NOME_MUNICIPIO.x","INDICADOR_107","COD_MESO.y","NOME_MESO.y","COD_MICRO.y","NOME_MICRO.y","NOME_MUNICIPIO.y")]  
indicador = indicador[ ,1:10]
nrow(indicador)
colnames(indicador) = c("COD_UF","NOME_UF","COD_MUNICIPIO","ANO","COD_MESO","NOME_MESO","COD_MICRO","NOME_MICRO","NOME_MUNICIPIO","INDICADOR_107")
write.csv(indicador, "INDICADOR_107.csv", row.names = F)

##### indicador 108
indicador = read.csv("INDICADOR_108.csv", sep = ",")
indicador[1:6,]

colnames(indicador) = c("COD_MUNICIPIO","COD_MESO","NOME_MESO","COD_MICRO","NOME_MICRO","NOME_MUNICIPIO","ANO","INDICADOR_108")
indicador = merge(base, indicador, by = c("COD_MUNICIPIO","ANO"), all = T)
indicador = indicador[c("COD_UF","NOME_UF","COD_MUNICIPIO","ANO","COD_MESO.x","NOME_MESO.x","COD_MICRO.x","NOME_MICRO.x","NOME_MUNICIPIO.x","INDICADOR_108","COD_MESO.y","NOME_MESO.y","COD_MICRO.y","NOME_MICRO.y","NOME_MUNICIPIO.y")]  
indicador = indicador[ ,1:10]
nrow(indicador)
colnames(indicador) = c("COD_UF","NOME_UF","COD_MUNICIPIO","ANO","COD_MESO","NOME_MESO","COD_MICRO","NOME_MICRO","NOME_MUNICIPIO","INDICADOR_108")
write.csv(indicador, "INDICADOR_108.csv", row.names = F)

##### indicador 109
indicador = read.csv("INDICADOR_109.csv", sep = ",")
indicador[1,]

colnames(indicador) = c("COD_MUNICIPIO","COD_MESO","NOME_MESO","COD_MICRO","NOME_MICRO","NOME_MUNICIPIO","ANO","INDICADOR_109")
indicador = merge(base, indicador, by = c("COD_MUNICIPIO","ANO"), all = T)
indicador = indicador[c("COD_UF","NOME_UF","COD_MUNICIPIO","ANO","COD_MESO.x","NOME_MESO.x","COD_MICRO.x","NOME_MICRO.x","NOME_MUNICIPIO.x","INDICADOR_109","COD_MESO.y","NOME_MESO.y","COD_MICRO.y","NOME_MICRO.y","NOME_MUNICIPIO.y")]  
indicador = indicador[ ,1:10]
nrow(indicador)
colnames(indicador) = c("COD_UF","NOME_UF","COD_MUNICIPIO","ANO","COD_MESO","NOME_MESO","COD_MICRO","NOME_MICRO","NOME_MUNICIPIO","INDICADOR_109")
write.csv(indicador, "INDICADOR_109.csv", row.names = F)

##### indicador 110
indicador = read.csv("INDICADOR_110.csv", sep = ",")
indicador[1,]
nrow(indicador)

colnames(indicador) = c("COD_MUNICIPIO","NOME_MUNICIPIO","ANO","INDICADOR_110")
indicador = merge(base, indicador, by = c("COD_MUNICIPIO","ANO"), all = T)

indicador = indicador[c("COD_UF","NOME_UF","COD_MUNICIPIO","ANO","COD_MESO","NOME_MESO","COD_MICRO","NOME_MICRO","NOME_MUNICIPIO.x","INDICADOR_110","NOME_MUNICIPIO.y")]  
indicador = indicador[ ,1:10]
nrow(indicador)
colnames(indicador) = c("COD_UF","NOME_UF","COD_MUNICIPIO","ANO","COD_MESO","NOME_MESO","COD_MICRO","NOME_MICRO","NOME_MUNICIPIO","INDICADOR_110")
write.csv(indicador, "INDICADOR_110.csv", row.names = F)


##### indicador 111
indicador = read.csv("INDICADOR_111.csv", sep = ",")
indicador[1,]

colnames(indicador) = c("COD_MUNICIPIO","COD_MESO","NOME_MESO","COD_MICRO","NOME_MICRO","NOME_MUNICIPIO","ANO","INDICADOR_111")
indicador = merge(base, indicador, by = c("COD_MUNICIPIO","ANO"), all = T)
indicador = indicador[c("COD_UF","NOME_UF","COD_MUNICIPIO","ANO","COD_MESO.x","NOME_MESO.x","COD_MICRO.x","NOME_MICRO.x","NOME_MUNICIPIO.x","INDICADOR_111","COD_MESO.y","NOME_MESO.y","COD_MICRO.y","NOME_MICRO.y","NOME_MUNICIPIO.y")]  
indicador = indicador[ ,1:10]
nrow(indicador)
colnames(indicador) = c("COD_UF","NOME_UF","COD_MUNICIPIO","ANO","COD_MESO","NOME_MESO","COD_MICRO","NOME_MICRO","NOME_MUNICIPIO","INDICADOR_111")
write.csv(indicador, "INDICADOR_111.csv", row.names = F)

##### indicador 112
indicador = read.csv("INDICADOR_112.csv", sep = ",")
indicador[1,]

colnames(indicador) = c("COD_MUNICIPIO","COD_MESO","NOME_MESO","COD_MICRO","NOME_MICRO","NOME_MUNICIPIO","ANO","INDICADOR_112")
indicador = merge(base, indicador, by = c("COD_MUNICIPIO","ANO"), all = T)
indicador = indicador[c("COD_UF","NOME_UF","COD_MUNICIPIO","ANO","COD_MESO.x","NOME_MESO.x","COD_MICRO.x","NOME_MICRO.x","NOME_MUNICIPIO.x","INDICADOR_112","COD_MESO.y","NOME_MESO.y","COD_MICRO.y","NOME_MICRO.y","NOME_MUNICIPIO.y")]  
indicador = indicador[ ,1:10]
nrow(indicador)
colnames(indicador) = c("COD_UF","NOME_UF","COD_MUNICIPIO","ANO","COD_MESO","NOME_MESO","COD_MICRO","NOME_MICRO","NOME_MUNICIPIO","INDICADOR_112")
write.csv(indicador, "INDICADOR_112.csv", row.names = F)

##### indicador 113
indicador = read.csv("INDICADOR_113.csv", sep = ",")
indicador[1,]

colnames(indicador) = c("COD_MUNICIPIO","COD_MESO","NOME_MESO","COD_MICRO","NOME_MICRO","NOME_MUNICIPIO","ANO","INDICADOR_113")
indicador = merge(base, indicador, by = c("COD_MUNICIPIO","ANO"), all = T)
indicador = indicador[c("COD_UF","NOME_UF","COD_MUNICIPIO","ANO","COD_MESO.x","NOME_MESO.x","COD_MICRO.x","NOME_MICRO.x","NOME_MUNICIPIO.x","INDICADOR_113","COD_MESO.y","NOME_MESO.y","COD_MICRO.y","NOME_MICRO.y","NOME_MUNICIPIO.y")]  
indicador = indicador[ ,1:10]
nrow(indicador)
colnames(indicador) = c("COD_UF","NOME_UF","COD_MUNICIPIO","ANO","COD_MESO","NOME_MESO","COD_MICRO","NOME_MICRO","NOME_MUNICIPIO","INDICADOR_113")
write.csv(indicador, "INDICADOR_113.csv", row.names = F)

##### indicador 114
indicador = read.csv("INDICADOR_114.csv", sep = ",")
indicador[1,]

colnames(indicador) = c("COD_MUNICIPIO","COD_MESO","NOME_MESO","COD_MICRO","NOME_MICRO","NOME_MUNICIPIO","ANO","INDICADOR_114")
indicador = merge(base, indicador, by = c("COD_MUNICIPIO","ANO"), all = T)
indicador = indicador[c("COD_UF","NOME_UF","COD_MUNICIPIO","ANO","COD_MESO.x","NOME_MESO.x","COD_MICRO.x","NOME_MICRO.x","NOME_MUNICIPIO.x","INDICADOR_114","COD_MESO.y","NOME_MESO.y","COD_MICRO.y","NOME_MICRO.y","NOME_MUNICIPIO.y")]  
indicador = indicador[ ,1:10]
nrow(indicador)
colnames(indicador) = c("COD_UF","NOME_UF","COD_MUNICIPIO","ANO","COD_MESO","NOME_MESO","COD_MICRO","NOME_MICRO","NOME_MUNICIPIO","INDICADOR_114")
write.csv(indicador, "INDICADOR_114.csv", row.names = F)