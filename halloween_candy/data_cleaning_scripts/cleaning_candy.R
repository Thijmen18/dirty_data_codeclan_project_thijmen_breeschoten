# CodeClan dirty data project: Halloween Candy Data
# this script contains code to clean the raw data from files:
# 'boing-boing-candy-2015' & 'boing-boing-candy-2016' & 'boing-boing-candy-2017'

#######STEP 0: open & exploring data --------------------------------------
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


#########STEP 1: column header uniform --------------------------------------
# lets get the column headers uniform!
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


#######STEP 2: drop and rename columns --------------------------------------
# lets drop columns in each dataset we do not need and rename columns that 
# are clearly spelled differently in another year.

# for the analyses we need columns about/with: 
# - 'participate(trick/treat)'
# - 'age'
# - 'country'
# - 'columns with candy rating'
# - 'gender'


#names(candy_new_2015)
candy_2015_reduced <- candy_new_2015 %>% 
  select(1:97) %>% # drop columns that are clearly not candy, uninformative or not needed
  select(-c(2, 8, 17, 18, 19, 24, 27, 28, 29, 34, 39, 40, 41, 42, 45, 46, 64, 67,
            82, 83, 85, 87, 89, 91, 94, 95, 96)) %>% 
  select(-c(6, 11, 25)) %>% 
  rename("100_grand_bar" = "x100_grand_bar")

#names(candy_new_2016)
candy_2016_reduced <- candy_new_2016 %>% 
  select(1:107) %>% 
  select(-c(2, 7, 9, 10, 13, 16, 20, 22, 23, 24, 27, 28, 30, 32, 33, 39, 44, 45,
            46, 50, 79, 80, 90, 91, 94, 95, 97, 99, 102, 103, 104, 105, 106)) %>% 
  rename("100_grand_bar" = "x100_grand_bar")

#names(candy_new_2017)
candy_2017_reduced <- candy_new_2017 %>% 
  select(1:110) %>% 
  select(-c(2, 7, 10, 13, 16, 20, 22, 23, 24, 27, 28, 30, 32, 33, 39, 44, 45,
            50, 70, 80, 82, 87, 92, 93, 96, 97, 98, 100, 102, 105, 106, 107, 108,
            109)) %>% 
  rename("mary_janes" = "anonymous_brown_globs_that_come_in_black_and_orange_wrappers_a_k_a_mary_janes")

####### STEP 4: transform datasets into long format --------------------------------------
# lets transform each dataset into a long format (better to have all candy varieties into one variable)

candy_2015_longer <- candy_2015_reduced %>% 
  pivot_longer(cols = 4:67,
               names_to = "candy_type",
               values_to = "rating")

candy_2016_longer <- candy_2016_reduced %>% 
  pivot_longer(cols = 6:74,
               names_to = "candy_type",
               values_to = "rating")

candy_2017_longer <- candy_2017_reduced %>% 
  pivot_longer(cols = 6:76,
               names_to = "candy_type",
               values_to = "rating")

####### STEP 5: adding important columns to 2015 dataset --------------------------------------
#  lets add a few impoprtant columns to the 2015 dataset that are missing: 
candy_2015_add <- candy_2015_longer %>% 
  mutate(country = NA, 
         gender = NA,
         .before = candy_type)



####### STEP 6: combining three datasets --------------------------------------
# lets combine all three datasets into a single file!

candy_total <- bind_rows(candy_2015_add, candy_2016_longer, candy_2017_longer)

             

######## STEP 7: check variable contents and clean --------------------------------------
# lets check if contents of each variable makes sense (or if cleaning is needed!)
# by checking with distinct(), I conclude that participate, gender, rating are all ok!

#COUNTRY
# Looking at distinct country values, it looks like age has been filled into 
# country for several rows
# lets change:

candy_total_clean_variables <- 
  candy_total %>% 
  mutate(age = if_else(is.na(age) & 
                         str_detect(country, "^[0-9]+"),
                       country, age)
         ) %>% 
  
# in country column there are various non-sensible answers. Let's clean.
# Assumptions/decissions: the analyses questions refer to "US, Canada, UK and other countries"
# so all countries with different spelling should be changed into single way of spelling.
# nonsense names are transformed to NA, and existing "other countries/areas" will be left as
# they appear, because I can bin them into a single category. First recode all to lower case.

  mutate(country = str_to_lower(country)) %>% 
  mutate(country = if_else(str_detect(country, "^[0-9]+"), NA, country)) %>% 
  mutate(country = recode(country, "not the usa or canada" = NA_character_)) %>% 
  mutate(country = if_else(str_detect(country, "usa"), "us", country)) %>% 
  mutate(country = recode(country,
                          "united states of america" = "us",
                          "united states" = "us",
                          "ussa" = "us",
                          "u.s.a." = "us",
                          "a tropical island south of the equator" = NA_character_,
                          "england" = "uk",
                          "murica" = "us",
                          "united kingdom" = "uk",
                          "neverland" = NA_character_,
                          "this one" = NA_character_,
                          "u.s." = "us",
                          "america" = "us",
                          "units states" = "us",
                          "cascadia" = NA_character_,
                          "there isn't one for old men" = NA_character_,
                          "one of the best ones" = NA_character_,
                          "the yoo ess of aaayyyyyy" = "us",
                          "united kindom" = "uk",
                          "somewhere" = NA_character_,
                          "god's country" = NA_character_,
                          "sub-canadian north america... 'merica" = "us",
                          "trumpistan" = "us",
                          "merica" = "us",
                          "see above" = "us",
                          "the republic of cascadia" = NA_character_,
                          "united stetes" = "us",
                          "denial" = NA_character_,
                          "united state" = "us",
                          "united staes" = "us",
                          "unhinged states" = "us",
                          "us of a" = "us",
                          "the united states" = "us",
                          "north carolina" = "us",
                          "unied states" = "us",
                          "earth" = NA_character_,
                          "u s" = "us",
                          "u.k." = "uk",
                          "the united states of america" = "us",
                          "unite states" = "us",
                          "insanity lately" = NA_character_,
                          "'merica" = "us",
                          "pittsburgh" = "us",
                          "a" = NA_character_,
                          "can" = "canada",
                          "canae" = "canada",
                          "new york" = "us",
                          "california" = "us",
                          "i pretend to be from canada, but i am really from the united states." = NA_character_,
                          "scotland" = "uk",
                          "united stated" = "us",
                          "ahem....amerca" = "us",
                          "ud" = NA_character_,
                          "new jersey" = "us",
                          "united ststes" = "us",
                          "united statss" ="us",
                          "endland" = "uk",
                          "atlantis" = NA_character_,
                          "murrika" = "us",
                          "alaska" = "us",
                          "soviet canuckistan" = "canada",
                          "n. america" = "us",
                          "narnia" = NA_character_,
                          "u s a" = "us",
                          "united statea" = "us",
                          "subscribe to dm4uz3 on youtube" = NA_character_,
                          "i don't know anymore" = NA_character_,
                          "fear and loathing" = NA_character_,
                          "united sates" = "us",
                          "united  states of america" = "us",
                          "unites states" = "us",
                          "canada`" = "canada"
                            )
         ) %>% 
# AGE and YEAR
  #year is a character, age is a character -> change into numerical (so below code will run)
  
  mutate(year = as.numeric(year)) %>% 
  mutate(age = as.numeric(age)) %>% 

# AGE
# let's check if there are any abnormal ages included. If so, round() or replace by NA
# Assumption: I assume that any person between 3-100 years can fill in the questionnaire 
# (potentially with help of supervisor), other ages are replaced by NA. 

  mutate(age = if_else(age >= 3 & age <=100, age, NA)) %>% 
  mutate(age = round(age))


  
  
  
  

