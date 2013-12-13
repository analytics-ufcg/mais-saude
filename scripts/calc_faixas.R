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
        results = c( min(data), results, max(data) );
    }else{
        results = quantile(data, c(0.001, 0.022, 0.158, 0.5, 0.842, 0.978, 0.999));
        results = c( min(data), results, max(data) );
        
        #print(results)
        
        #parte que remove as fronteiras repetidas
        valores = as.vector(results)
        count = 1
        while(count!=9){
          valor_atual = valores[count]
          
          #percorre o vetor e conta as ocorrencias
          posicao_atual = count + 1
          ocorrencia = 1
          while(posicao_atual!=9){
            if(isTRUE(as.numeric(valor_atual)==as.numeric(valores[posicao_atual]))){
              posicao_atual = posicao_atual + 1
              ocorrencia = ocorrencia + 1
            }else{
             break
            }
          }
          
          #calcula a nova fronteira
          if(isTRUE( ocorrencia > 1 & posicao_atual > 8)){
            segundo_maior = max(data[data < max(data)])
            new_bound = (valor_atual - segundo_maior)/ocorrencia
            posicao = 0
            for(i in count:8){
              results[i] = (segundo_maior) + (posicao*new_bound)
              posicao = posicao + 1
            }
            break
          }else if(isTRUE( ocorrencia > 1 & posicao_atual < 8)){
            segundo_menor = min(data[data > min(data)])
            new_bound = (segundo_menor -valor_atual)/ocorrencia
            posicao = 0
            for(i in count:(posicao_atual-1)){
              results[i] = valor_atual + (posicao*new_bound)
              posicao = posicao + 1
            }
          }
          count = posicao_atual
        } 
  }
    return (results)
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


