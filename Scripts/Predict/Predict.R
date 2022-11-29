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

temp_adni_bfile = "C:/Users/p70072451/Downloads/ADNI/ADNI_QC_EUR05_2"
temp_adni_bfile2 = f_wslpath(temp_adni_bfile)

#f_predPRS(bfile = temp_bfile2, Trait = "EduYears")
f_getTraits()
f_predPRS(bfile = temp_adni_bfile2, Trait = "EduAtt", OverlapSNPsOnly = TRUE, Force = TRUE)
f_predPRS(bfile = temp_adni_bfile2, Trait = "AD", OverlapSNPsOnly = TRUE, Force = TRUE)
f_predPRS(bfile = temp_adni_bfile2, Trait = "Height22", OverlapSNPsOnly = TRUE, Force = TRUE)
f_predPRS(bfile = temp_adni_bfile2, Trait = "AD_jans", OverlapSNPsOnly = TRUE, Force = TRUE)



#-----------------------------------------------------------------------------------------------------#
#							output
#-----------------------------------------------------------------------------------------------------#
# save(Result,file = paste0(s_ROOT_dir,s_out_folder,"Example/Result.Rdata"))  # save in same folder, with name matching object

# save.image(paste0(s_ROOT_dir,s_out_folder,"DE/IMAGE_workspace.Rdata")) # save image

#-----------------------------------------------------------------------------------------------------#
#							Cleanup
#-----------------------------------------------------------------------------------------------------#
Rclean() # remove all temp_ prefix variables

#-----------------------------------------------------------------------------------------------------#
#							NOTES
#-----------------------------------------------------------------------------------------------------#

if(0){
	temp_bfile = "C:/Users/p70072451/Downloads/ADNI/ADNI_QC_EUR05"

	system(paste0(s_plinkloc," --bfile ", temp_bfile, " --set-all-var-ids @:# --make-bed --out ",paste0(temp_bfile,"_out1")))
	system(paste0(s_plinkloc," --bfile ", paste0(temp_bfile,"_out1"), " --rm-dup --make-bed --out ",paste0(temp_bfile,"_out2")))
	system(paste0(s_plinkloc," --bfile ", paste0(temp_bfile,"_out1"), " --exclude ",paste0(temp_bfile,"_out2.rmdup.mismatch")," --make-bed --out ",paste0(temp_bfile,"_2")))

	temp_bfile = "C:/Users/p70072451/Downloads/ADNI/ADNI_QC_EUR05_2"
	temp_bfile3 = f_wslpath(temp_bfile)
	f_predPRS(bfile = temp_bfile3, Trait = 1)
}


if(0){
	temp_bfile = "C:/DATA_STORAGE/Projects/PRS-multi-trait/Data_RAW/1000G_phase3_final"

	system(paste0(s_plinkloc," --bfile ", temp_bfile, " --set-all-var-ids @:# --make-bed --out ",paste0(temp_bfile,"_out1")))
	system(paste0(s_plinkloc," --bfile ", paste0(temp_bfile,"_out1"), " --extract C:/Users/p70072451/Downloads/extractSNPAs.txt --make-bed --out ",paste0(temp_bfile,"_2")))

	
}



plink --bfile C:/Users/p70072451/Downloads/ADNI/ADNI_QC_EUR05 --set-all-var-ids @:# --make-bed --out C:/Users/p70072451/Downloads/ADNI/ADNI_QC_EUR05_chr_bp



	system(paste0(s_plinkloc," --bfile ", paste0(temp_bfile,"_out1"), " --rm-dup --make-bed --out ",paste0(temp_bfile,"_out2")))
	system(paste0(s_plinkloc," --bfile ", paste0(temp_bfile,"_out1"), " --exclude ",paste0(temp_bfile,"_out2.rmdup.mismatch")," --make-bed --out ",paste0(temp_bfile,"_2")))