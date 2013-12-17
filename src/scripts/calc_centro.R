#!/usr/bin/Rscript

args <- commandArgs(TRUE)

file_name <- args[1]

normality_results_file_name  <- args[2]
norm_results <- read.csv(normality_results_file_name)

centro.meso <- data.frame()
centro.micro <- data.frame()
centro.estado <- data.frame()

centro = function(file_name, norm_results){

	df = read.csv(file_name)
	
	anos <- unique(df$ANO)
	
	for( ano in anos ){
		eh_normal = norm_results[norm_results$INDICADOR == colnames(df)[10] & norm_results$ANO == ano,]$NORMAL

		centro.meso <<- rbind( aggregate( df[df$ANO==ano,c(5,4,10)], list(REGIAO = df[df$ANO==ano,c(5,4,10)]$COD_MESO), if(eh_normal){ mean }else{ median } ) , centro.meso)
		centro.micro <<- rbind( aggregate( df[df$ANO==ano,c(7, 4, 10)], list(REGIAO = df[df$ANO==ano,c(7,4,10)]$COD_MICRO), if(eh_normal){ mean }else{ median }), centro.micro)
	        centro.estado <<- rbind( data.frame(REGIAO="25", ANO=ano, VALOR=if(eh_normal){mean(df[df$ANO==ano,10], na.rm=T)}else{median(df[df$ANO==ano,10], na.rm=T)}), centro.estado)
	}
  	
	centro.meso$COD_MESO <- NULL
	centro.micro$COD_MICRO <- NULL
 	colnames(centro.estado)[3] <- colnames(df)[10]
	
	centro = rbind(centro.meso, centro.micro, centro.estado)

  	colnames(centro)[3] <- colnames(df)[10]
	
	centro
}

data <- centro(file_name, norm_results)

write.csv(file=paste("CENTRO_", args[3], sep=""), data, row.names=F)
