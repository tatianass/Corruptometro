
source("data.R")

data = read.csv("../../data/tre_sagres_unificado.csv",header=FALSE,skip=1)
features = select(data, V6,V7,V8)

table(data$V5)

train_idx = createDataPartition(y=data$V5, p=.9,list=FALSE)
train = data[train_idx,]
test = data[-train_idx,]

features = select(train, V6,V7,V8)

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






  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
