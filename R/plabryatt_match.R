library(taxize)
library(tidyverse)

species_df <- read.csv("data/PLABRYATT_v4.csv")
names(species_df)

species <- as.character(species_df$PLABRYATT_VTA.NAME)

length(species[duplicated(species)])
species[duplicated(species)]
#use global name resolver to get GBIF names
gbif_resolved1 <- gnr_resolve(species, preferred_data_sources = 11, best_match_only = T, fields = "all")

#check if there are duplicates
gbif_resolved1 %>% group_by(matched_name) %>% filter(n()>1)

#write gbif ids back to plabryatt

gbif_resolved1_selected <- select(gbif_resolved1, user_supplied_name, matched_name:taxon_id, score) %>% 
  setNames(paste0('gbif.', names(.)))

species_df_2 <- species_df %>% 
  left_join(gbif_resolved1_selected, by = c("PLABRYATT_VTA.NAME" = "gbif.user_supplied_name"))

write_csv(species_df_2, "data/PLABRYATT_v5.csv")

