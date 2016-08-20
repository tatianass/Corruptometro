#Tatiana - tarefa 3 - especificacao: pegando dados dos candidatos por ano de eleicao
#baixando csv dos dados
install.packages("electionsBR")

library("electionsBR")

candidatos_1998 <- electionsBR::candidate_fed(1998)
candidatos_2002 <- electionsBR::candidate_fed(2002)
candidatos_2006 <- electionsBR::candidate_fed(2006)
candidatos_2010 <- electionsBR::candidate_fed(2010)
candidatos_2014 <- electionsBR::candidate_fed(2014)

write.csv(candidatos_1998, file = "candidate_fed_1998.csv")
write.csv(candidatos_2002, file = "candidate_fed_2002.csv")
write.csv(candidatos_2006, file = "candidate_fed_2006.csv")
write.csv(candidatos_2010, file = "candidate_fed_2010.csv")
write.csv(candidatos_2014, file = "candidate_fed_2014.csv")
