#-----------------------------------------------------------------------------------------------------#
# 							GENERAL INFORMATION
#-----------------------------------------------------------------------------------------------------#
# File description:
#	Name
#		Predict.R
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
f_getManifest(1)

#-----------------------------------------------------------------------------------------------------#
#							Dedicated function
#-----------------------------------------------------------------------------------------------------#
# moved to Functions.R 
# 			 f_predPRS(bfile = temp_bfile2, Trait = 2)

#-----------------------------------------------------------------------------------------------------#
#							Data selection and example
#-----------------------------------------------------------------------------------------------------#
warning("(Predict.R)    !!! There is an example here, should be removed! !!!!")
#temp_bfile = "C:/DATA_STORAGE/Projects/PRS-multi-trait/Data_RAW/Test_dataset/data/human"
#temp_bfile2 = paste0(gsub(temp_bfile,pattern = "C:/",replacement = "/mnt/c/"))

temp_adni_bfile = "C:/Users/p70072451/Downloads/ADNI/ADNI_QC_EUR05_2"
temp_adni_bfile2 = paste0(gsub(temp_adni_bfile,pattern = "C:/",replacement = "/mnt/c/"))

#f_predPRS(bfile = temp_bfile2, Trait = "EduYears")
f_getTraits()
f_predPRS(bfile = temp_adni_bfile2, Trait = "EduAtt")
f_predPRS(bfile = temp_adni_bfile2, Trait = "AD")
#-----------------------------------------------------------------------------------------------------#
#							output
#-----------------------------------------------------------------------------------------------------#
# save(Result,file = paste0(s_ROOT_dir,s_out_folder,"Example/Result.Rdata"))  # save in same folder, with name matching object

# save.image(paste0(s_ROOT_dir,s_out_folder,"DE/IMAGE_workspace.Rdata")) # save image

#-----------------------------------------------------------------------------------------------------#
#							Cleanup
#-----------------------------------------------------------------------------------------------------#
Rclean() # remove all temp_ prefix variables