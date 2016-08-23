library(caret)
#install.packages("mlbench")
library(mlbench)
#install.packages("C50")
library(C50)
library(dplyr)
library(ggplot2)

#setwd("Documents/HackFest2016/")
data = read.csv("tre_sagres_unificado.csv",header=FALSE,skip=1)
features = select(data, V6,V7,V9)

# features = select(data, n.dispensas,quantidadeAditivoPorGestao,quantidadeDispensaLicitacaoPorGestao,quantidadeConviteLicitacaoPorGestao)

table(data$V5)

train_idx = createDataPartition(y=data$V5, p=.90,list=FALSE)
train = data[train_idx,]
test = data[-train_idx,]

prop.table(table(train$V5))
prop.table(table(test$V5))

grid = expand.grid(.ntree=c(10,20,30,40,50,100,200),.mtry=2,.model="tree")
fitControl = trainControl(method="repeatedcv",number=10,repeats=10,returnResamp="all")
labels = as.factor(train$V5)
model = train(x=features,y=labels,trControl=fitControl)
prob = predict
plot(model)

test_labels = as.factor(test$V5)
predictions = predict(model,newdata=test)
prob = predict(model,newdata=test,type = "prob")
confusionMatrix(data = predictions, test_labels)


  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
