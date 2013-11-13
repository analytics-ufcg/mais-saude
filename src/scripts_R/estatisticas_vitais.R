est.vitais.2007 = read.csv("Estatisticas Vitais/Nascidos Vivos/2007.csv", header=F, sep=";")
est.vitais.2008 = read.csv("Estatisticas Vitais/Nascidos Vivos/2008.csv", header=F, sep=";")
est.vitais.2009 = read.csv("Estatisticas Vitais/Nascidos Vivos/2009.csv", header=F, sep=";")
est.vitais.2010 = read.csv("Estatisticas Vitais/Nascidos Vivos/2010.csv", header=F, sep=";")
est.vitais.2011 = read.csv("Estatisticas Vitais/Nascidos Vivos/2011.csv", header=F, sep=";")


est.vitais.2007$V1 = NULL
est.vitais.2007=data.frame(as.numeric(as.character(est.vitais.2007$V2[1:225])), as.numeric(as.character(est.vitais.2007$V3[1:225])) )
#est.vitais.2007$V3 = as.numeric(as.character(est.vitais.2007$V3[1:225]))
colnames(est.vitais.2007) <- c("Nascim_p.resid.mae","Nascim_p.ocorrenc")

est.vitais.2008$V1 = NULL
est.vitais.2008=data.frame(as.numeric(as.character(est.vitais.2008$V2[1:225])), as.numeric(as.character(est.vitais.2008$V3[1:225])) )
colnames(est.vitais.2008) <- c("Nascim_p.resid.mae","Nascim_p.ocorrenc")


#est.vitais.2007 = as.data.frame(est.vitais.2007)
#est.vitais.2008 = as.data.frame(est.vitais.2008)



est.vitais.2009$V1 = NULL
est.vitais.2009=data.frame(as.numeric(as.character(est.vitais.2009$V2[1:225])), as.numeric(as.character(est.vitais.2009$V3[1:225])) )
colnames(est.vitais.2009) <- c("Nascim_p.resid.mae","Nascim_p.ocorrenc")

est.vitais.2010$V1 = NULL
est.vitais.2010=data.frame(as.numeric(as.character(est.vitais.2010$V2[1:225])), as.numeric(as.character(est.vitais.2010$V3[1:225])) )
colnames(est.vitais.2010) <- c("Nascim_p.resid.mae","Nascim_p.ocorrenc")

est.vitais.2011$V1 = NULL
est.vitais.2011=data.frame(as.numeric(as.character(est.vitais.2011$V2[1:225])), as.numeric(as.character(est.vitais.2011$V3[1:225])) )
colnames(est.vitais.2011) <- c("Nascim_p.resid.mae","Nascim_p.ocorrenc")



todos = rbind(est.vitais.2007, est.vitais.2008, est.vitais.2009, est.vitais.2010, est.vitais.2011)


est.vitais.resid = list(r2007 = est.vitais.2007$Nascim_p.resid.mae, r2008 = est.vitais.2008$Nascim_p.resid.mae,
                        r2009 = est.vitais.2009$Nascim_p.resid.mae, r2010 = est.vitais.2010$Nascim_p.resid.mae,
                        r2011 = est.vitais.2011$Nascim_p.resid.mae, geral = todos$Nascim_p.resid.mae)

est.vitais.ocorr = list(r2007 = est.vitais.2007$Nascim_p.ocorrenc, r2008 = est.vitais.2008$Nascim_p.ocorrenc,
                        r2009 = est.vitais.2009$Nascim_p.ocorrenc, r2010 = est.vitais.2010$Nascim_p.ocorrenc,
                        r2011 = est.vitais.2011$Nascim_p.ocorrenc, geral = todos$Nascim_p.ocorrenc)




boxplot(est.vitais.resid, outline=F, main = "Nascimento por residência da mãe(sem outliers)")
boxplot(est.vitais.resid, main = "Nascimento por residência da mãe")

boxplot(est.vitais.ocorr, outline=F, main = "Nascimento por ocorrência(sem outliers)")
boxplot(est.vitais.ocorr, main = "Nascimento por ocorrência")

par(mfrow=c(3,2))

#residencia da mae
qqnorm(est.vitais.2007$Nascim_p.resid.mae, main = "Nascimento por residência da mãe - 2007")
qqnorm(est.vitais.2008$Nascim_p.resid.mae, main = "Nascimento por residência da mãe - 2008")
qqnorm(est.vitais.2009$Nascim_p.resid.mae, main = "Nascimento por residência da mãe - 2009")
qqnorm(est.vitais.2010$Nascim_p.resid.mae, main = "Nascimento por residência da mãe - 2010")
qqnorm(est.vitais.2011$Nascim_p.resid.mae, main = "Nascimento por residência da mãe - 2011")
qqnorm(todos$Nascim_p.resid.mae, main = "Nascimento por residência da mãe - geral")

#ocorrencia
qqnorm(est.vitais.2007$Nascim_p.ocorrenc, main = "Nascimento por ocorrência - 2007")
qqnorm(est.vitais.2008$Nascim_p.ocorrenc, main = "Nascimento por ocorrência - 2008")
qqnorm(est.vitais.2009$Nascim_p.ocorrenc, main = "Nascimento por ocorrência - 2009")
qqnorm(est.vitais.2010$Nascim_p.ocorrenc, main = "Nascimento por ocorrência - 2010")
qqnorm(est.vitais.2011$Nascim_p.ocorrenc, main = "Nascimento por ocorrência - 2011")
qqnorm(todos$Nascim_p.ocorrenc, main = "Nascimento por ocorrência - geral")





#####################################################################

ob.causas.ext.2007 = read.csv("Estatisticas Vitais/Mortalidade, 1996 a 2011, pela CID-10/Obitos por causas externas/2007.csv", header=F, sep=";")
ob.causas.ext.2008 = read.csv("Estatisticas Vitais/Mortalidade, 1996 a 2011, pela CID-10/Obitos por causas externas/2008.csv", header=F, sep=";")
ob.causas.ext.2009 = read.csv("Estatisticas Vitais/Mortalidade, 1996 a 2011, pela CID-10/Obitos por causas externas/2009.csv", header=F, sep=";")
ob.causas.ext.2010 = read.csv("Estatisticas Vitais/Mortalidade, 1996 a 2011, pela CID-10/Obitos por causas externas/2010.csv", header=F, sep=";")
ob.causas.ext.2011 = read.csv("Estatisticas Vitais/Mortalidade, 1996 a 2011, pela CID-10/Obitos por causas externas/2011.csv", header=F, sep=";")



formatar.df <- function(df, col1, col2){
  df$V1 = NULL
  df=data.frame(as.numeric(as.character(df$V2[1:225])), as.numeric(as.character(df$V3[1:225])) )
  #df$V3 = as.numeric(as.character(df$V3[1:225]))
  colnames(df) <- c(col1,col2)
  return(df)
}

ob.causas.ext.2007 = formatar.df(ob.causas.ext.2007, "Obitos_p.Residenc","Obitos_p.Ocorrenc")
ob.causas.ext.2008 = formatar.df(ob.causas.ext.2008, "Obitos_p.Residenc","Obitos_p.Ocorrenc")
ob.causas.ext.2009 = formatar.df(ob.causas.ext.2009, "Obitos_p.Residenc","Obitos_p.Ocorrenc")
ob.causas.ext.2010 = formatar.df(ob.causas.ext.2010, "Obitos_p.Residenc","Obitos_p.Ocorrenc")
ob.causas.ext.2011 = formatar.df(ob.causas.ext.2011, "Obitos_p.Residenc","Obitos_p.Ocorrenc")

todos = rbind(ob.causas.ext.2007, ob.causas.ext.2008, ob.causas.ext.2009, ob.causas.ext.2010, ob.causas.ext.2011)


ob.causas.ext.resid = list(r2007 = ob.causas.ext.2007$Obitos_p.Residenc, r2008 = ob.causas.ext.2008$Obitos_p.Residenc,
                        r2009 = ob.causas.ext.2009$Obitos_p.Residenc, r2010 = ob.causas.ext.2010$Obitos_p.Residenc,
                        r2011 = ob.causas.ext.2011$Obitos_p.Residenc, geral = todos$Obitos_p.Residenc)

ob.causas.ext.ocorr = list(r2007 = ob.causas.ext.2007$Obitos_p.Ocorrenc, r2008 = ob.causas.ext.2008$Obitos_p.Ocorrenc,
                        r2009 = ob.causas.ext.2009$Obitos_p.Ocorrenc, r2010 = ob.causas.ext.2010$Obitos_p.Ocorrenc,
                        r2011 = ob.causas.ext.2011$Obitos_p.Ocorrenc, geral = todos$Obitos_p.Ocorrenc)

boxplot(ob.causas.ext.resid, outline=F, main = "Óbitos por residência(sem outliers)")
boxplot(ob.causas.ext.resid, main = "Óbitos por residência")

boxplot(ob.causas.ext.ocorr, outline=F, main = "Óbitos por ocorrência(sem outliers)")
boxplot(ob.causas.ext.ocorr, main = "Óbitos por ocorrência")

par(mfrow=c(3,2))

#residencia da mae
qqnorm(ob.causas.ext.2007$Obitos_p.Residenc, main = "Óbitos por residência - 2007")
qqnorm(ob.causas.ext.2008$Obitos_p.Residenc, main = "Óbitos por residência - 2008")
qqnorm(ob.causas.ext.2009$Obitos_p.Residenc, main = "Óbitos por residência - 2009")
qqnorm(ob.causas.ext.2010$Obitos_p.Residenc, main = "Óbitos por residência - 2010")
qqnorm(ob.causas.ext.2011$Obitos_p.Residenc, main = "Óbitos por residência - 2011")
qqnorm(todos$Obitos_p.Residenc, main = "Óbitos por residência - geral")

#ocorrencia
qqnorm(ob.causas.ext.2007$Obitos_p.Ocorrenc, main = "Óbitos por ocorrência - 2007")
qqnorm(ob.causas.ext.2008$Obitos_p.Ocorrenc, main = "Óbitos por ocorrência - 2008")
qqnorm(ob.causas.ext.2009$Obitos_p.Ocorrenc, main = "Óbitos por ocorrência - 2009")
qqnorm(ob.causas.ext.2010$Obitos_p.Ocorrenc, main = "Óbitos por ocorrência - 2010")
qqnorm(ob.causas.ext.2011$Obitos_p.Ocorrenc, main = "Óbitos por ocorrência - 2011")
qqnorm(todos$Obitos_p.Ocorrenc, main = "Óbitos por ocorrência - geral")

####################################


a <- formatar.df(ob.causas.ext.2007, "Obitos_p.Residenc", "Obitos_p.Ocorrenc")
