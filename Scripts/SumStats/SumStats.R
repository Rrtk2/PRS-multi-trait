#-----------------------------------------------------------------------------------------------------#
# 							GENERAL INFORMATION
#-----------------------------------------------------------------------------------------------------#
# File description:
#	Name
#		SumStats.R
#
#	Purpose 
#		This code was made as sub-master level regulation script.
#
# Author comment:
#	Rick A. Reijnders 
#	ra.reijnders@maastrichtuniversity.nl
#
#	Personal comment:
#	Add info about standardized input
#
#-----------------------------------------------------------------------------------------------------#
#							Main settings or load
#-----------------------------------------------------------------------------------------------------#
source("C:/DATA_STORAGE/Projects/PRS-multi-trait/Scripts/.Main/Settings.R")

require(data.table)

#-----------------------------------------------------------------------------------------------------#
#							Temp placeholder of gwas manifest for eduYears, to get system running
#							@Josh this stuff here is non-perminent (TO SOME DEGREE!)
#-----------------------------------------------------------------------------------------------------#
# first get the manifest and check processed 
f_getManifest(1)


f_prepareGWAS(trait = "AD")

#-----------------------------------------------------------------------------------------------------#
#							output
#-----------------------------------------------------------------------------------------------------#
# save(Result,file = paste0(s_ROOT_dir,s_out_folder,"Example/Result.Rdata"))  # save in same folder, with name matching object

# save.image(paste0(s_ROOT_dir,s_out_folder,"DE/IMAGE_workspace.Rdata")) # save image

#-----------------------------------------------------------------------------------------------------#
#							Cleanup
#-----------------------------------------------------------------------------------------------------#
#Rclean() # remove all temp_ prefix variables