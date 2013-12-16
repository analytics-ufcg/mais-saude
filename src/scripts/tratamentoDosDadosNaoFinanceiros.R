require(stringr)

args = commandArgs(T)

file.name = args[1]
indicador = args[2]

d = read.csv(file.name, header=T, sep=";", dec=",", stringsAsFactors=F,
             encoding="UTF-8")
colnames(d) = c("Municipio", names(d[2:(ncol(d))]))

d2 = read.csv("tabela_com_todos_os_indicadores_selecionados_e_desvios.csv", stringsAsFactors=F,
              encoding="UTF-8")
d2 = d2[1:9]
d2$COD_MUNICIPIO = substr(d2$COD_MUNICIPIO, 1, 6)

ANO = rep(gsub("^X", "", names(d)[2:(ncol(d) - 1)]), 223)
ANO = ANO[order(ANO, decreasing = F)]

VALOR = unlist(rep(d[, 2:(ncol(d) - 1)], 1))

split.municipio = data.frame(do.call('rbind', 
                                     str_split(as.character(d$Municipio), " ", 2)))

colnames(split.municipio) = c("COD_MUNICIPIO", "NOME_MUNICIPIO")

result = as.data.frame(cbind(split.municipio, ANO, VALOR))

merge = merge(d2, result, by=c("COD_MUNICIPIO", "NOME_MUNICIPIO", "ANO"), all.y=T)#[, c(1:7, 9)]

merge = merge[, c(names(d2), names(merge)[ncol(merge)])]
colnames(merge) = c(names(d2), indicador)
write.csv(file=paste(args[2], ".csv", sep=""), x=merge, fileEncoding="UTF-8", row.names=F)

rm(list=ls())