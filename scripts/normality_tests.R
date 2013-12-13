#!/usr/bin/Rscript

args	<- commandArgs(TRUE)

require("stats")

#funcoes ==================================================================================================

#calcula os p.valores do teste shapiro-wilk dos anos
p.values = function(df, index, file_name, significance) {
  outliers = c(250750, 250400, 250630, 251080, 250370, 250970)
  df = subset(df, !df$COD_MUNICIPIO %in% outliers)
  #df = subset(df, df$COD_MUNICIPIO!=250750 & df$COD_MUNICIPIO!=250400 & df$COD_MUNICIPIO!=250630 & df$COD_MUNICIPIO!=251080 & df$COD_MUNICIPIO!=250370 & df$COD_MUNICIPIO!=250970)#jp, cg, gua, pat, caj, mont
  
	indicador_name = colnames(df)[index]
	
	sink(file=file_name, append=TRUE)
	
	anos <- unique(df$ANO)
	
	for(ano in anos){
		data <- df[df$ANO == ano,index]
		result <- shapiro.test(data)
		cat(indicador_name, ",", ano, ",",
            result$p.value >= significance, ",", result$statistic, ",", result$p.value, "\n", sep="")
	}
	sink()
}


#Cria imagens .png com histograma e qqplot para todos os anos
plot.histograms.and.qq = function(df, index) {
	
	indicador_name = colnames(df)[index]
	file_name = paste(indicador_name, ".png", sep="")
	png(filename=file_name, height=2000, width=800)
	
	anos <- unique(df$ANO)
	
	par(mfrow=c(length(anos),2))
	
	for(ano in anos){
		data <- df[df$ANO == ano,index]
		hist(data, main=ano, las=1, xlab=indicador_name)
    	abline(v=mean(data, na.rm=T), col="red", lty=2)
    	abline(v=median(data, na.rm=T), col="blue", lty=2)
    	legend("topright", inset=.04, c("media","mediana"), fill=c("red", "blue"), horiz=F)
        
    	qqnorm(data, las=1)
    	qqline(data, col="red")
	}
	
	dev.off()
}

#main ======================================================================================================

file_name	<- args[1]
output_file_name <- args[2]

d = read.csv(file_name)

index = 10
significance=0.05

plot.histograms.and.qq(d, index)
p.values(d, index, output_file_name, significance)
