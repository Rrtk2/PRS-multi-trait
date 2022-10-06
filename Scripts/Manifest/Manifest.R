#-----------------------------------------------------------------------------------------------------#
# 							GENERAL INFORMATION
#-----------------------------------------------------------------------------------------------------#
# File description:
#	Name
#		Manifest.R
#
#	Purpose 
#		This code was made as sub-master level regulation script.
#
# Author comment:
#	Rick A. Reijnders 
#	ra.reijnders@maastrichtuniversity.nl
#
#	Personal comment:
#
#
#-----------------------------------------------------------------------------------------------------#
#							Main settings or load
#-----------------------------------------------------------------------------------------------------#
source("C:/DATA_STORAGE/Projects/PRS-multi-trait/Scripts/.Main/Settings.R")

#-----------------------------------------------------------------------------------------------------#
#							Temp placeholder of gwas manifest for eduYears, to get system running
#							@Josh this stuff here is absolutely non-perminent
#-----------------------------------------------------------------------------------------------------#

# Make temp Reference frame
Ref_gwas_manifest = data.frame(short=c("EduYears",NA),
	n=c(999999,NA),
	filename=c("D:/DATA_STORAGE/GWAS/Educational_attainment_2016/EduYears_Main.txt",NA),
	year=c("2016",NA),
	trait=c("Educational attainment",NA),
	processed=c(0,NA))



#-----------------------------------------------------------------------------------------------------#
#							output
#-----------------------------------------------------------------------------------------------------#
save(Ref_gwas_manifest,file = paste0(s_ROOT_dir,s_out_folder,"DATA/manifest/Ref_gwas_manifest.Rdata"))  # save in same folder, with name matching object

save.image(paste0(s_ROOT_dir,s_out_folder,"Manifest/IMAGE_workspace.Rdata")) # save image

#-----------------------------------------------------------------------------------------------------#
#							Cleanup
#-----------------------------------------------------------------------------------------------------#
Rclean() # remove all temp_ prefix variables