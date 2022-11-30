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
#							Example 
#-----------------------------------------------------------------------------------------------------#
	source("C:/DATA_STORAGE/Projects/PRS-multi-trait/Scripts/.Main/Settings.R")

	f_getManifest(1)

	f_addGWAStoManifest(
		short=c("BMI"),
		n=c(755315), # default 10,000? @RRR discuss
		filename=c("D:/DATA_STORAGE/GWAS/BMI-new__UKBioBank_34_2018/BMI_2018-new__UKBioBank_34.txt"),
		year=c("2018"),
		trait=c("BMI"),
		DOI=c("?"),
		genomeBuild = c("?"),
		traitType = c("CONT"),
		rawSNPs = c("?"),
		finalModelSNPs = c("?"),
		modelRunningTime = c("?"),
		usedRefSet = c("?"),
		processed=c(0),
		FORCE = FALSE)

	source("C:/DATA_STORAGE/Projects/PRS-multi-trait/Scripts/.Main/Settings.R")

	f_getManifest(1)
	f_getTraits()

	f_prepareGWAS(trait = "BMI")

	f_calcPGS_LDAK(Trait = "BMI")
	f_calcPGS_LDAK(Trait = "Height22")



	# ADNI
		cohort_name = "ADNI_QC_EUR05_2"
		temp_bfile = paste0("C:/Users/p70072451/Downloads/ADNI/",cohort_name)
		temp_bfile3 = f_wslpath(temp_bfile)

		f_predPRS(bfile = temp_bfile3, Trait = "BMI")
		f_predPRS(bfile = temp_bfile3, Trait = "Height22")
		PGS_all = f_collect_all_PRS(cohort_name)
		plot(PGS_all)
		corrr = cor(PGS_all)
		diag(corrr) = 0
		corrplot::corrplot(corrr)
		

