# ----------- Bibliotecas INICIO
# Para gráficos
if(!require(ggplot2)){
  install.packages("ggplot2")
}
library(ggplot2)

#Para manipulação dos dados
if(!require(dplyr)){
  install.packages("dplyr")
}
library(dplyr)

# Utilizada para criar as partições de treino e teste
if(!require(caret)){  
  install.packages("caret")
}
library(caret)

# Aprendizado de Máquina
if(!require(mlbench)){
  install.packages("mlbench")
}
library(mlbench)

# Árvore de decisão
if(!require(C50)){  
  install.packages("C50")
}
library(C50)

# Random - Floresta de Classificação
if(!require(randomForest)){
  install.packages("randomForest")
}
library(randomForest)
# ----------- Bibliotecas  FIM

relabel_ano <- function(x){
  ifelse(x >= 2009 && x <2013, 2009, 2013)
}

tre_sagres_jul <- read.csv('../../data/TRE_Sagres_Resp_Eleito.csv')
tre_sagres_n_jul <- read.csv('../../data/TRE_Sagres_Eleit_Idon.csv')

tre_sagres_jul$class <- "Julgados"
tre_sagres_n_jul$class <- "Não julgados"


tre_sagres_jul <- select(tre_sagres_jul,-DECISÃO, -RES..DECISÃO.PODER.LEGISLATIVO, -ITEM, -PROCESSO, -SUBCATEGORIA, -RESPONSÁVEL, -CPF)
tre_sagres <- rbind(tre_sagres_jul, tre_sagres_n_jul)

ugestora <- read.csv('../../data/codigo_ugestora.csv', encoding = "UTF-8")
contrato <- read.csv('../../data/contratos.csv', encoding = "UTF-8")


licitacoes <- subset(contrato, tp_Licitacao %in% c(6, 7) & dt_Ano > 2008)

licitacoes$dt_Ano <- with(licitacoes, unlist(lapply(dt_Ano, relabel_ano)))

n.dispensas <- aggregate(tp_Licitacao ~ cd_UGestora + dt_Ano, licitacoes, length)
colnames(n.dispensas)[3] <- "n.dispensas"

tre_sagres <- merge(tre_sagres, n.dispensas, all.x = T, by.x=c("cd_Ugestora","dt_Ano"), by.y = c("cd_UGestora","dt_Ano"))
tre_sagres$n.dispensas <- with(tre_sagres, ifelse(is.na(n.dispensas),0,n.dispensas))

write.table(tre_sagres, "../../data/tre_sagres_unificadoBase.csv", sep=";", row.names = F, quote = F)


codigo_ugestora <- read.csv("../../data/codigo_ugestora.csv")
aditivos = read.csv("../../data/aditivos.csv")
contratos = read.csv("../../data/contratos.csv")
quantidadeEleitores = read.csv("../../data/quantidadeEleitores.csv",  encoding = "UTF-8")


# Aditivos
aditivos$dt_Ano <- with(aditivos, unlist(lapply(dt_Ano, relabel_ano)))
set_features <- group_by(aditivos, cd_UGestora, dt_Ano) %>% mutate(quantidadeAditivoPorGestao = length(vl_Aditivo))
set_features <- select(set_features, dt_Ano, cd_UGestora, quantidadeAditivoPorGestao)
set_features = unique(set_features)


# Convite de Licitações
conviteLicitacaoPorGestao <- filter(contratos, tp_Licitacao == 3)
conviteLicitacaoPorGestao$dt_Ano <- with(conviteLicitacaoPorGestao, unlist(lapply(dt_Ano, relabel_ano)))
conviteLicitacaoPorGestao = group_by(conviteLicitacaoPorGestao, cd_UGestora, dt_Ano) %>% mutate(quantidadeConviteLicitacaoPorGestao = length(cd_UGestora))
conviteLicitacaoPorGestao <- select(conviteLicitacaoPorGestao, dt_Ano, cd_UGestora, quantidadeConviteLicitacaoPorGestao)
conviteLicitacaoPorGestao = unique(conviteLicitacaoPorGestao)
conviteLicitacaoPorGestao = na.omit(conviteLicitacaoPorGestao)
set_features <- merge(set_features, conviteLicitacaoPorGestao, by.x = c("cd_UGestora","dt_Ano"), by.y = c("cd_UGestora","dt_Ano"), all.x = T)
set_features[is.na(set_features)] <- 0


# Quantidade de Eleitores por Municipio e Distancia da capital
quantidadeEleitores = select(quantidadeEleitores, Abrangencia, Quantidade2009, Quantidade2013, DistanciaParaCapital)
quantidadeEleitores <- group_by(quantidadeEleitores, Abrangencia) %>% mutate(media = (Quantidade2009 + Quantidade2013)/2)

# Exportar csv
 write.csv(set_features, file = "../../data/set_features.csv", row.names = F, quote = F)
 write.csv(quantidadeEleitores, file = "../../data/quantidadeEleitores.csv", row.names = F, quote = F)


 tre_sagres <- read.csv('../../data/tre_sagres_unificadoBase.csv', header=T, sep=";", fileEncoding="UTF-8")
 set_features <- read.csv('../../data/set_features.csv')
 quantidadeEleitores <- read.csv('../../data/quantidadeEleitores.csv')
 
 
 tre_sagres <- merge(tre_sagres, set_features, by.x = c("cd_Ugestora","dt_Ano"), by.y = c("cd_UGestora","dt_Ano"), all.x = T)
 tre_sagres <- merge(tre_sagres, quantidadeEleitores, by.x = c("de_Ugestora"), by.y = c("Abrangencia"), all.x = T)
 
 tre_sagres[is.na(tre_sagres)] <- 0

 tre_sagres <- unique(tre_sagres)
 
 
 
 write.table(tre_sagres, "../../data/tre_sagres_unificado.csv", quote = F, row.names = F, sep=",")
 