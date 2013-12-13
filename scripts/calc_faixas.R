#!/usr/bin/Rscript

args	<- commandArgs(TRUE)

require("stats")

file_name	<- args[1]
index_ano = 4
index_indicador = 10

normality_results_file_name  <- args[2]
norm_results <- read.csv(normality_results_file_name)

name <- args[3]

outliers <- c(250750, 250400)

data = read.csv(file_name)

anos <- unique(data$ANO)

calc_bounds <- function(data, is_normal){
    if(is_normal){
        m <- mean(data)
        s <- sd(data)
        results = c(m-3*s, m-2*s, m-1*s, m, m+1*s, m+2*s, m+3*s)
    }else{
        results = quantile(data, c(0.001, 0.022, 0.158, 0.5, 0.842, 0.978, 0.999));
    }
    c( min(data), results, max(data) );
}

for(ano in anos){
    current_data <- data[data$ANO == ano,]
    
    current_data_without_outliers = subset(current_data, !current_data$COD_MUNICIPIO %in% outliers)
    current_data_outliers = subset(current_data, current_data$COD_MUNICIPIO %in% outliers)
    
    bounds <- calc_bounds(current_data_without_outliers[,index_indicador],
        norm_results[norm_results$INDICADOR == colnames(data)[index_indicador] & norm_results$ANO == ano,]$NORMAL
    );
    
    
    if(exists("output")){
        tmp <- data.frame(t(c(colnames(data)[index_indicador], ano, bounds)))
        colnames(tmp) <- c("indicador","ano","min","q4neg","q3neg","q2neg","q0","q2","q3","q4","max")
        output <- rbind(output, tmp)
    }else{
        output <- data.frame(t(c(colnames(data)[index_indicador], ano, bounds)))
        colnames(output) <- c("indicador","ano","min","q4neg","q3neg","q2neg","q0","q2","q3","q4","max")
    }
    
    
    
    
}
write.csv(file=paste("DESVIOS_", name, sep=""), output, row.names=FALSE)


