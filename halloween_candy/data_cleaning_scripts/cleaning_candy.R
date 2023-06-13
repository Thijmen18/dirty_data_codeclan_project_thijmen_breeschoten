# CodeClan dirty data project: Halloween Candy Data
# this script contains code to clean the raw data from files:
# 'boing-boing-candy-2015' & 'boing-boing-candy-2016' & 'boing-boing-candy-2017'

####### open & exploring data
library(tidyverse)
library(readxl)

candy_2015 <- read_excel("raw_data/boing-boing-candy-2015.xlsx")
candy_2016 <- read_excel("raw_data/boing-boing-candy-2016.xlsx")
candy_2017 <- read_excel("raw_data/boing-boing-candy-2017.xlsx")

names(candy_2015)
names(candy_2016)
names(candy_2017)
head(candy_2016)
view(candy_2015)
view(candy_2016)
view(candy_2017)

# Based on data exploration: 
# this is a questionaire during Halloween, over 3 consecutive years.
# generally most columns are existing in 3 files


#########
# STEP 1: lets get the column headers uniform!
# and add a column at the start with the year (to keep years separate after combining)

#first simplify columns candy_2015

candy_new_2015 <-  candy_2015 %>% 
  rename("age" = 2,
  "participate" = 3) %>% 
  
  mutate(year = "2015", .before = Timestamp) %>% 
  janitor::clean_names()

#secondly, candy_2016

candy_new_2016 <- candy_2016 %>% 
  rename("age" = 4,
         "participate" = 2,
         "country" = 5,
         "address" = 6,
         "gender" = 3) %>% 
  
  mutate(year = "2016", .before = Timestamp) %>% 
  janitor::clean_names()
  
#thirdly, candy_2017

candy_new_2017 <- candy_2017 %>% 
  rename("age" = 4,
         "participate" = 2,
         "country" = 5,
         "address" = 6,
         "gender" = 3) %>% 
  
  mutate(year = "2017", .before = `Internal ID`) %>% 
  janitor::clean_names() %>% 
  
  rename_with(.cols = starts_with("q6"), .fn = ~ str_remove(., "q6_"))

#setdiff(names(candy_new_2015), names(candy_new_2016))  
#setdiff(names(candy_new_2016), names(candy_new_2017))

#######
# STEP 2: lets drop columns in each dataset we do not need:
# for the analyses we need columns about/with: 
# - 'participate(trick/treat)'
# - 'age'
# - 'country'
# - 'columns with candy rating'
# - 'gender'


names(candy_new_2015)
candy_2015_reduced <- candy_new_2015 %>% 
  select(1:97) %>% # drop columns that are clearly not candy, uninformative or not needed
  select(-c(2, 8, 17, 18, 19, 24, 27, 28, 29, 34, 39, 40, 41, 42, 45, 46, 64, 67,
            82, 83, 85, 87, 89, 91, 94, 95, 96)) %>% 
  select(-c(6, 11, 25))

names(candy_new_2016)
candy_2016_reduced <- candy_new_2016 %>% 
  select(1:107) %>% 
  select(-c(2, 7, 9, 10, 13, 16, 20, 22, 23, 24, 27, 28, 30, 32, 33, 39, 44, 45,
            46, 50, 79, 80, 90, 91, 94, 95, 97, 99, 102, 103, 104, 105, 106))

names(candy_new_2017)
candy_2017_reduced <- candy_new_2017 %>% 
  select(1:110) %>% 
  select(-c(2, 7, 10, 13, 16, 20, 22, 23, 24, 27, 28, 30, 32, 33, 39, 44, 45,
            50, 70, 80, 82, 87, 92, 93, 96, 97, 98, 100, 102, 105, 106, 107, 108,
            109)) %>% 
  rename("mary_janes" = "anonymous_brown_globs_that_come_in_black_and_orange_wrappers_a_k_a_mary_janes")

#######
# STEP 4: lets add a few impoprtant columns to the 2015 dataset that are missing: 
candy_2015_add <- candy_2015_reduced %>% 
  mutate(country = NA, 
         gender = NA,
         .before = butterfinger)



janitor::compare_df_cols(candy_2015_add, candy_2016_reduced)




setdiff(candy_2015_reduced, candy_2016_reduced)
names(candy_2015_reduced)
names(candy_2016_reduced)





# STEP 3: Combine the datasets together now most columns are similar
# first focus on df 2016 and 2017!

# Because we do not want to loose columns in any df if not existing in another I 
# will first 'fill in non-overlapping columns with NAs:
candy_new_2016[setdiff(names(candy_new_2017), names(candy_new_2016))] <- NA
candy_new_2017[setdiff(names(candy_new_2016), names(candy_new_2017))] <- NA

candy_2016_2017 <- rbind(candy_new_2016, candy_new_2017)

candy_2016_2017 %>% 
  filter(year == 2017)

class(candy_new_2017)
candy_2016_2017 <- rbind(candy_new_2016, candy_new_2017)
