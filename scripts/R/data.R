source("imports.R")

# Funcao para modificar o ano.
# Gestoes entre 2009 e 2012 tem o ano modificado para 2009
# Gestoes entre 2013 e 2016 tem o ano modificado para 2013
relabel_ano <- function(x){
  ifelse(x >= 2009 && x <2013, 2009, 2013)
}

# Carregar conjunto de dados
tre_sagres <- read.csv("../../data/TRE_Sagres_Resp_Eleito_Final.csv",header=T, encoding = "UTF-8")
ugestora <- read.csv('../../data/codigo_ugestora.csv', encoding = "UTF-8")
quantidadeEleitores <- read.csv("../../data/quantidadeEleitores.csv", encoding = "UTF-8")
candidadosEleicao2016 <- read.csv("../../data/Candidatos_eleicao_2016.csv", encoding = "UTF-8")
candidadosEleicao2016$Candidato2016 <- TRUE

aditivos <- read.csv("../../data/aditivos.csv", encoding = "UTF-8")
aditivos$dt_Ano <- with(aditivos, unlist(lapply(dt_Ano, relabel_ano)))

contrato <- read.csv('../../data/contratos.csv', encoding = "UTF-8")
contrato <- subset(contrato, dt_Ano > 2008)
contrato$dt_Ano <- with(contrato, unlist(lapply(dt_Ano, relabel_ano)))

# Adiciona coluna com os candidatos a eleição em 2016
tre_sagres <- merge(tre_sagres, candidadosEleicao2016, by.x = c("de_Ugestora","Eleito"), by.y = c("de_Ugestora","ELEITO"), all.x = T)
tre_sagres[is.na(tre_sagres)] <- FALSE

# Adiciona Quantidade de Eleitores por Municipio e Distancia da capital
quantidadeEleitores <- select(quantidadeEleitores, Abrangencia, DistanciaParaCapital, Media_Eleitores = (Quantidade2009 + Quantidade2013)/2)
tre_sagres <- merge(tre_sagres, quantidadeEleitores, by.x = c("de_Ugestora"), by.y = c("Abrangencia"), all.x = T)

# Conta o numero de contratos da prefeitura
nu_Contratos <- aggregate(nu_Contrato ~ cd_UGestora + dt_Ano, contrato, length) %>% rename(nu_Contratos = nu_Contrato)
tre_sagres <- merge(tre_sagres, nu_Contratos, all.x = T, by.x=c("cd_Ugestora","dt_Ano"), by.y = c("cd_UGestora","dt_Ano"))

# Adiciona a coluna "nu_Dispesas" a base
# seleciona conjunto de contrados com licitacoes do modelo "Dispensa de valor" ou "Dispensa por outro motivo"
nu_Dispensas <- subset(contrato, tp_Licitacao %in% c(6, 7)) %>% 
  group_by(cd_UGestora, dt_Ano) %>% summarise(nu_Dispensas = length(tp_Licitacao))
tre_sagres <- merge(tre_sagres, nu_Dispensas, all.x = T, by.x=c("cd_Ugestora","dt_Ano"), by.y = c("cd_UGestora","dt_Ano"))
tre_sagres$nu_Dispensas <- with(tre_sagres, ifelse(is.na(nu_Dispensas),0,nu_Dispensas))

# Adiciona os atributos de aditivos
aditivo_De_Prazo <- filter(aditivos, vl_Aditivo == "0,0000")
aditivo_De_Prazo <- group_by(aditivo_De_Prazo, cd_UGestora, dt_Ano) %>% mutate(nu_Aditivo_Prazo = length(nu_Aditivo))
aditivo_De_Prazo <- select(aditivo_De_Prazo, cd_UGestora, dt_Ano ,nu_Aditivo_Prazo)

aditivo_De_Devolucao = filter(aditivos, regexpr('-', vl_Aditivo) > 0)
aditivo_De_Devolucao <- group_by(aditivo_De_Devolucao, cd_UGestora, dt_Ano) %>% mutate(nu_Aditivo_Devolucao = length(nu_Aditivo))
aditivo_De_Devolucao <- select(aditivo_De_Devolucao, cd_UGestora, dt_Ano, nu_Aditivo_Devolucao)

aditivo_De_Valor = filter(aditivos, regexpr('-', vl_Aditivo) < 0)
aditivo_De_Valor <- group_by(aditivo_De_Valor, cd_UGestora, dt_Ano) %>% mutate(nu_Aditivo_Valor = length(nu_Aditivo))
aditivo_De_Valor <- select(aditivo_De_Valor, cd_UGestora, dt_Ano, nu_Aditivo_Valor)

nu_Aditivos_Totais <- merge(aditivo_De_Prazo, aditivo_De_Devolucao, by = c("cd_UGestora", "dt_Ano"), all.x = T)
nu_Aditivos_Totais <- merge(nu_Aditivos_Totais, aditivo_De_Valor, by = c("cd_UGestora", "dt_Ano"), all.x = T)
nu_Aditivos_Totais[is.na(nu_Aditivos_Totais)] <- 0

nu_Aditivos_Totais$nu_Aditivos_Totais <- with(nu_Aditivos_Totais, nu_Aditivo_Prazo + nu_Aditivo_Devolucao + nu_Aditivo_Valor)
nu_Aditivos_Totais <- unique(nu_Aditivos_Totais)

tre_sagres <- merge(tre_sagres, nu_Aditivos_Totais, by.x = c("cd_Ugestora","dt_Ano"), by.y = c("cd_UGestora","dt_Ano"), all.x = T)
tre_sagres[is.na(tre_sagres)] <- 0

# Adiciona convite de Licita??es
## Seleciona todos os contratos do tipo convite
conviteLicitacaoPorGestao <- filter(contrato, tp_Licitacao == 3)
#conviteLicitacaoPorGestao$dt_Ano <- with(conviteLicitacaoPorGestao, unlist(lapply(dt_Ano, relabel_ano)))
conviteLicitacaoPorGestao <- aggregate(nu_Contrato ~ cd_UGestora + dt_Ano, conviteLicitacaoPorGestao, length)
colnames(conviteLicitacaoPorGestao)[3] <- "nu_Convites"
tre_sagres <- merge(tre_sagres, conviteLicitacaoPorGestao, by.x = c("cd_Ugestora","dt_Ano"), by.y = c("cd_UGestora","dt_Ano"), all.x = T)

tre_sagres[is.na(tre_sagres)] <- 0
tre_sagres <- unique(tre_sagres)

write.table(tre_sagres, "../../data/tre_sagres_unificado.csv", quote = F, row.names = F, sep=",", fileEncoding = "UTF-8")