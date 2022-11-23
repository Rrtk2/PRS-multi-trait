#-----------------------------------------------------------------------------------------------------#
# 							GENERAL INFORMATION
#-----------------------------------------------------------------------------------------------------#
# File description:
#	Name
#		LDAK.R
#
#	Purpose 
#		This code was made as sub-master level regulation script.
#
# Author comment:
#	Rick A. Reijnders 
#	ra.reijnders@maastrichtuniversity.nl
#
#	Personal comment:
#		download via http://dougspeed.com/downloads2/
#			- download file
#			- run /_ldak-folder_/ldak5.2.linux
#			
#
#-----------------------------------------------------------------------------------------------------#
#							Main settings or load
#-----------------------------------------------------------------------------------------------------#
source("C:/DATA_STORAGE/Projects/PRS-multi-trait/Scripts/.Main/Settings.R")
require(data.table)

# first get the manifest and check processed 
f_getManifest(1)
f_getTraits()


# make PRS model for trait
f_calcPGS_LDAK(Trait="EduAtt")	
f_calcPGS_LDAK(Trait="Height22")
f_calcPGS_LDAK(Trait="AD")
f_calcPGS_LDAK(Trait="AD_jans")


#-----------------------------------------------------------------------------------------------------#
#							Cleanup
#-----------------------------------------------------------------------------------------------------#
Rclean() # remove all temp_ prefix variables

