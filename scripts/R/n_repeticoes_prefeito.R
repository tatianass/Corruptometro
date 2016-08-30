require(dplyr)

tre_sagres <- read.csv('../../data/TRE_Sagres.csv', encoding = "UTF-8")
tre_sagres <- select(tre_sagres,-DECIS?O, -DATA.PUBLICA??O, -RES..DECIS?O.PODER.LEGISLATIVO, -ITEM, -PROCESSO, -SUBCATEGORIA)
tre_sagres <- unique(tre_sagres)

write.table(tre_sagres, "../../data/tre_sagres_unificado.csv", sep=",", row.names = F, quote = F)
