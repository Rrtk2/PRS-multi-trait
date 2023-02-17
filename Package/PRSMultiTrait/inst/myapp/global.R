
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

# local variables
# @RRR This needs to be hidden, could refer to the manifest, or dedicated shiny envir? else the global workspace gets messy.
# Maybe just indeed sth like Server_env
# Using the Manifest_env!
	Manifest_env$Traits <- Manifest_env$Ref_gwas_manifest$short
	Manifest_env$Models <- c("lasso","lasso-sparse", "ridge", "bolt", "bayesr", "bayesr-shrink")
	
	# Define specific traits to be able to be processed at specific parts of the shiny app.
	# Idea is that IF a PGM is already generated, you dont need to regenerate it again.
	Manifest_env$Traits_PRE <- Manifest_env$Traits[Manifest_env$Ref_gwas_manifest$processed == 0]
	Manifest_env$Traits_PGM <- Manifest_env$Traits[Manifest_env$Ref_gwas_manifest$processed == 1]
	Manifest_env$Traits_PGS <- Manifest_env$Traits[Manifest_env$Ref_gwas_manifest$processed == 2]
