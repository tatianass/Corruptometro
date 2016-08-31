# Fun??o para modificar o ano.
# Gest?es entre 2009 e 2012 tem o ano modificado para 2009
# Gest?es entre 2013 e 2016 tem o ano modificado para 2013
relabel_ano <- function(x){
  ifelse(x >= 2009 && x <2013, 2009, 2013)
}

# Carregar conjunto de dados
## tre_sagres_jul jestores jugados
tre_sagres_jul <- read.csv('../../data/TRE_Sagres_Resp_Eleito.csv', encoding = "UTF-8")

## tre_sagres_n_jul jestores N√£o jugados
tre_sagres_n_jul <- read.csv('../../data/TRE_Sagres_Eleit_Idon.csv', encoding = "UTF-8")

## dados referentes a unidade gestora
ugestora <- read.csv('../../data/codigo_ugestora.csv', encoding = "UTF-8")

## contratos realizados pelas unidades gestoras
contrato <- read.csv('../../data/contratos.csv', encoding = "UTF-8")

## Conjundo de aditivos solicitados pelas unidades gestoras
aditivos <- read.csv("../../data/aditivos.csv", encoding = "UTF-8")

## Sum?rio eleitoral das unidades gestoras
quantidadeEleitores = read.csv("../../data/quantidadeEleitores.csv", encoding = "UTF-8")

# Adiciona coluna Classe
tre_sagres_jul$Classe <- "Julgado"
tre_sagres_n_jul$Classe <- "Nao julgado"

tre_sagres_jul <- select(tre_sagres_jul, -DECIS√O, -RES..DECIS√O.PODER.LEGISLATIVO, -ITEM, -PROCESSO, -SUBCATEGORIA, -RESPONS¡VEL, -CPF)
tre_sagres <- rbind(tre_sagres_jul, tre_sagres_n_jul)

# seleciona conjunto de contrados realizados ap√≥s o ano de 2008 com licita√ß√µes do tipo "Dispensa de valor" ou "Dispensa por outro motivo"
licitacoes <- subset(contrato, tp_Licitacao %in% c(6, 7) & dt_Ano > 2008)

# Aplica a fun√ß√£o "relabel_ano" as licita√ß√µes selecionadas
licitacoes$dt_Ano <- with(licitacoes, unlist(lapply(dt_Ano, relabel_ano)))

# Adiciona a coluna "nu_Dispesas" a base
nu_Dispensas <- aggregate(tp_Licitacao ~ cd_UGestora + dt_Ano, licitacoes, length)
colnames(nu_Dispensas)[3] <- "nu_Dispensas"
tre_sagres <- merge(tre_sagres, nu_Dispensas, all.x = T, by.x=c("cd_Ugestora","dt_Ano"), by.y = c("cd_UGestora","dt_Ano"))
tre_sagres$nu_Dispensas <- with(tre_sagres, ifelse(is.na(nu_Dispensas),0,nu_Dispensas))

# Aplica a funcao "relabel_ano" ao conjunto "Aditivos"
aditivos$dt_Ano <- with(aditivos, unlist(lapply(dt_Ano, relabel_ano)))

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

# Adiciona convite de LicitaÁıes
## Seleciona todos os contratos do tipo convite
conviteLicitacaoPorGestao <- filter(contrato, tp_Licitacao == 3)
conviteLicitacaoPorGestao$dt_Ano <- with(conviteLicitacaoPorGestao, unlist(lapply(dt_Ano, relabel_ano)))
conviteLicitacaoPorGestao <- aggregate(nu_Contrato ~ cd_UGestora + dt_Ano, conviteLicitacaoPorGestao, length)
tre_sagres <- merge(tre_sagres, conviteLicitacaoPorGestao, by.x = c("cd_Ugestora","dt_Ano"), by.y = c("cd_UGestora","dt_Ano"), all.x = T)

# Adiciona Quantidade de Eleitores por Municipio e Distancia da capital
quantidadeEleitores = select(quantidadeEleitores, Abrangencia, Quantidade2009, Quantidade2013, DistanciaParaCapital)
quantidadeEleitores <- group_by(quantidadeEleitores, Abrangencia) %>% mutate(Media = (Quantidade2009 + Quantidade2013)/2)
tre_sagres <- merge(tre_sagres, quantidadeEleitores, by.x = c("de_Ugestora"), by.y = c("Abrangencia"), all.x = T)

tre_sagres[is.na(tre_sagres)] <- 0
tre_sagres <- unique(tre_sagres)

write.table(tre_sagres, "../../data/tre_sagres_unificado.csv", quote = F, row.names = F, sep=",", fileEncoding = "UTF-8")