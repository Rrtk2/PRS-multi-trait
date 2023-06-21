# PRS-multi-trait


### Description
PRS-multi-trait is an R package that focuses on using generalized summary statistics, calculation and prediction of multi-trait polygenic (risk) scores (PGS) to predict the likelihood of an individual developing a particular trait or disease based on their genetic risk factors. The package includes functions for calculating PGS for individuals based on the presence of specific genetic variants that have been associated with the trait or disease in question. PRS-multi-trait is designed to be user-friendly and easy to use, with a range of functions and documentation to help users get started quickly. Whether you are a researcher or practitioner in the field of genetics and genomics, or simply interested in exploring the genetic basis of complex traits and diseases, PRS-Multi-trait can help you generate PGS models and calculate PGS for your cohort. The method is useful for a wide range of applications, including identifying individuals who may be at risk of developing complex diseases such as diabetes or Alzheimer's disease, as well as for predicting scores for more straightforward traits such as height or eye color.


This package has shiny-app support, we reccomend it!

---

###  Install Windows Subsystem for Linux (WSL)
Open windows powershell (powershell.exe)
```
wsl --install
```

## Quick installation in R
First, you need to install the devtools package. You can do this from CRAN.
```
install.packages("devtools")
```

To install the RRtest package
```
devtools::install_github("Rrtk2/PRS-multi-trait/Package/PRSMultiTrait")
```

To get the dependencies and models
```
library("PRSMultiTrait")
PRSMultiTrait::installDependenciesAndData()
```

To make sure the b-files have correct IDs to work with this package.
```
PRSMultiTrait::checkDataIDs("path/to/b-files.bim")
```

To run the shiny app to have a user-friendly interface
```
PRSMultiTrait::runPGSApp()
```

---



<details>
<summary>

### Example usage

</summary>

Look at this [example](https://github.com/Rrtk2/PRS-multi-trait/blob/main/Protocols/Example_running_PGSV2.md) to generate a PGS model and afterward to calculate the PGS scores on an toy example.

It breaks down to:
- ``` calcPGS_LDAK(Trait = "Trait", Model = "bayesr") ``` 
- ``` predPRS(bfile = "Cohort Files", Trait = "Trait") ``` 
- ``` collect_all_PRS(cohort = "Cohort Name") ``` 

---

</details>




<details>
<summary>

### Functions

</summary>
The PRSMultiTrait package contains several functions that can be used to calculate polygenic risk scores (PRS) for multiple traits using genome-wide association studies (GWAS) data. Here is a brief overview of the main functions in the package:


| Function        | Description                     |
|-----------| ----------------------------------|
| ``` installDependenciesAndData() ```  |Installs the programs and data required to run the package. |
| ``` getManifest(1) ```  |Retrieves the manifest file containing information about the GWAS studies used in the package.|
| ``` getTraits() ```  |Shows the available traits from the manifest.|
| ``` addGWAStoManifest() ```  |Adds a new GWAS study to the manifest.|
| ``` removeGWASfromManifest() ```  |Removes a GWAS study from the manifest.|
| ``` modifyGWASinManifest() ```  |Modifies a GWAS study in the manifest.|
| ``` calcPGS_LDAK(Trait, Model) ```  |Calculates a PGS model for the specified trait using the specified model.|
| ``` predPRS(bfile, Trait, OverlapSNPsOnly, Force) ```  |Predicts PRS values using the newly made model.|
| ``` collect_all_PRS(cohort) ```  |Collects PRS values for the specified cohort.|
 
 
Please note that this is a summary of the main functions of the package, and the package documentation should be consulted for more detailed information on how to use them.

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

Jarno Koetsier

Niko Amiri

Ehsan Pishva


### Status of project
Setting up repository from existing project.

---

</details>


### Contact
Rick Reijnders ra.reijnders@maastrichtuniversity.nl



### Copyright and authors
All code and documents in this folder was created by me or [collaborators](https://github.com/Rrtk2/PRS-multi-trait/blob/main/AUTHORS.md).
