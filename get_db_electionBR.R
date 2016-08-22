#Tatiana - tarefa 3 - especificacao: pegando dados dos candidatos por ano de eleicao
#baixando csv dos dados
install.packages("electionsBR")

library("electionsBR")

candidatos_2008 <- electionsBR::candidate_local(2008)
candidatos_2012 <- electionsBR::candidate_local(2012)

write.csv(candidatos_2008, file = "candidate_local_2008.csv")
write.csv(candidatos_2012, file = "candidate_local_2012.csv")