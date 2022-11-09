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
Ref_gwas_manifest = data.frame(short=c("EduAtt"),
	n=c(765283),
	filename=c("D:/DATA_STORAGE/GWAS/Educational_attainment_2022/EA4_additive_excl_23andMe.txt/EA4_additive_excl_23andMe.txt"),
	year=c("2022"),
	trait=c("Educational attainment"),
	DOI=c("10.1038/s41588-022-01016-z"),
	genomeBuild = c("GRCh37"),
	traitType = c("CONT"),
	rawSNPs = c("?"),
	finalModelSNPs = c("?"),
	modelRunningTime = c("?"),
	usedRefSet = c("?"),
	processed=c(0))
	
f_saveManifest()



# this part adds a gwas summary stat
if(TRUE){
	f_getManifest(1)
	temp_man = data.frame(short=c("Heigth"),
		n=c(424),
		filename=c("C:/DATA_STORAGE/Projects/PRS-multi-trait/Data_RAW/Test_dataset/data/quant.summaries"),
		year=c("?"),
		trait=c("LDAK dedicated heigth example"),
		DOI=c("?"),
		genomeBuild = c("?"),
		traitType = c("CONT"),
		rawSNPs = c("?"),
		finalModelSNPs = c("?"),
		modelRunningTime = c("?"),
		usedRefSet = c("?"),
		processed=c(0))
	
	Ref_gwas_manifest[dim(Ref_gwas_manifest)[1]+1,] = temp_man
	f_saveManifest()	
}

# this part adds a gwas summary stat
if(TRUE){
	f_getManifest(1)
	temp_man = data.frame(short=c("Height22"),
		n=c(1572323),
		filename=c("D:/DATA_STORAGE/GWAS/Height_2022/GIANT_HEIGHT_YENGO_2022_GWAS_SUMMARY_STATS_EUR.tsv"),
		year=c("2022"),
		trait=c("HEIGHT 2022 YENGO"),
		DOI=c("https://doi.org/10.1101/2022.01.07.475305"),
		genomeBuild = c("?"),
		traitType = c("CONT"),
		rawSNPs = c("?"),
		finalModelSNPs = c("?"),
		modelRunningTime = c("?"),
		usedRefSet = c("?"),
		processed=c(0))
	
	Ref_gwas_manifest[dim(Ref_gwas_manifest)[1]+1,] = temp_man
	f_saveManifest()	
}


# this part adds a gwas summary stat
if(TRUE){
	f_getManifest(1)
	temp_man = data.frame(short=c("AD_jans"),
		n=c(360257),
		filename=c("D:/DATA_STORAGE/GWAS/ALZ_dementia_2019/AD_sumstats_Jansenetal_2019sept.txt"),
		year=c("2019"),
		trait=c("AD of janssen"),
		DOI=c("?"),
		genomeBuild = c("?"),
		traitType = c("CAT"),
		rawSNPs = c("?"),
		finalModelSNPs = c("?"),
		modelRunningTime = c("?"),
		usedRefSet = c("?"),
		processed=c(0))
	
	Ref_gwas_manifest[dim(Ref_gwas_manifest)[1]+1,] = temp_man
	f_saveManifest()	
}


# this part adds a gwas summary stat
if(TRUE){
	f_getManifest(1)
	temp_man = data.frame(short=c("AD"),
		n=c(360823),
		filename=c("D:/DATA_STORAGE/GWAS/AD_IGAP/IGAP_stage_1.txt"),
		year=c("2013"),
		trait=c("AD"),
		DOI=c("10.1038/ng.2802"),
		genomeBuild = c("GRCh37"),
		traitType = c("CAT"),
		rawSNPs = c("?"),
		finalModelSNPs = c("?"),
		modelRunningTime = c("?"),
		usedRefSet = c("?"),
		processed=c(0))
	
	Ref_gwas_manifest[dim(Ref_gwas_manifest)[1]+1,] = temp_man
	f_saveManifest()	
}

#-----------------------------------------------------------------------------------------------------#
#							show final
#-----------------------------------------------------------------------------------------------------#

f_getManifest(1)
#-----------------------------------------------------------------------------------------------------#
#							output
#-----------------------------------------------------------------------------------------------------#
#save(Ref_gwas_manifest,file = paste0(s_ROOT_dir,s_out_folder,"DATA/manifest/Ref_gwas_manifest.Rdata"))  # save in same folder, with name matching object

#save.image(paste0(s_ROOT_dir,s_out_folder,"Manifest/IMAGE_workspace.Rdata")) # save image

#-----------------------------------------------------------------------------------------------------#
#							Cleanup
#-----------------------------------------------------------------------------------------------------#
Rclean() # remove all temp_ prefix variables