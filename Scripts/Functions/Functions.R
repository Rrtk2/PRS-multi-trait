#-----------------------------------------------------------------------------------------------------#
# 							GENERAL INFORMATION
#-----------------------------------------------------------------------------------------------------#
# File description:
#	Name
#		Functions.R
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
#							Main Functions
#-----------------------------------------------------------------------------------------------------#
#Get active manifest info
f_getManifest = function(printManifest=FALSE){
	load(file = paste0(s_ROOT_dir,s_out_folder,"DATA/manifest/Ref_gwas_manifest.Rdata"),envir = .GlobalEnv) 
	if(printManifest){
		cat("GWAS manifest file (Ref_gwas_manifest):\n\n")
		print(Ref_gwas_manifest)
		cat("\n\n")
	}
}

# get available traits
f_getTraits = function(printManifest=FALSE){
	load(file = paste0(s_ROOT_dir,s_out_folder,"DATA/manifest/Ref_gwas_manifest.Rdata")) 
	cat("GWAS manifest (loaded from file)\n\n")
	cat("Trait:\t|\tDescription:\n")
	cat("-----------------------------------------\n")
	cat(apply(data.frame(short = Ref_gwas_manifest$short,trait = Ref_gwas_manifest$trait),1,function(x){paste0(x,collapse = "\t|\t")}),sep = "\n")
	cat("\n\n")
}





#Save manifest
f_saveManifest = function(){
	save(Ref_gwas_manifest,file = paste0(s_ROOT_dir,s_out_folder,"DATA/manifest/Ref_gwas_manifest.Rdata"))  # save in same folder, with name matching object
}

#-----------------------------------------------------------------------------------------------------#
#							PRS predict
#-----------------------------------------------------------------------------------------------------#

f_predPRS = function(bfile = NA, Trait = NA){

	#-----------------------------------------------------------------------------------------------------#
	#							Startup
	#-----------------------------------------------------------------------------------------------------#
	# first get the manifest and check processed 	
	f_getManifest(1)
	
	Trait_index = which(Ref_gwas_manifest$short==Trait)
	
	# check: if manifest Trait exists, else warning with options and return FAIL
	if(length(Trait_index)==0){
		warning("\n\nEntered trait('",Trait,"') does not match any of the existing traits in manifest!","\n","  Options:\n    -",paste0(Ref_gwas_manifest$short,collapse = "\n    -"),"\n\n")
		return(message("predPRS failed!\n"))
	}
	

	# show info
	{cat("#-----------------------------------#\n")
	cat(paste0("Trait: ",Trait,"\n" ))
	cat(paste0("Calculation of PRS scores of: ",Ref_gwas_manifest[Trait_index,"short"]," \n"))
	cat(paste0("Data: ",gsub(bfile,pattern = "^.*./",replacement = ""), "\n"))
	cat("#-----------------------------------#\n\n\n")}
	temp_data_name = gsub(bfile,pattern = "^.*./",replacement = "")
	temp_manifest = Ref_gwas_manifest[Trait_index,]
	Sys.sleep(1) # to hava a brief moment to see what you selected
	
	#-----------------------------------------------------------------------------------------------------#
	#							parameters
	#-----------------------------------------------------------------------------------------------------#
	# Parameters for specific PRS models -> in models
	model_dir = paste0(s_ROOT_dir,s_out_folder,"DATA/models/")
	specifi_model_dir = paste0(model_dir,temp_manifest$short)
	specifi_model_dir2 = paste0(gsub(specifi_model_dir,pattern = "C:/",replacement = "/mnt/c/"))



	#-----------------------------------------------------------------------------------------------------#
	#							Main algorithm
	#-----------------------------------------------------------------------------------------------------#
	temp_outfile = paste0(s_ROOT_dir,s_out_folder,"Predict/",temp_data_name,"_",temp_manifest$short)
	temp_outfile2 = paste0(gsub(temp_outfile,pattern = "C:/",replacement = "/mnt/c/"))

	#get evaluation/ prs
	system(paste0("wsl cd ",specifi_model_dir2," ; ",s_ldak," --calc-scores ",temp_outfile2," --bfile ",bfile," --scorefile megabayesr.effects --power 0 "))#--pheno quant.pheno @RRR this needs to be included in the end. now im testing with samples that do not have the phenotype; PRS should be "0" overall

	
	{cat("\n\n#-----------------------------#\n")
	cat("Completed\n")
	cat(paste0("Found in:\n"))
	cat(paste0(temp_outfile2,"\n"))
	cat("#-----------------------------#\n")}
}


#-----------------------------------------------------------------------------------------------------#
#							PLOTTING 
#-----------------------------------------------------------------------------------------------------#

# Auto generate high res images. PDF and TIFF at location given below
# default is 7 inch; this is now 480 (px?) in this function (so both pdf and tidd scale nice)
Rplot = function(insert=NA,title="Temp_title",resolution = 350, width = 480, height = 480){
	pdf(paste0(s_figure_folder,title,".pdf"),width = width/(480/7),height = height/(480/7)) 
		print({insert})
	dev.off()


	tiff(paste0(s_figure_folder,title,".tiff"),width = width*(resolution/72), height = height*(resolution/72),res = resolution)
		print({insert})
	dev.off()
}

#-----------------------------------------------------------------------------------------------------#
#							Cleanup
#-----------------------------------------------------------------------------------------------------#
Rclean = function(){
	rm(list=ls(envir = .GlobalEnv)[grep(ls(envir = .GlobalEnv),pattern = "^temp_")],envir = .GlobalEnv)
}

#-----------------------------------------------------------------------------------------------------#
#							output
#-----------------------------------------------------------------------------------------------------#

