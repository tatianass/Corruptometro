# Excutar script data.R
source("imports.R")
source("data.R")

# Apresentar os possíveis níveis de Classe
table(tre_sagres$classe)

# Partição de teste com os candidatos reeleitos
test_idx = which(tre_sagres$Candidato2016)

# Conjunto de treino e teste
test = tre_sagres[test_idx,]
train = tre_sagres[-test_idx,]

# features do conjunto de treino
#features.names = c("nu_Dispensas", "nu_Aditivo_Prazo", "nu_Aditivo_Devolucao", "nu_Aditivo_Valor", "nu_Aditivos_Totais", "nu_Contrato")
train.features = select(train, nu_Dispensas, nu_Aditivo_Prazo, nu_Aditivo_Devolucao, nu_Aditivo_Valor, nu_Aditivos_Totais, nu_Contrato)
test.features = select(test, nu_Dispensas, nu_Aditivo_Prazo, nu_Aditivo_Devolucao, nu_Aditivo_Valor, nu_Aditivos_Totais, nu_Contrato)

# Proporção dos conjuntos de treino e teste
prop.table(table(train$classe))
prop.table(table(test$classe))

#Treino do modelo
#grid = expand.grid(.ntree=c(10,20,30,40,50,100,200),.mtry=2,.model="tree")

fitControl = trainControl(method="repeatedcv", number=10, repeats=10, returnResamp="all")
labels = as.factor(train$classe)
model = train(x=train.features, y=labels, trControl=fitControl, method="rf")

test_labels = as.factor(test$classe)
predictions = predict(model,newdata=test.features)
prob = predict(model,newdata=test.features,type = "prob")
caret::confusionMatrix(predictions, test_labels)