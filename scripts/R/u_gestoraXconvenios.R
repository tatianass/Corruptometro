#Tatiana - tarefa 1 - especificacao: pegar a quantidade total de convenios por unidade gestora

convenios <- read.csv("../../data/contratos.csv", encoding="UTF-8")
u_gestora <- read.csv("../../data/codigo_ugestora.csv", encoding="UTF-8")

#pegar convenios pela unidade gestora
convenios_u_gestora <- subset(convenios, cd_UGestora == "101025")

#quantidade
nrow(convenios_u_gestora)

