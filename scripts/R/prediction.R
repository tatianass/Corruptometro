
# Excutar script data.R
source("data.R")

# Importar conjunto de dados "tre_sagres_unificado.csv"
data = read.csv("../../data/tre_sagres_unificado.csv",header=FALSE,skip=1)

# Selecionar apenas as features V6, V7, V8. Referente ao n.dispensas, nu_Aditivo e nu_Contrato
features = select(data, V6,V7,V8)

# Apresentar os possíveís níveis de V5
table(data$V5)

# Partição de treino com 90% dos dados
train_idx = createDataPartition(y=data$V5, p=.9,list=FALSE)

# Ccnjunto de treino
train = data[train_idx,]

# Conjunto de teste
test = data[-train_idx,]

# features do conjunto de treino
features = select(train, V6,V7,V8)

# Proporção do conjunto de treino
prop.table(table(train$V5))

# Proporção do conjunto de test
prop.table(table(test$V5))

# 
grid = expand.grid(.ntree=c(10,20,30,40,50,100,200),.mtry=2,.model="tree")
help(expa)
#
fitControl = trainControl(method="repeatedcv",number=10,repeats=10,returnResamp="all")

#
labels = as.factor(train$V5)

#
model = train(x=features,y=labels,trControl=fitControl)

#
prob = predict

#
plot(model)

#
test_labels = as.factor(test$V5)

#
predictions = predict(model,newdata=test)

#
prob = predict(model,newdata=test,type = "prob")

#
confusionMatrix(data = predictions, test_labels)


