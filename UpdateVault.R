library("secret")
library("openssl")


## Création du coffre-fort ####
vault <- "vault"
# Suppression de l'ancien coffre-fort
unlink(vault, recursive = TRUE)
# Création du nouveau coffre
create_vault(vault)
# Utilisateur correspondant au projet
ClePubliqueDuProjet <- read_pubkey("Cours-Biodiversite_rsa.pub")
add_user("Cours-Biodiversite", public_key = ClePubliqueDuProjet, vault = vault)
# Propriétaire du projet
add_github_user("EricMarcon", vault = vault)

## Données ####
# Lecture de la base de Paracou
library("tidyverse")
library("EcoFoG")
Paracou2df("CensusYear=2016") %>% 
  as.tibble %>% 
  filter(CodeAlive == TRUE) %>% 
  select(Plot, SubPlot:Yfield, -Projet, -Protocole, Family:Species, CircCorr) %>%
  unite(col = spName, Genus, Species, remove = FALSE) -> Paracou

## Sauvegarde cryptée ####
# Création du secret, avec deux utilisateurs : le propriétaire du projet et l'utilisateur correspondant au projet
add_secret("Paracou", value = Paracou, users = c("github-EricMarcon", "Cours-Biodiversite"), vault = vault)
# Vérification
list_owners("Paracou", vault = vault)
