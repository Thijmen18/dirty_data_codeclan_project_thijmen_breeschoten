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

#apply the function to each value of the column 
# (use function map for this https://purrr.tidyverse.org/reference/map.html)
# (advice received, use map_at() to do it in one line, for multiple columns (see below))


#rightwing_reversed_scores <- rightwing %>% 
#  mutate(Q4 = map(.x = rightwing$Q4, .f = reverse_scoring)) %>% 
#  mutate(Q6 = map(.x = rightwing$Q6, .f = reverse_scoring)) %>% 
#  mutate(Q8 = map(.x = rightwing$Q8, .f = reverse_scoring)) %>% 
#  mutate(Q9 = map(.x = rightwing$Q9, .f = reverse_scoring)) %>% 
#  mutate(Q11 = map(.x = rightwing$Q11, .f = reverse_scoring)) %>% 
#  mutate(Q13 = map(.x = rightwing$Q13, .f = reverse_scoring)) %>% 
#  mutate(Q15 = map(.x = rightwing$Q15, .f = reverse_scoring)) %>% 
#  mutate(Q18 = map(.x = rightwing$Q18, .f = reverse_scoring)) %>% 
#  mutate(Q20 = map(.x = rightwing$Q20, .f = reverse_scoring)) %>% 
#  mutate(Q21 = map(.x = rightwing$Q21, .f = reverse_scoring))

# alternative, much quicker:

rightwing_reversed_scores  <- rightwing %>% 
  map_at(c("Q4", "Q6", "Q8", "Q9", "Q11", "Q13", "Q15", "Q18", "Q20", "Q21"), .f = reverse_scoring) 
# outputs a list, lets change into df:
rightwing_reversed_scores <- as.data.frame(rightwing_reversed_scores)

#### Step 3:
# drop data columns we do not need
# we need: average score of question 3-22 (
# total time taken for the survey (column: testelapse)
# column regarding participant (columns: education, gender, hand, familysize, age)

cleaned_rightwing <- rightwing_reversed_scores %>% 
 # select(3:22, testelapse, education, gender, hand, familysize, age) %>% 
# lets introduce a ID per row
  mutate(userID = row_number(), .before = Q3) %>% 
# we want to get an average RWS score for questions 3-22 (questions 1-2 are 'warming up' questions)
  mutate(average_RWS = rowMeans(across(Q3:Q22)), .after = userID) %>% 
# no need for the remaining Qs
 select(userID, average_RWS, testelapse, education, gender, hand, familysize, age) %>% 

#### Step 4:
# let's recode some values, to give the table (and results later) more meaning!
  mutate(gender = recode(gender,
                         "Male" = 1,
                         "Female" = 2,
                         "Other" = 3),
         education = recode(education,
                            "Less than high school" = 1,
                            "High school" = 2,
                            "University degree" = 3,
                            "Graduate degree" = 4),
         hand = recode(hand,
                       "Right" = 1,
                       "Left" = 2,
                       "Both" = 3)
         ) %>% 
  
#### Step 5:
# Let's bin the ages together, so this is more informative
  mutate(age_groups = case_when(
    age < 18 ~ "Under 18",
    age >= 18 & =< 25 ~ "18 to 25",
    age >= 26 & =< 40 ~ "26 to 40",
    age >= 41 & =< 60 ~ "41 to 60",
    age > 60)
    )



  
  
  
  
  
  
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

