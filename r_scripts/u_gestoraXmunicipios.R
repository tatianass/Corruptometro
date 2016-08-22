#Tatiana - tarefa 2 - especificacao: pegar idhmr do município pelo código

municipios <- read.csv("municipios.csv", sep=";", encoding="UTF-8")
u_gestora <- read.csv("codigo_ugestora.csv", encoding="UTF-8")

de_mun <- subset(u_gestora, cd_Ugestora == "101025")
list_de_mun <- de_mun$de_Ugestora
de_mun <- as.character(list_de_mun[1])
nome_mun <- unlist(strsplit(de_mun, "Câmara Municipal de "))[2]

#pegar convenios pelo nome do municipio e ano
municipio <- subset(municipios, Município == toupper(nome_mun) & ANO == 2010)
idhmr <- municipio$IDHM_R