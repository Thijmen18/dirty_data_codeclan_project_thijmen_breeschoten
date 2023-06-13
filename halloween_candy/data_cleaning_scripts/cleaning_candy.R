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

#setdiff(names(candy_new_2015), names(candy_new_2016))  
#setdiff(names(candy_new_2016), names(candy_new_2017))

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

#names(candy_2015_add)
#names(candy_2016_longer)
#names(candy_2017_longer)

####### STEP 6: combining three datasets --------------------------------------
# lets combine all three datasets into a single file!

candy_total <- bind_rows(candy_2015_add, candy_2016_longer, candy_2017_longer)

names(candy_total)

######## STEP 7: check variable contents and clean --------------------------------------
# lets check if contents of each variable makes sense (or if cleaning is needed!)
# by checking with distinct(), I conclude that participate, gender, rating are all ok!

#COUNTRY
# Looking at distinct country values, it looks like age has been filled into 
# country for several rows
# lets change:
candy_total_swap <- candy_total %>% 
  mutate(age = if_else(age == is.na(age) &
                         str_detect(country, "^[0-9]+"),
                       country, age)
  )
candy_total %>% 
  filter(country == str_detect(country, "[0-9]+")) %>% 
  nrow()


#year is a character, age is a character -> change into numerical
candy_total_num <- candy_total %>% 
  mutate(year = as.numeric(year)) %>% 
  mutate(age = as.numeric(age))

# AGE
# let's check if there are any abnormal ages included. If so, round() or replace by NA
  # Assumption: I assume that any person between 3-100 years can fill in the questionnaire 
  # (potentially with help of supervisor), other ages are replaced by NA. 
candy_total_age_ok <- candy_total_num %>% 
  mutate(age = if_else(age >= 3 & age <=100, age, NA)) %>% 
  mutate(age = round(age)) #%>% 
  #distinct(age)  
  #print(n=85)

# Looking at distinct country values, it looks like age has been filled into country for several rows
# lets change:
candy_total %>% 
  mutate(age = if_else(age == is.na(age) &
                         country == str_detect(country, "^[0-9]+"),
                       country, age)
  )


candy_total_age_ok %>% 
  select(country) %>% 
  group_by(country) %>% 
  summarise(count = n())

# variable: participate, gender, rating are all ok!
  #candy_total_age_ok %>% 
  #  distinct(participate)
    #candy_total_age_ok %>% 
    #  distinct(gender)
      #candy_total_age_ok %>% 
      #  distinct(rating)

## It looks like in candy_2016 age column is mixed up with country column (age = NA, while country has an age)
  

