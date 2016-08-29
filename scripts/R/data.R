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

# Função para modificar o ano.
## Gestões entre 2009 e 2012 tem o ano modificado para 2009
## Gestões entre 2013 e 2016 tem o ano modificado para 2013
relabel_ano <- function(x){
  ifelse(x >= 2009 && x <2013, 2009, 2013)
}

# Carregar conjunto de dados
## tre_sagres_jul jestores jugados
tre_sagres_jul <- read.csv('../../data/TRE_Sagres_Resp_Eleito.csv', encoding = "UTF-8")

## tre_sagres_n_jul jestores N�o  jugados
tre_sagres_n_jul <- read.csv('../../data/TRE_Sagres_Eleit_Idon.csv', encoding = "UTF-8")

## dados referentes a unidade gestora
ugestora <- read.csv('../../data/codigo_ugestora.csv', encoding = "UTF-8")

## contratos realizados pelas unidades gestoras
contrato <- read.csv('../../data/contratos.csv', encoding = "UTF-8")

## Conjundo de aditivos solicitados pelas unidades gestoras
aditivos = read.csv("../../data/aditivos.csv", encoding = "UTF-8")

## Sumário eleitoral das unidades gestoras
quantidadeEleitores = read.csv("../../data/quantidadeEleitores.csv",  encoding = "UTF-8")

# Adiciona coluna class e valor de "Jugados" para gestores julgados
tre_sagres_jul$class <- "Julgados"

# Adiciona coluna class e valor de "N�o  jugado" para gestores N�o julgados
tre_sagres_n_jul$class <- "N�o julgados"

# Revolve colunas N�o  necessárias
tre_sagres_jul <- select(tre_sagres_jul,-DECIS�O, -RES..DECIS�O.PODER.LEGISLATIVO, -ITEM, -PROCESSO, -SUBCATEGORIA, -RESPONS�VEL, -CPF)

# Junta conjunto de dados dos gestores julgados e dos N�o julgados
tre_sagres <- rbind(tre_sagres_jul, tre_sagres_n_jul)

# seleciona conjunto de contrados realizados após o ano de 2008 com licitações do tipo "Dispensa de valor" ou "Dispensa por outro motivo"
licitacoes <- subset(contrato, tp_Licitacao %in% c(6, 7) & dt_Ano > 2008)

# Aplica a função "relabel_ano" as licitações selecionadas
licitacoes$dt_Ano <- with(licitacoes, unlist(lapply(dt_Ano, relabel_ano)))

# Agrupa as dispensas de cada gestao agrupadas pelo ano
n.dispensas <- aggregate(tp_Licitacao ~ cd_UGestora + dt_Ano, licitacoes, length)

# Modifica o nome da coluna "tp_Licitacao" no conjunto "n.dispensas" para "n.dispensas"
colnames(n.dispensas)[3] <- "n.dispensas"

# Merge dos conjuntos "tre_sagres" e "n.dispensas". Merge feito pelo ano e unidade gestora
tre_sagres <- merge(tre_sagres, n.dispensas, all.x = T, by.x=c("cd_Ugestora","dt_Ano"), by.y = c("cd_UGestora","dt_Ano"))

# Atribui 0 para "N/A"
tre_sagres$n.dispensas <- with(tre_sagres, ifelse(is.na(n.dispensas),0,n.dispensas))

# Salvar o conjunto "tre_sagres"
write.table(tre_sagres, "../../data/tre_sagres_unificadoBase.csv", sep=";", row.names = F, quote = F, fileEncoding = "UTF-8")

# Aplica a função "relabel_ano" ao conjunto "Aditivos"
aditivos$dt_Ano <- with(aditivos, unlist(lapply(dt_Ano, relabel_ano)))

# Agrupa os aditivos de cada gestao pelo ano
aditivos <- aggregate(nu_Aditivo ~ cd_UGestora + dt_Ano, aditivos, length)

# Convite de Licitações
## Seleciona todos os contratos do tipo convite
conviteLicitacaoPorGestao <- filter(contrato, tp_Licitacao == 3)

# Aplica a função "relabel_ano" ao conjunto de licitações do tipo "Convite"
conviteLicitacaoPorGestao$dt_Ano <- with(conviteLicitacaoPorGestao, unlist(lapply(dt_Ano, relabel_ano)))

# Agrupa os convites de licitações de cada gestao pelo ano
conviteLicitacaoPorGestao <- aggregate(nu_Contrato ~ cd_UGestora + dt_Ano, conviteLicitacaoPorGestao, length)

# Merge dos conjuntos "aditivos" e "conviteLicitacaoPorGestao". Merge feito pelo ano e unidade gestora
set_features <- merge(aditivos, conviteLicitacaoPorGestao, by.x = c("cd_UGestora","dt_Ano"), by.y = c("cd_UGestora","dt_Ano"), all.x = T)

# Quantidade de Eleitores por Municipio e Distancia da capital
quantidadeEleitores = select(quantidadeEleitores, Abrangencia, Quantidade2009, Quantidade2013, DistanciaParaCapital)

# Média de Eleitores entre os anos
quantidadeEleitores <- group_by(quantidadeEleitores, Abrangencia) %>% mutate(media = (Quantidade2009 + Quantidade2013)/2)

# Salva o conjunto "set_features"
write.csv(set_features, file = "../../data/set_features.csv", row.names = F, quote = F, fileEncoding = "UTF-8")
# Salva o conjunto "quantidadeEleitores"
write.csv(quantidadeEleitores, file = "../../data/quantidadeEleitores.csv", row.names = F, quote = F, fileEncoding = "UTF-8")


# Merge dos conjuntos "tre_sagres" e "set_features". Merge feito pelo ano e unidade gestora 
tre_sagres <- merge(tre_sagres, set_features, by.x = c("cd_Ugestora","dt_Ano"), by.y = c("cd_UGestora","dt_Ano"), all.x = T)

# Merge dos conjuntos "tre_sagres" e "quantidadeEleitores". Merge feito pelo ano e unidade gestora 
tre_sagres <- merge(tre_sagres, quantidadeEleitores, by.x = c("de_Ugestora"), by.y = c("Abrangencia"), all.x = T)
 
# Adiciona 0 nos "N/A"
tre_sagres[is.na(tre_sagres)] <- 0

# Elimina os repitidos
tre_sagres <- unique(tre_sagres)
 
# Salva o conjunto "tre_sagres" com o nome "tre_sagres_unificado.csv"
write.table(tre_sagres, "../../data/tre_sagres_unificado.csv", quote = F, row.names = F, sep=",", fileEncoding = "UTF-8")
 