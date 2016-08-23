require(dplyr)

tre_sagres <- read.csv('TRE_Sagres.csv', encoding = "UTF-8")
tre_sagres <- select(tre_sagres,-DECISÃO, -DATA.PUBLICAÇÃO, -RES..DECISÃO.PODER.LEGISLATIVO, -ITEM, -PROCESSO, -SUBCATEGORIA)
tre_sagres <- unique(tre_sagres)

write.table(tre_sagres, "tre_sagres_unificado.csv", sep=",", row.names = F, quote = F)
