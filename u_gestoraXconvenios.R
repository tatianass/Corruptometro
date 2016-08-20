#Tatiana - tarefa 1 - especificacao: pegar a quantidade total de convenios por unidade gestora
#mudar para o seu
setwd("C:/Users/Tatiana/Downloads/Compressed/hackfest/tarefa1- unidade_gestora x convenio") 

convenios <- read.csv("contratos.csv")
u_gestora <- read.csv("codigo_ugestora.csv")

#pegar convenios pela unidade gestora
convenios_u_gestora <- subset(convenios, cd_UGestora == "101025")

#quantidade
nrow(convenios_u_gestora)

