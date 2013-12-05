require("stats")

#funcoes ==================================================================================================

#calcula os p.valores do teste shapiro-wilk dos anos
p.values = function(df) {
  valores = c()
  for(i in 2:ncol(df)) {
    valor = shapiro.test(df[, i])$p.value
    valores = c(valores, valor)
  }
  return(valores)
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


#Cria imagens .png com os plots dos anos
plot.histograms.and.qq = function(df) {
  for(i in 2:ncol(df)) {
    png(paste(gsub("^X", "", names(df)[i]), ".png", ""), width = 1200, height = 640)
    par(mfrow=c(1, 2))
    hist(df[, i], main=gsub("^X", "", names(df)[i]), las=1, xlab="valores")
    abline(v=mean(df[, i], na.rm=T), col="red", lty=2)
    abline(v=median(df[, i], na.rm=T), col="blue", lty=2)
    legend("topright", inset=.04,
           c("media","mediana"), fill=c("red", "blue"), horiz=F)
    qqnorm(df[, i], las=1)
    qqline(df[, i], col="red")
    dev.off()
  }  
}

#main ======================================================================================================

d = read.csv("porcentVacinasComCoberturaAdeq.csv", header=T, sep=";", dec=",")

ano = c(gsub("^X", "", names(d)[2:(ncol(d))]))

p.value = format(p.values(d), scientific=F)
p.values.shapiro = cbind(ano, p.value)

central = calculate.central.values(df=d, significance=0.05, p.values=p.value)
central.values = cbind(ano, central)

#plot.histograms.and.qq(d)