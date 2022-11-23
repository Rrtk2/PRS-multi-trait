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
# 							initialize 
#-----------------------------------------------------------------------------------------------------#
source("C:/DATA_STORAGE/Projects/PRS-multi-trait/Scripts/.Main/Settings.R")

#-----------------------------------------------------------------------------------------------------#
#							main functions
#-----------------------------------------------------------------------------------------------------#
# So there are many functions acting as wrappers.

# f_predPRS				# predict the PGS score given the model
# f_calcPGS_LDAK		# Calculate the PGS model
# f_collect_all_PRS		# Collect all the calculated PGS scores 

# f_getManifest			# load the Manifest into memory
# f_saveManifest		# Save the Manifest on disk

# f_getTraits			# Get all the Traits in Manifest

# f_windowspath			# Convert a linux path to windows path
# f_wslpath				# Convert a windows path to linux path

# Rclean				# Clean all the 'temp_' prefix variables from environment
# Rplot					# Plotting



#-----------------------------------------------------------------------------------------------------#
#							Inital Startup
#-----------------------------------------------------------------------------------------------------#
# to run and install the workflow run the source:
# source("C:/DATA_STORAGE/Projects/PRS-multi-trait/Scripts/.Main/Settings.R")
