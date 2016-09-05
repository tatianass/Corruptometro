source("imports.R")

tre_sagres <- read.csv("../../data/tre_sagres_unificado.csv", encoding = "UTF-8")
features <- tre_sagres[,c(5,7:12)]

information.gain(classe ~ ., features)
gain.ratio(classe ~ ., features)

irregulares <- subset(features, classe == 'IRREGULAR')
nao_irregulares <- subset(features, classe == 'NAO IRREGULAR')

wilcox.test(irregulares$nu_Dispensas, nao_irregulares$nu_Dispensas, paired = F)
wilcox.test(irregulares$nu_Aditivo_Devolucao, nao_irregulares$nu_Aditivo_Devolucao, paired = F)

wilcox.test(irregulares$nu_Aditivo_Prazo, nao_irregulares$nu_Aditivo_Prazo, paired = F)
wilcox.test(irregulares$nu_Aditivo_Valor, nao_irregulares$nu_Aditivo_Valor, paired = F)
wilcox.test(irregulares$nu_Aditivos_Totais, nao_irregulares$nu_Aditivos_Totais, paired = F)
wilcox.test(irregulares$nu_Convites, nao_irregulares$nu_Convites, paired = F)