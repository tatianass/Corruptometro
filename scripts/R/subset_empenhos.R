require("data.table")
empenhos <- fread('CSV/empenhos.csv', encoding = "UTF-8")
empenhos.2 <- subset(empenhos, select=c("cd_UGestora","dt_Ano","cd_Credor","no_Credor"))
write.table(empenhos.2, file="empenhos_sub.csv",sep=";",row.names = F, quote = F)
