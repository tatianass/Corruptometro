# Excutar script data.R
source("imports.R")
#source("data.R")
tre_sagres <- read.csv('../../data/tre_sagres_unificado.csv', encoding = "UTF-8")

# Apresentar os possíveis níveis de Classe
table(tre_sagres$classe)

# Partição de teste com os candidatos reeleitos
test_idx = which(tre_sagres$Candidato2016)

# Conjunto de treino e teste
test = tre_sagres[test_idx,]
train = tre_sagres[-test_idx,]

# Proporção dos conjuntos de treino e teste
prop.table(table(train$classe))
prop.table(table(test$classe))

#Treino do modelo
fitControl = trainControl(method="repeatedcv", number=10, repeats=10, returnResamp="all")
#train.features = select(train, classe, starts_with("nu_"), -starts_with("nu_Aditivo_Devolucao"), -nu_Dispensas)
model = train(form = classe ~ nu_Aditivo_Valor_Prop_Eleitores + nu_Aditivos_Totais_Prop_Eleitores, data = train, trControl=fitControl, method="rf")

predictions = predict(model,newdata=test)
prob = predict(model,newdata=test,type = "prob")
caret::confusionMatrix(predictions, test$classe)

prob.table = cbind(test, prob) %>% 
  select(Nome = Eleito, Prefeitura = de_Ugestora, NAV = nu_Aditivo_Valor, NAT = nu_Aditivos_Totais, Probabilidade = IRREGULAR)

sink("../../data/candidatos.json")
cat(toJSON(prob.table))
sink()