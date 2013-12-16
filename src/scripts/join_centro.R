#!/usr/bin/Rscript

args	<- commandArgs(TRUE)

output_name	<- args[1]

input_name <- args[2]

data <- read.csv(output_name)

new_data <- read.csv(input_name)

data <- merge(data, new_data, by.x=c("REGIAO", "ANO"), by.y=c("REGIAO", "ANO"), all=TRUE)

write.csv(file=output_name, data, row.names=FALSE)
