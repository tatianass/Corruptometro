# Excutar script data.R
source("data.R")

# Importar conjunto de dados "tre_sagres_unificado.csv"
data = read.csv("../../data/tre_sagres_unificado.csv",header=T, encoding = "UTF-8")

# Selecionar apenas as features nu_Dispensas, nu_Aditivo, nu_Contrato. Referente ao nu_Dispensass, nu_Aditivo e nu_Contrato
features = select(data, nu_Dispensas, nu_Aditivo, nu_Contrato)

# Apresentar os possíveis níveis de Classe
table(data$Classe)

# Partição de treino com 90% dos dados
train_idx = createDataPartition(y=data$Classe, p=.75, list=FALSE)

# Conjunto de treino
train = data[train_idx,]

# Conjunto de teste
test = data[-train_idx,]

# features do conjunto de treino
features = select(train, nu_Dispensas, nu_Aditivo, nu_Contrato)

# Proporção do conjunto de treino
prop.table(table(train$Classe))

# Proporção do conjunto de test
prop.table(table(test$Classe))

#Treino do modelo
grid = expand.grid(.ntree=c(10,20,30,40,50,100,200),.mtry=2,.model="tree")
fitControl = trainControl(method="repeatedcv",number=10,repeats=10,returnResamp="all")
labels = as.factor(train$Classe)
model = train(x=features,y=labels,trControl=fitControl)

#
test_labels = as.factor(test$Classe)
predictions = predict(model,newdata=test)
prob = predict(model,newdata=test,type = "prob")
confusionMatrix(data = predictions, test_labels)