#!/usr/bin/Rscript

args	<- commandArgs(TRUE)

output_name	<- args[1]

input_name <- args[2]

data <- read.csv(output_name)

new_data <- read.csv(input_name)

data <- merge(data, new_data, by.x=c("COD_UF","NOME_UF","COD_MUNICIPIO","ANO","COD_MESO","NOME_MESO","COD_MICRO","NOME_MICRO","NOME_MUNICIPIO"), by.y=c("COD_UF","NOME_UF","COD_MUNICIPIO","ANO","COD_MESO","NOME_MESO","COD_MICRO","NOME_MICRO","NOME_MUNICIPIO"), all.x=TRUE, all.y=TRUE)

head(data, 1)

write.csv(file=output_name, data, row.names=FALSE)
