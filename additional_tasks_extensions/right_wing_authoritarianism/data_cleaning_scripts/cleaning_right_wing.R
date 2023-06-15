# CodeClan dirty data project: Right Wing Authoritarianism
# this script contains code to clean the raw data from files:
# 

#### Step 1: open and explore data

library(tidyverse)

rightwing <- read_csv("raw_data/rwa.csv")

view(rightwing)
names(rightwing)

#### Step 2: drop data columns we do not need.
# we need: average score of question 3-22 (Note: Q4, 6, 8, 9, 11, 13, 15, 18, 20, 21 are reverse scored!)
# total time taken for the survey (column: testelapse)
# column regarding participant (columns: education, gender, hand, familysize, age)

rightwing %>% 
  select(3:22, testelapse, education, gender, hand, familysize, age) %>% 
  mutate(Q4 = -Q4,
         Q6 = -Q6,
         Q8 = -Q8,
         Q9 = -Q9,
         Q11 = -Q11,
         Q13 = -Q13,
         )
  mutate(average_RWS)



