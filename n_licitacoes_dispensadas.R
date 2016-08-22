ugestora <- read.csv('CSV/codigo_ugestora.csv', encoding = "UTF-8")
contrato <- read.csv('CSV/contratos.csv', encoding = "UTF-8")
tipo_modalidade_licitacao <- read.csv('CSV/tipo_modalidade_licitacao.csv', encoding = "UTF-8")

licitacoes <- subset(contrato, tp_Licitacao %in% c(6, 7))
n.dispensas <- aggregate(tp_Licitacao ~ cd_UGestora + dt_Ano, licitacoes, length)