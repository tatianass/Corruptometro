library(e1071)
data(iris)

df <- iris

df <- subset(df ,  Species=='setosa')  #choose only one of the classes

x <- subset(df, select = -Species) #make x variables
y <- df$Species #make y variable(dependent)
model <- svm(x, y, type='one-classification') #train an one-classification model 


print(model)
summary(model) #print summary

# test on the whole set
pred <- predict(model, subset(iris, select=-Species))
