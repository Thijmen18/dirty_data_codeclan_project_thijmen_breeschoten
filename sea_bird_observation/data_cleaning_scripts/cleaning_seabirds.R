# CodeClan dirty data project: sea bird observation
# this script contains code to clean the raw data 'seabirds.xls'

####### open & exploring data
library(tidyverse)
library(readxl)

# xls has 2 worksheets: open separately

seabirds <- read_excel("raw_data/seabirds.xls", sheet = "Bird data by record ID")

ships <- read_excel("raw_data/seabirds.xls", sheet = "Ship data by record ID")

names(seabirds)
glimpse(seabirds)
head(seabirds)
names(ships)
glimpse(ships)
head(ships)

# lets first convert/clean the names

ships_names <- janitor::clean_names(ships)

seabirds_names <- seabirds %>% 
  rename("species_common" = "Species common name (taxon [AGE / SEX / PLUMAGE PHASE])",
         "species_scientific" = "Species  scientific name (taxon [AGE /SEX /  PLUMAGE PHASE])"
         ) %>% 
janitor::clean_names()
seabirds_names

# before joining ship and bird tables, lets drop non-informative columns (for our analysis)

seabirds_reduced <- seabirds_names %>% 
  select(record, record_id, species_common, species_scientific,
         species_abbreviation, age, count, sex)

ships_reduced <- ships_names %>% 
  select(record, record_id, date, time, lat, long, ew, prec, wspeed, cld, seasn, latcell)

#both ships and seabird dataset have record numbering, lets rename to avoid confusion

seabirds_renamed <- rename(seabirds_reduced, "recordnr_seabird" = "record")

ships_renamed <- rename(ships_reduced, "recordnr_ships" = "record")

# joining data

seabirds_observed <- left_join(seabirds_renamed, ships_renamed, "record_id")

# in species names columns, "age" is included: lets drop that.
# possibilities: AD, SUBAD, IMM, JUV

seabirds_correct_name <- seabirds_observed %>% 
  mutate(species_common = 
           str_remove(species_common, " (AD|JUV|IMM|SUBAD)$")) %>% 
  mutate(species_abbreviation = 
           str_remove(species_abbreviation, " (AD|JUV|IMM|SUBAD)$")) %>%
  mutate(species_scientific = 
           str_remove(species_scientific, " (AD|JUV|IMM|SUBAD)$"))
seabirds_correct_name  

#check NAs for important columns
seabirds_correct_name %>% 
  select(species_common, species_scientific, species_abbreviation, count, lat, long) %>% 
  summarise(across(.fns = ~sum(is.na(.x))))

            