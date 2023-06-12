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
# and add a column at the start with the year.

#first simplify columns candy_2015
#candy_2015_simple_names <- 
  candy_2015 %>% 
  rename("age" = 2,
  "participate" = 3) %>% 
  mutate(year = "2015", .before = Timestamp) %>% 
  head()


#secondly, candy_2016
candy_2016 %>% 
  rename("age" = 4,
         "participate" = 2,
         "country" = 5,
         "address" = 6,
         "gender" = 3) %>% 
  mutate(year = "2016", .before = Timestamp)

#thirdly, candy_2017
candy_2017 %>% 
  rename("age" = 4,
         "participate" = 2,
         "country" = 5,
         "address" = 6,
         "gender" = 3) %>% 
  mutate(year = "2017", .before = `Internal ID`)