# Height toy example PGS
This example will show you how:
  - to generate a PGS model
  - to calculate the PGS scores

This page will help you in starting to work with this workflow. In this example, a toy dataset and GWAS is used to calculate the height of a cohort. This instruction assumes you were able to generate the '.summaries' file in the desired file format, stored on the correct location (and metadata stored in the Manifest). In this example the toy GWAS is called 'test_height.summaries', and is stored in PRS-multi-trait\Data_QC\Test_branch\DATA\gwas. The Manifest file contains this toy GWAS with corresponding name (columm: short) 'test_height'. 


# Instructions
### Source
Before running anything, source the settings

```source("C:/path/to/folder/PRS-multi-trait/Scripts/.Main/Settings.R") ```  

### Check
Load the manifest, and look at the traits specifically
``` f_getManifest(1) ```

``` f_getTraits() ```

This should result in a list similar to below

Trait:	|	Description: 
------------------- | ---------------------- 
EduAtt	|	Educational attainment
Heigth	|	LDAK dedicated heigth example
AD_jans	|	AD of janssen
AD	|	AD
Height22	|	HEIGHT 2022 YENGO
**test_height**	|	description

### Generate PGS models
Generate the PGS models on trait 'test_height'. supported models untill now are 'bayesr'.

``` f_calcPGS_LDAK(Trait = "test_height", Model = "bayesr") ``` 

### Calculate PGS scores for trait
Calculate PGS scores for trait 'test_height', using the example toy data included (found at "PRS-multi-trait/Data_RAW/Example/1000G_phase3_final_2"). Make sure the bfiles are put to the linux-based location (starting with /mnt/c/..; this can be done using function f_wslpath("C:/path")). OverlapSNPsOnly is set to FALSE as default, this ensures the PGS-es are generated using ALL SNPS in from the model, this can be overruled by setting "OverlapSNPsOnly" to TRUE. If there is very little overlap between your data and the SNPS needed in the model, it is unadvised to continue, but can be overruled by setting "Force" to TRUE.

``` f_predPRS(bfile = f_wslpath("C:/path/to/folder/PRS-multi-trait/Data_RAW/Example/1000G_phase3_final_2"), Trait = "test_height", OverlapSNPsOnly=FALSE, Force = FALSE) ``` 

### Getting your PGS
For now, the results are stored in "C:/path/to/folder/PRS-multi-trait/Data_QC/Test_branch/Predict". The worflow generates a tab-delimited file with 6 columns: ID1,	ID2,	Phenotype,	Covariates,	Profile_1 and	BLANK. The 5th column, Profile_1, are the PGS scores per sample.

The naming of the files is as follows:\
[COHORT]_[TRAIT].profile

>> Rick needs to complete this further! <<




