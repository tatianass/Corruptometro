library(gtools)

# Jefferson
tre_sagres <- read.csv('tre_sagres_unificadoBase.csv', header=T, sep=";", fileEncoding="UTF-8")
set_features <- read.csv('set_features.csv', header=T, sep=";", fileEncoding="UTF-8")
quantidadeEleitores <- read.csv('quantidadeEleitores.csv', header=T, sep=";", fileEncoding="UTF-8")


tre_sagres <- merge(tre_sagres, set_features, by.x = c("cd_Ugestora","dt_Ano"), by.y = c("cd_UGestora","dt_Ano"), all.x = T)
tre_sagres <- merge(tre_sagres, quantidadeEleitores, by.x = c("de_Ugestora"), by.y = c("Abrangencia"), all.x = T)

tre_sagres[is.na(tre_sagres)] <- 0
#DAR MERGE COM QUANTIDADE DE ELEITORES

#tre_sagre = select(tre_sagre, -Quantidade.2013)

#tre_sagre$Distancia.Para.Capital = scale(tre_sagre$Distancia.Para.Capital, center = TRUE, scale = FALSE)
#tre_sagre$media = scale(tre_sagre$media, center = TRUE, scale = FALSE)
#tre_sagre$n.dispensas = scale(tre_sagre$n.dispensas, center = TRUE, scale = FALSE)
#tre_sagre$quantidadeAditivoPorGestao = scale(tre_sagre$quantidadeAditivoPorGestao, center = TRUE, scale = FALSE)
#tre_sagre$Quantidade.2009 = scale(tre_sagre$Quantidade.2009, center = TRUE, scale = FALSE)
#tre_sagre$quantidadeDispencaLicitacaoPorGestao = scale(tre_sagre$quantidadeDispencaLicitacaoPorGestao, center = TRUE, scale = FALSE)
#tre_sagre$quantidadeConviteLicitacaoPorGestao = scale(tre_sagre$quantidadeConviteLicitacaoPorGestao, center = TRUE, scale = FALSE)

##s
tre_sagres <- unique(tre_sagres)



write.table(tre_sagres, "tre_sagres_unificado.csv", quote = F, row.names = F, sep=",")















tre_sagres$tipo = tre_sagres$class
tre_sagres = select(tre_sagres, -class)
baseTreino <- createDataPartition(y = tre_sagres$tipo, p = 0.8, list = FALSE)

treino <- tre_sagres[baseTreino, 6:9]

teste <- tre_sagres[-baseTreino,]


set.seed(9345)


modeloAjustado <- rpart( ~ ., data = treino, method = "class")


prp(modeloAjustado)


testeModelo <- predict(modeloAjustado, newdata = teste, type = "class")


testeModeloCM <- confusionMatrix(testeModelo, teste$tipo)



testeModeloCM













