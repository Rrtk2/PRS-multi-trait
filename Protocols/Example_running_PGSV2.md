# PRSMultiTrait Package Instruction Manual

The PRSMultiTrait package is a tool for calculating polygenic risk scores (PRS) for multiple traits using genome-wide association studies (GWAS) data. This instruction manual will guide you through the process of installing, running, and using the package.

## Installation
Install the devtools package by running the following command in R: install.packages("devtools")

Download the PRSMultiTrait package by running the following command in R: devtools::install_github("Rrtk2/PRS-multi-trait/Package/PRSMultiTrait")

Load the library by running the following command in R: library(PRSMultiTrait)

Install the programs needed and data required by running the following command in R: installDependenciesAndData()

## Using the Package
### Getting the Manifest
The manifest is a file that contains information about the GWAS studies that are used in the package. To view the manifest, run the following command in R:  ``` getManifest(1) ``` 

To only show the available traits, run the following command in R: ``` getTraits() ``` 

### Modifying the Manifest
To add a new GWAS study to the manifest, use the following command in R:  ``` addGWAStoManifest() ``` 

To remove a GWAS study from the manifest, use the following command in R:  ``` removeGWASfromManifest() ``` 

To modify a GWAS study in the manifest, use the following command in R:  ``` modifyGWASinManifest() ``` 

## Running a Toy Example
In this example, we will use a toy dataset and GWAS to calculate the height of a cohort. This instruction assumes you were able to generate the '.summaries' file in the desired file format, stored on the correct location (and metadata stored in the Manifest). In this example the toy GWAS is called 'test_height.summaries', and is stored in PRS-multi-trait\Data_QC\Test_branch\DATA\gwas. The Manifest file contains this toy GWAS with corresponding name (columm: short) 'test_height'. 

Please add in more info about using prepareGWAS(trait = "Trait")

To calculate the PGS model, run the following command in R: ```  calcPGS_LDAK(Trait = "test_height", Model = "bayesr") ``` 

To predict using the newly made model, run the following command in R:
 ``` predPRS(bfile = wslPath(paste0(Settings_env$s_ROOT_dir,"Reference/Example/1000G_phase3_final_2")), Trait = "test_height", OverlapSNPsOnly=FALSE, Force = FALSE) ``` 

To get the PRS values in R, run the following command in R:  ``` df_Result_PGS = collect_all_PRS(cohort = "1000G_phase3_final_2") ``` 

## Note
The instructions above are a summary of the basic functionalities of the PRSMultiTrait package, and it is recommended to consult the package documentation for more detailed information and troubleshooting.

Please note that this package is still under development, be sure to check the package documentation for the latest updates, and if you find any issues please report it to the package developer.
