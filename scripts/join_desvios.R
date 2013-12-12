#!/usr/bin/RScript

args	<- commandArgs(TRUE)

output_name	<- args[1]

input_name <- args[2]

data <- read.csv(output_name)

new_data <- read.csv(input_name)

data <- rbind(data, new_data)

write.csv(file=output_name, data, row.names=FALSE)
