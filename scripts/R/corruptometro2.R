source("imports.R")

tre_sagres <- read.csv('../../data/tre_sagres_unificado.csv', encoding = "UTF-8", stringsAsFactors = F)
cidades <- read.csv('../../data/municipios.csv', encoding = "UTF-8", sep = ";", dec = ",", stringsAsFactors = F) %>% 
  filter(UF==25, ANO == max(ANO)) %>% rename(de_Ugestora = Municipio)

tre_sagres$de_Ugestora[tre_sagres$de_Ugestora == "CAMPO DE SANTANA"] <- "TACIMA"
tre_sagres$classe <- with(tre_sagres, ifelse(classe == "IRREGULAR", "SIM", "NAO"))

format_number <- function(x){
  round(x, digits=3)*100
}

format_number(tre_sagres$nu_Dispensas_Prop_Contratos)

dados_completos <- full_join(tre_sagres, cidades, by = "de_Ugestora") %>% filter(Candidato2016) %>%
  select(Prefeitura = de_Ugestora, Nome = Eleito, Irregular = classe, nu_Dispensas, nu_Aditivo_Prazo, nu_Aditivo_Valor, nu_Convites, 
         nu_Dispensas_Prop_Contratos, nu_Aditivo_Prazo_Prop_Contratos, nu_Aditivo_Valor_Prop_Contratos, nu_Convites_Prop_Contratos, 
         Populacao = POP, Exp_Vida = ESPVIDA, Ind_ESCOLARIDADE = I_ESCOLARIDADE, IDHM, IDHM_EDUCACAO = IDHM_E, IDHM_LONGEVIDADE = IDHM_L, IDHM_RENDA = IDHM_R)

# format_number(nu_Dispensas_Prop_Contratos), format_number(nu_Aditivo_Prazo_Prop_Contratos), format_number(nu_Aditivo_Valor_Prop_Contratos), 
# format_number(nu_Convites_Prop_Contratos)

sink("indices_cidades.json")
cat(jsonlite::toJSON(dados_completos))
sink()
