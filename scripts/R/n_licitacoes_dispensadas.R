####
# Esse script foi adicionado no script dados.R
####

relabel_ano <- function(x){
  ifelse(x >= 2009 && x <2013, 2009, 2013)
}

tre_sagres_jul <- read.csv('../../data/TRE_Sagres_Resp_Eleito.csv', encoding = "UTF-8")
tre_sagres_n_jul <- read.csv('../../data/TRE_Sagres_Eleit_Idon.csv', encoding = "UTF-8")

tre_sagres_jul$class <- "Julgados"
tre_sagres_n_jul$class <- "N?o julgados"


tre_sagres_jul <- select(tre_sagres_jul,-DECIS?O, -RES..DECIS?O.PODER.LEGISLATIVO, -ITEM, -PROCESSO, -SUBCATEGORIA, -RESPONS?VEL, -CPF)
tre_sagres <- rbind(tre_sagres_jul, tre_sagres_n_jul)

ugestora <- read.csv('../../data/codigo_ugestora.csv', encoding = "UTF-8")
contrato <- read.csv('../../data/contratos.csv', encoding = "UTF-8")
#tipo_modalidade_licitacao <- read.csv('../../data/tipo_modalidade_licitacao.csv', encoding = "UTF-8")

licitacoes <- subset(contrato, tp_Licitacao %in% c(6, 7) & dt_Ano > 2008)
licitacoes$dt_Ano <- with(licitacoes, unlist(lapply(dt_Ano, relabel_ano)))

n.dispensas <- aggregate(tp_Licitacao ~ cd_UGestora + dt_Ano, licitacoes, length)
colnames(n.dispensas)[3] <- "n.dispensas"

tre_sagres <- merge(tre_sagres, n.dispensas, all.x = T, by.x=c("cd_Ugestora","dt_Ano"), by.y = c("cd_UGestora","dt_Ano"))
tre_sagres$n.dispensas <- with(tre_sagres, ifelse(is.na(n.dispensas),0,n.dispensas))

write.table(tre_sagres, "../../data/tre_sagres_unificadoBase.csv", sep=";", row.names = F, quote = F, fileEncoding = "UTF-8")
