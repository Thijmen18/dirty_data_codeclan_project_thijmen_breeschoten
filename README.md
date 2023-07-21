# README 

README file for the repo `dirty_data_codeclan_project_thijmen_breeschoten`

## OVERVIEW

This repo contains the analysis projects for the 
CodeClan - Professional Data Analyses Course - student cohort DE21

### Dirty Data Project

Goal of the project task is to clean and analyse a raw "dirty" dataset in order to answer 
several questions regarding the data.

__For an overview of the individual tasks, cleaning and analyses please read the task-specific
documentation:__

* Task 3: 
  dirty_data_codeclan_project_thijmen_breeschoten/sea_bird_observation/`README_analyses_overview.Rmd`
  
* Task 4:
  dirty_data_codeclan_project_thijmen_breeschoten/halloween_candy/documentation_and_analysis/`analysing_candy.Rmd`
  
* Task 5:
  folder: `additional_tasks_extensions/right_wing_authoritarianism` is an additional extension task.


### Project tasks

* Task 3: Seabird observations

          Data contents:
          The raw data contains seabird observations/sightings as done from ships in the seas 
          around New Zealand. The raw data (.xls file) contains two worksheets with:
          1) ship data.
          2) bird data (counts+names).
          
* Task 4: Halloween Candy
  
          Data contents:
          The raw data contains results from a questionnaire regarding halloween/trick or           treat candy.
          The data is open-access and available here: 
          https://www.scq.ubc.ca/so-much-candy-data-seriously/ <br>
          The questionnaires are taken in three consecutive years (2015, 2016, 2017), and
          the results can be found in three separate .xlsx files: <br>
          - `boing-boing-candy-2015.xlsx`   <br>
          - `boing-boing-candy-2016.xlsx`   <br>
          - `boing-boing-candy-2017.xlsx`   <br>
          
* Task 5: Right Wing Authoritarianism (additional, extra task)
          Data contents:
          The raw data contains the results from a questionnaire regarding right_wing 
          authoritarianism preferences among respondents.

## FILE AND FOLDER OVERVIEW
For an overview of the individual tasks, cleaning and analyses please read the task-specific
documentation:

* Task 3: 
  dirty_data_codeclan_project_thijmen_breeschoten/sea_bird_observation/`README_analyses_overview.Rmd`
  
* Task 4:
  dirty_data_codeclan_project_thijmen_breeschoten/halloween_candy/documentation_and_analysis/`analysing_candy.Rmd`
  
### Task 3 - Seabird data

**Language, software and packages used**

  * The code is written in R (version 4.3.0)
    R Core Team (2023). _R: A Language and Environment for Statistical Computing_. 
    R Foundation for Statistical Computing, Vienna, Austria.
   <https://www.R-project.org/>

  * R is run in Rstudio 2023.03.0+386 

  * The following libraries are required:
    cleaning_seabirds.R
      - `tidyverse`(ver 2.0.0)
      - `readxl` (ver 1.4.2)
    analysing_seabirds.Rmd
      - `tidyverse`(ver 2.0.0)
  
**File and folder overview**

  The project folder `sea_bird_observation` contains the .Rproj file.
  The following files are included and distributed in each folder:

  * clean_data <br>
    - `seabirds_cleaned.csv` cleaned dataset using script 'cleaning_seabirds.R' <br>
  * data_cleaning_scripts <br>
    - `cleaning_seabirds.R` Rscript to read and clean the raw data file. <br>
  * documentation_and_analysis <br>
    - `analysing_seabirds.Rmd` (and knitted html file) Rnotebook script to analyse the
      cleaned dataset in order to answer the analyses questions. <br>
  * raw_data <br>
    - `seabirds.xls` raw dataset in xls format <br>
    
### Task 4 - Halloween Candy

**Language, software and packages used**

  * The code is written in R (version 4.3.0)
    R Core Team (2023). _R: A Language and Environment for Statistical Computing_. 
    R Foundation for Statistical Computing, Vienna, Austria.
    <https://www.R-project.org/>

  * R is run in Rstudio 2023.03.0+386 

  * The following libraries are required (specified per script):
    cleaning_candy.R
      - `tidyverse`(ver 2.0.0)
      - `readxl` (ver 1.4.2)
    analysing_candy.Rmd
      - `tidyverse`(ver 2.0.0)
  
**File and folder overview**

  The Rproject folder `halloween_candy` contains the .Rproj file and the following 
  folders.
  The following files are included and distributed in each folder:

  * clean_data <br>
       - `candy_cleaned.csv` cleaned dataset using script 'cleaning_candy.R' <br>
  * data_cleaning_scripts <br>
       - `cleaning_candy.R` Rscript to read and clean the raw data file. <br>
  * documentation_and_analysis <br>
       - `analysing_candy.Rmd` (and knitted html file) Rnotebook script presenting an 
       overview and background information regarding the project and analyses. 
       It further presents the script/code to analyse the cleaned dataset in order 
       to answer the analyses questions. <br>
  * raw_data <br>
        - ``boing-boing-candy-2015.xlsx`, `boing-boing-candy-2016.xlsx`,                                       `boing-boing-candy-2017.xlsx` raw datasets in xlsx format. <br>
        
### Task 5 - extension/additional - Right Wing Authoritarianism

**Language, software and packages used**

* The code is written in R (version 4.3.0)
    R Core Team (2023). _R: A Language and Environment for Statistical Computing_. 
    R Foundation for Statistical Computing, Vienna, Austria.
    <https://www.R-project.org/>

  * R is run in Rstudio 2023.03.0+386 

  * The following libraries are required (specified per script):
    cleaning_right_wing.R
      - `tidyverse`(ver 2.0.0)
      - `readxl` (ver 1.4.2)
    rightwing_analysing.Rmd
      - `tidyverse`(ver 2.0.0)
      
**File and folder overview**

  The Rproject folder `/additional_tasks_extensions/right_wing_authoritarianism` 
  contains the .Rproj file and the following 
  folders.
  The following files are included and distributed in each folder:

  * clean_data <br>
       - `rightwing_cleaned.csv` cleaned dataset using script 'cleaning_right_wing.R' <br>
  * data_cleaning_scripts <br>
       - `cleaning_right_wing.R` Rscript to read and clean the raw data file. <br>
  * documentation_and_analysis <br>
       - `rightwing_analysing.Rmd` (and knitted html file) Rnotebook script analysing
       the cleaned dataset in order to answer the analyses questions. 
       It presents the script/code to analyse the cleaned dataset in order 
       to answer the analyses questions. <br>
  * raw_data <br>
        - `rwa.csv`, raw datasets in csv format. 
        - `rwa_codebook.txt`, explanatory file regarding the raw dataset <br>
