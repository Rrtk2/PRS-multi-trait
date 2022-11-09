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
#--LDpred YES

# make PRS model for trait
f_calcPGS_LDAK(Trait="EduAtt")	
f_calcPGS_LDAK(Trait="Height22")
f_calcPGS_LDAK(Trait="AD")
f_calcPGS_LDAK(Trait="AD_jans")

# check --cutoff

#-----------------------------------------------------------------------------------------------------#
#							Function
#-----------------------------------------------------------------------------------------------------#

f_calcPGS_LDAK = function(Trait = NA,Model = "bayesr"){
	#-----------------------------------------------------------------------------------------------------#
	#							Startup
	#-----------------------------------------------------------------------------------------------------#
	time1 = as.numeric(Sys.time())
	possiblemodels = c("bayesr") # @RRR need to add support for others!
	
	f_getManifest(1)
	Trait_index = which(Ref_gwas_manifest$short==Trait)
	
	#-----------------------------------------------------------------------------------------------------#
	#							Checks
	#-----------------------------------------------------------------------------------------------------#

	# check: if manifest Trait exists, else warning with options and return FAIL
	if(length(Trait_index)==0){
		warning("\n\nEntered trait('",Trait,"') does not match any of the existing traits in manifest!","\n","  Options:\n    - ",paste0(Ref_gwas_manifest$short,collapse = "\n    - "),"\n\n")
		return(message("calcPGS failed (Trait)!\n"))
	}
	
	# check: if model is any of the available ones
	
	if(!Model%in%possiblemodels){
		warning("\n\nEntered model('",Model,"') does not match any of the possible models supported!","\n","  Options:\n    - ",paste0(possiblemodels,collapse = "\n    - "),"\n\n")
		return(message("calcPGS failed (Model)!\n"))	
	}
	
	temp_manifest = Ref_gwas_manifest[Trait_index,]
	
	# show items
	{cat("#-----------------------------#\n")
	cat(paste0("Trait: ",Trait,"\n" ))
	cat(paste0("Generation of PRS model: ",Ref_gwas_manifest[Trait_index,"short"]," \n"))
	cat(paste0("Using: ",Model," \n"))
	cat("#-----------------------------#\n\n\n")}
	
	Sys.sleep(3) # to hava a brief moment to see what you selected
	
	#-----------------------------------------------------------------------------------------------------#
	#							Input
	#-----------------------------------------------------------------------------------------------------#
	# load(paste0(s_ROOT_dir,s_out_folder,"Example/Pheno.Rdata"))


	gwas_loc = paste0(s_ROOT_dir,s_out_folder,"DATA/gwas/",temp_manifest$short,".summaries")
		
		# load the gwas SumStat
		#load(gwas_loc)
		# resutls EduYears in example
	#}


	# https://dougspeed.com/summary-statistics/
	# SUMM STATS SHOULD:
	#
	# Predictor (Chr:bp)
	# A1 (test)
	# A2 (other)
	# n (num of samples)
	# 
	# Z 		or		Direction + Stat 	or 		Direction + p

	# REFORMAT the resulted summaries into temp object
	temp_gwas = data.table::fread(gwas_loc,header=TRUE) # fasterrr!
	# @RRR really make sure the part below is moved, then IN MANIFEST it is stated what type the trait is, then deal with this appropriately, as in mentioned above (Z 		or		Direction + Stat 	or 		Direction + p)
	# IF CASE is DIRECTION + pval (Cont. trait)
	# replaces temp_gwas

	
	#-----------------------------------------------------------------------------------------------------#
	#							Get refset if not ready (1000G)
	#-----------------------------------------------------------------------------------------------------#
	#@RRR FORCE DISABLED. NO CHECKS OF REFERENCE SET!!!
	#if(!fil e.exists(paste0(s_data_loc_ref,".flag"))){
	#	source(paste0(s_ROOT_dir,"Scripts/LDAK/Cal_Ref_1000G.R"))
	#}


	#-----------------------------------------------------------------------------------------------------#
	#							Prepare location and folders
	#-----------------------------------------------------------------------------------------------------#
	s_data_loc_ref2 = f_wslpath(s_data_loc_ref)
	s_ref_loc_final2 = f_wslpath(s_ref_loc_final)



	# Parameters for specific PRS models -> in models
	model_dir = paste0(s_ROOT_dir,s_out_folder,"DATA/models/")
	specifi_model_dir = paste0(model_dir,temp_manifest$short)
	specifi_model_dir2 = f_wslpath(specifi_model_dir)

	temp_summfile = paste0(s_ROOT_dir,s_out_folder,"DATA/gwas/",temp_manifest$short,".summaries") 
	temp_summfile2 = f_wslpath(temp_summfile)
	temp_summfile_pred = paste0(temp_summfile,"pred") 
	temp_summfile_pred2 = f_wslpath(temp_summfile_pred)
	
	# make dir if needed
	if(!dir.exists(paste0(specifi_model_dir))){dir.create(file.path(paste0(specifi_model_dir)))}

	#@RRR include this -> data.table::fwrite()
	#data.table::fwrite(temp_gwas,file = temp_summfile,row.names = FALSE,sep = "\t",quote = FALSE)
	data.table::fwrite(list(temp_gwas$Predictor),file = temp_summfile_pred,col.names=FALSE, row.names = FALSE,sep = "\t",quote = FALSE)
	rm(temp_gwas)

	#-----------------------------------------------------------------------------------------------------#
	#							PRS calculation
	#-----------------------------------------------------------------------------------------------------#
	s_ref_loc_finalfile = "megabayesr"
	#Model defaults "bayesr" # best in LDAK for now...

	#system(paste0("wsl cd ",specifi_model_dir2," ; ",s_ldak," --sum-hers ",s_data_loc_ref2,"ldak.thin --tagfile ",s_data_loc_ref2,"ldak.thin.tagging --summary ",temp_summfile2," --matrix ",s_data_loc_ref2,"ldak.thin.matrix"," --check-sums NO"))
	system(paste0("wsl cd ",specifi_model_dir2," ; ",s_ldak," --sum-hers ",s_data_loc_ref2,"gbr.hapmap --tagfile ",s_data_loc_ref2,"gbr.hapmap.bld.ldak.quickprs.tagging --summary ",temp_summfile2," --matrix ",s_data_loc_ref2,"gbr.hapmap.bld.ldak.quickprs.matrix"," --check-sums NO"))

	# construct prediction model
	if(Model=="bayesr"){
		system(paste0("wsl cd ",specifi_model_dir2,"; ",s_ldak,paste0(" --mega-prs ",s_ref_loc_finalfile," --model ",Model," --ind-hers ",s_data_loc_ref2,"gbr.hapmap.ind.hers --summary ",temp_summfile2," --cors ",s_data_loc_ref2,"gbr.hapmap --cv-proportion .1 --check-high-LD NO --window-kb 1000 --allow-ambiguous YES --extract ",temp_summfile_pred2," --max-threads 8")))
	}	# kb 1000
	# LDpred
	#system(paste0("wsl cd ",specifi_model_dir2,"; ",s_ldak,paste0(" --mega-prs ",s_ref_loc_finalfile," --model ","bolt"," --ind-hers ",s_data_loc_ref2,"gbr.hapmap.ind.hers --summary ",temp_summfile2," --cors ",s_data_loc_ref2,"gbr.hapmap --cv-proportion .1 --check-high-LD NO --window-kb 1000 --allow-ambiguous YES --extract ",temp_summfile_pred2," --max-threads 8 --LDpred YES"))) # kb 1000
	#	--ind-hers <indhersfile> - to specify the per-predictor heritabilities.
	#	--summary <sumsfile> - to specify the file containing the summary statistics.
	#	--cors <corstem> - to specify the predictor-predictor correlations.
	#   --LDpred YES potentially works like this???

	#get evaluation/ prs
	#system(paste0("wsl cd ",specifi_model_dir2," ; ",s_ldak," --calc-scores megabayesr --bfile ",s_ref_loc_final2," --scorefile megabayesr.effects --power 0 "))#--pheno quant.pheno @RRR this needs to be included in the end. now im testing with samples that do not have the phenotype; PRS should be "0" overall
	#system(paste0("wsl cd ",specifi_model_dir2," ; ",s_ldak," --jackknife megabayesr --profile megabayesr.profile --num-blocks 200"))

	# cleanup!
	#file.remove(temp_summfile)
	file.remove(temp_summfile_pred)
	
	# Check the number of SNPs in final model
	temp_model = data.table::fread(paste0(specifi_model_dir,"/",s_ref_loc_finalfile,".effects"),header = TRUE,sep = " ") # waaay faster now!
		

	# update manifest 
	time2 = as.numeric(Sys.time())
	Ref_gwas_manifest[Trait_index,"processed"] = 2
	Ref_gwas_manifest[Trait_index,"finalModelSNPs"] = dim(temp_model)[1]
	Ref_gwas_manifest[Trait_index,"modelRunningTime"] = round((time2-time1) / 60,0)
	Ref_gwas_manifest <<- Ref_gwas_manifest # this needs to be pushed into .globalenv
	rm(temp_model)
	f_saveManifest()
	
	{cat("\n\n#-----------------------------#\n")
	cat("Completed\n")
	cat(paste0("PRS model stored in:\n"))
	cat(paste0(specifi_model_dir2,"/",s_ref_loc_finalfile,".effects","\n"))
	cat(paste0("Took approx ", Ref_gwas_manifest[Trait_index,"modelRunningTime"] , " minutes.\n"))
	cat("#-----------------------------#\n")}

}

#-----------------------------------------------------------------------------------------------------#
#							Cleanup
#-----------------------------------------------------------------------------------------------------#
Rclean() # remove all temp_ prefix variables

