#-----------------------------------------------------------------------------------------------------#
# 							GENERAL INFORMATION
#-----------------------------------------------------------------------------------------------------#
# File description:
#	Name
#		Main.R
#
#	Purpose 
#		This code was made as master level regulation script.
#
# Author comment:
#	Rick A. Reijnders 
#	ra.reijnders@maastrichtuniversity.nl
#
#	Personal comment:
#	Keep naming objects clear, save objects with identical name with .rdata. save workspaces
# 	All variables not to be saved start with "temp_"; these are removed after saving workspace. 
#	This allows clear workspace when chaining phases/blocks of code.
#
# 	Structure is set up as followed:
#	CALL Settings.R IN EVERY SCRIPT: 
#		- Sets directory, makes folders if needed. This is the absolute ROOT of the results/scripts
#		- sets settings (like cutoffs, pvalue ect)
#		- CALL Functions.R
#			- gets all functions used, defined there. Also things like plotting/saving ect.
#  		- saves settings into file for consistent re-runs if needed. (all variables with prefix "s_" are saved as text)

#-----------------------------------------------------------------------------------------------------#
#							Main settings
#-----------------------------------------------------------------------------------------------------#
source("C:/DATA_STORAGE/Projects/PRS-multi-trait/Scripts/.Main/Settings.R")

#-----------------------------------------------------------------------------------------------------#
#							Phases
#-----------------------------------------------------------------------------------------------------#

# example phase / script block
source(paste0(s_ROOT_dir,"Scripts\\Example\\Example.R")) 

#-----------------------------------------------------------------------------------------------------#
#							FILE STRUCTURE
#-----------------------------------------------------------------------------------------------------#
# still need to make this into visualization



