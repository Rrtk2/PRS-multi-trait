# PRS-multi-trait


### Description
Generalizing summary statistics, calculation and prediction of multi-trait PRS scores.

### Installation
1) Download the latest release from github

2) Unzip the latest release (into the PRS-multi-trait folder)

3) Open the Settings.R script. (found in PRS-multi-trait folder/Scripts/.MAIN/)

4) Change the ``` s_ROOT_dir ``` from the predefied path to the path the PRS-multi-trait and save, and make sure this is defined using the global enviroment assignment using double arrow "<<-".  As example: ``` s_ROOT_dir <<- "C:/path/to/folder/PRS-multi-trait/" ```  

5) Open R(studio) and source the settings file to set up the file structure, install needed programs and data. As example: ```source("C:/path/to/folder/PRS-multi-trait/Settings.R") ```  

### Generate PGS models
1) Open R(studio) and source the settings file to set up the environment. As example: ```source("C:/path/to/folder/PRS-multi-trait/Settings.R") ```

2) f_calcPGS_LDAK()

### Calculate PGS scores for trait
1) Open R(studio) and source the settings file to set up the environment. As example: ```source("C:/path/to/folder/PRS-multi-trait/Settings.R") ```

2) f_predPRS()



### Workflow
![Workflow](https://github.com/Rrtk2/PRS-multi-trait/blob/main/Workflows/Workflow.png)

### Collaborators
Joshua Harvey

Rick Reijnders

Valentin Laroche 

Niko Amiri

Ehsan Pishva



### Contact
Rick Reijnders ra.reijnders@maastrichtuniversity.nl


### Status of project
Setting up repository from existing project.


### Copyright and authors
All code and documents in this folder was created by me or collaborators.
