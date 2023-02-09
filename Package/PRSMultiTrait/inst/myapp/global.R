
# Requared packages
library(tidyverse)
library(corrr)
library(ggdendroplot) # devtools::install_github("nicolash2/ggdendroplot")
library(patchwork)
library(DT)
library(shinyWidgets)
library(shinycssloaders)
library(shinyFiles)
library("PRSMultiTrait")
#PRSMultiTrait::installDependenciesAndData()

# Get manifest
getManifest()
Traits <- Manifest_env$Ref_gwas_manifest$short
Models <- c("lasso","lasso-sparse", "ridge", "bolt", "bayesr", "bayesr-shrink")

