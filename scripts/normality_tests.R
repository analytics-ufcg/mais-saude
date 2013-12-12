#!/usr/bin/RScript

args	<- commandArgs(TRUE)

require("stats")

#funcoes ==================================================================================================

#calcula os p.valores do teste shapiro-wilk dos anos
p.values = function(df, index, file_name) {

	indicador_name = colnames(df)[index]
	
	sink(file=file_name, append=TRUE)
	
	anos <- unique(df$ANO)
	
	for(ano in anos){
		data <- df[df$ANO == ano,index]
		result <- shapiro.test(data)
		cat("ANO = ", ano, "\n")
		cat("W = ", result$statistic, "\n")
		cat("p.value = ", result$p.value, "\n\n")
	}
	sink()
}

#calcula as medidas de tendencias centrais. se os dados forem normais, calcula a media,
#caso contrario, calcula a mediana de cada ano
calculate.central.values = function(df, significance=0.05, p.values) {
  valores = c()
  for(i in 2:ncol(df)) {
    p.valor = p.values[i - 1]
    if(p.valor < significance) {
      valores = c(valores, median(df[, i], na.rm=T))
    } else {
      valores = c(valores, mean(df[, i], na.rm=T))
    }
  }
  return(valores)
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

d = read.csv(file_name)

index = 10

plot.histograms.and.qq(d, index)
p.values(d, index, args[2])
