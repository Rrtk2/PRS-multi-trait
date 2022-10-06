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
#
#
#-----------------------------------------------------------------------------------------------------#
#							Main settings or load
#-----------------------------------------------------------------------------------------------------#
source("C:/DATA_STORAGE/Projects/PRS-multi-trait/Scripts/.Main/Settings.R")

#-----------------------------------------------------------------------------------------------------#
#							Temp placeholder of gwas manifest for eduYears, to get system running
#							@Josh this stuff here is non-perminent (TO SOME DEGREE!)
#							Making subset of top 1000 snps FOR SPEED AND TEST
#-----------------------------------------------------------------------------------------------------#
# first get the manifest and check processed 
f_getManifest(1)

if(length(which(Ref_gwas_manifest$processed==0))!=0){
	for(i in 1:which(Ref_gwas_manifest$processed==0)){
		temp_manifest = Ref_gwas_manifest[i,]
		
		temp_gwas = read.table(temp_manifest$filename,header = TRUE,sep = "\t")
		
		
		# -temp- filter! @RRR needs to be removed
		temp_psign = -log10(temp_gwas$Pval)
		temp_gwas = temp_gwas[order(temp_psign,decreasing = T),][1:1000,]
		
		# assign to short name, then store
		assign(x=temp_manifest$short, temp_gwas)
		save(list=c(temp_manifest$short),file = paste0(s_ROOT_dir,s_out_folder,"DATA/gwas/",temp_manifest$short,".Rdata")) # @RRR OPTIONAL. This is only for loading in R. This line should be commented out at some point
		write.table(get(temp_manifest$short),file = paste0(s_ROOT_dir,s_out_folder,"DATA/gwas/",temp_manifest$short,".summaries"),row.names = FALSE,sep = "\t",quote = FALSE)
		
		# update settings
		Ref_gwas_manifest[i,"processed"] = 1
	}

	# Update manifest
	save(Ref_gwas_manifest,file = paste0(s_ROOT_dir,s_out_folder,"DATA/manifest/Ref_gwas_manifest.Rdata"))  # save in same folder, with name matching object
}

#-----------------------------------------------------------------------------------------------------#
#							output
#-----------------------------------------------------------------------------------------------------#
# save(Result,file = paste0(s_ROOT_dir,s_out_folder,"Example/Result.Rdata"))  # save in same folder, with name matching object

# save.image(paste0(s_ROOT_dir,s_out_folder,"DE/IMAGE_workspace.Rdata")) # save image

#-----------------------------------------------------------------------------------------------------#
#							Cleanup
#-----------------------------------------------------------------------------------------------------#
#Rclean() # remove all temp_ prefix variables