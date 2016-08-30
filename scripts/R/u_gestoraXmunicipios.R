relabel_ano <- function(x){
  ifelse(x >= 2009 && x <2013, 2009, 2013)
}

idhm <- function(cd_uges, dt_ano){
  de_mun <- subset(u_gestora, cd_Ugestora == cd_uges)
  list_de_mun <- de_mun$de_Ugestora
  de_mun <- as.character(list_de_mun[1])
  nome_mun <- unlist(strsplit(de_mun, "C?mara Municipal de "))[2]
  
  #pegar convenios pelo nome do municipio e ano
  municipio <- subset(municipios, Munic?pio == toupper(nome_mun) & ANO == dt_ano)
  idhmr <- municipio$IDHM_R
  return(idhmr)
}

#Tatiana - tarefa 2 - especificacao: pegar idhmr do município pelo código
#mudar para o seu
tre_sagre <- read.csv('../../data/tre_sagres_unificado.csv')
municipios <- read.csv("../../data/municipios.csv", sep=";", encoding="UTF-8")
u_gestora <- read.csv("../../data/codigo_ugestora.csv", encoding="UTF-8")
u_gestora <- subset(u_gestora, dt_Ano >2008)
u_gestora$dt_Ano <- with(u_gestora, unlist(lapply(dt_Ano, relabel_ano)))

