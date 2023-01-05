# PRS-multi-trait


### Description
PRS-multi-trait is an R package that focuses on using generalized summary statistics, calculation and prediction of multi-trait polygenic (risk) scores (PGS) to predict the likelihood of an individual developing a particular trait or disease based on their genetic risk factors. The package includes functions for calculating PGS for individuals based on the presence of specific genetic variants that have been associated with the trait or disease in question. PRS-multi-trait is designed to be user-friendly and easy to use, with a range of functions and documentation to help users get started quickly. Whether you are a researcher or practitioner in the field of genetics and genomics, or simply interested in exploring the genetic basis of complex traits and diseases, PRS-Multi-trait can help you generate PGS models and calculate PGS for your cohort. The method is useful for a wide range of applications, including identifying individuals who may be at risk of developing complex diseases such as diabetes or Alzheimer's disease, as well as for predicting scores for more straightforward traits such as height or eye color.



---

### Quick installation in R
First, you need to install the devtools package. You can do this from CRAN.
```
install.packages("devtools")
```

To install the RRtest package
```
devtools::install_github("Rrtk2/PRS-multi-trait/Package/PRSMultiTrait")
```
---





<details>
<summary>

### Install Package

</summary>

#### Installation (old)
1) Download the [latest release](https://github.com/Rrtk2/PRS-multi-trait/archive/refs/tags/v0.4.zip) from github

2) Unzip the latest release (into the PRS-multi-trait folder)

3) Open the Settings.R script. (found in PRS-multi-trait folder/Scripts/.MAIN/)

4) Change the ``` s_ROOT_dir ``` from the predefied path to the path the PRS-multi-trait and save, and make sure this is defined using the global enviroment assignment using double arrow "<<-".  As example: ``` s_ROOT_dir <<- "C:/path/to/folder/PRS-multi-trait/" ```  

5) Open R(studio) and source the settings file to set up the file structure, install needed programs and data. As example: ```source("C:/path/to/folder/PRS-multi-trait/Scripts/.Main/Settings.R") ```  

---

</details>

<details>
<summary>

### Example usage

</summary>

Look at this [example](https://github.com/Rrtk2/PRS-multi-trait/blob/main/Protocols/Example_running_PGS.md) to generate a PGS model and afterward to calculate the PGS scores on an toy example.


#### Interacting with Manifest
 ``` f_getManifest(1) ```    -   Loads manifest into memory and show manifest

 ``` f_saveManifest ```    -   Saves manifest onto disk

 ``` f_getTraits ```    -   Shows the available traits to be used

 ``` f_addGWAStoManifest ```    -   Adds a new line to the manifest, fill in all information.

 ``` f_removeGWASfromManifest ```    -   Removes a line from the manifest.

 ``` f_modifyGWASinManifest ```    -    Changes a line in manifest


#### Generate PGS models
1) Open R(studio) and source the settings file to set up the environment. As example: ```source("C:/path/to/folder/PRS-multi-trait/Scripts/.Main/Settings.R") ```

2)  ``` f_calcPGS_LDAK() ``` 

#### Calculate PGS scores for trait
1) Open R(studio) and source the settings file to set up the environment. As example: ```source("C:/path/to/folder/PRS-multi-trait/Scripts/.Main/Settings.R") ```

2)  ``` f_predPRS() ``` 

---

</details>


<details>
<summary>

### Workflow and collaborators

</summary>

![Workflow](https://github.com/Rrtk2/PRS-multi-trait/blob/main/Workflows/Workflow.png)

### Collaborators
Rick Reijnders

Joshua Harvey

Valentin Laroche 

Niko Amiri

Ehsan Pishva


### Status of project
Setting up repository from existing project.

---

</details>


### Contact
Rick Reijnders ra.reijnders@maastrichtuniversity.nl



### Copyright and authors
All code and documents in this folder was created by me or collaborators.
