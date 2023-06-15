# CodeClan dirty data project: Right Wing Authoritarianism
# this script contains code to clean the raw data from files:
# 

#### Step 1: open and explore data

library(tidyverse)

rightwing <- read_csv("raw_data/rwa.csv")

view(rightwing)
names(rightwing)

#### Step 2: reverse the scores of  Q4, 6, 8, 9, 11, 13, 15, 18, 20, 21

# we write a function for the calculation:
reverse_scoring <- function(x) {
  
  10-x
  
}


rightwing_reversed_scores <- rightwing %>% 
  mutate(Q4 = map(.x = rightwing$Q4, .f = reverse_scoring)) %>% 
  mutate(Q6 = map(.x = rightwing$Q6, .f = reverse_scoring)) %>% 
  mutate(Q8 = map(.x = rightwing$Q8, .f = reverse_scoring)) %>% 
  mutate(Q9 = map(.x = rightwing$Q9, .f = reverse_scoring)) %>% 
  mutate(Q11 = map(.x = rightwing$Q11, .f = reverse_scoring)) %>% 
  mutate(Q13 = map(.x = rightwing$Q13, .f = reverse_scoring)) %>% 
  mutate(Q15 = map(.x = rightwing$Q15, .f = reverse_scoring)) %>% 
  mutate(Q18 = map(.x = rightwing$Q18, .f = reverse_scoring)) %>% 
  mutate(Q20 = map(.x = rightwing$Q20, .f = reverse_scoring)) %>% 
  mutate(Q21 = map(.x = rightwing$Q21, .f = reverse_scoring))
  
view(rightwing_reversed_scores)

#################
#Further attempts
################### 

rightwing %>% 
map_at(c("Q4", "Q6"), reverse_scoring)


# and a for loop to do this repeatedly for all columns

columnname <- c("Q4", "Q6")

for (column in columnname) {
  test <- mutate(rightwing, column = reverse_scoring("column"))
}





rightwing %>% 
  mutate(Q4 = reverse_scoring(Q4)) %>% 
  view()


rightwing %>% 
 mutate(Q4 = 10-Q4) %>% 
  view()


#### Step 2: drop data columns we do not need.
# we need: average score of question 3-22 (Note: Q4, 6, 8, 9, 11, 13, 15, 18, 20, 21 are reverse scored!)
# total time taken for the survey (column: testelapse)
# column regarding participant (columns: education, gender, hand, familysize, age)

rightwing_reduced <- rightwing %>% 
  select(3:22, testelapse, education, gender, hand, familysize, age) %>% 
  mutate(Q4 = rev(Q4),
         Q6 = rev(Q6),
         Q8 = rev(Q8),
         Q9 = rev(Q9),
         Q11 = rev(Q11),
         Q13 = rev(Q13),
         Q15 = rev(Q15),
         Q18 = rev(Q18),
         Q20 = rev(Q20),
         Q21 = rev(Q21)) %>%
  mutate(userID = row_number(), .before = Q3) %>% 
  mutate(average_RWS = rowMeans(across(Q3:Q22)), .after = userID) 

#### Step 3: 
# drop all Q columns (you have calculated the average) and read file to clean csv

rightwing_reduced %>% 
  select(userID, average_RWS, testelapse, education, gender, hand, familysize, age) %>% 
  write.csv(file = "clean_data/rightwing_cleaned.csv")

