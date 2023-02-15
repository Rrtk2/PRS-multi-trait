#' calcPGS_LDAK
#' @return This function will perform the generation of the PGS model, of the given GWAS.
#' @param Trait Enter the unique GWAS trait ID of interest to be used in modelling the PGM. Can be observed by getTraits().
#' @param Model Enter the model to be used in modelling the PGM.
#' @examples calcPGS_LDAK(Trait = "Height",Model = "bayesr")
#' @export
calcPGS_LDAK = function(Trait = NA,Model = "bayesr"){

	#-----------------------------------------------------------------------------------------------------#
	#							Note
	#-----------------------------------------------------------------------------------------------------#

	# To do all instantly:
	#	for( i in which(Manifest_env$Ref_gwas_manifest$processed==1)){
	#		print(Manifest_env$Ref_gwas_manifest$short[i])
	#		calcPGS_LDAK(Trait = Manifest_env$Ref_gwas_manifest$short[i], Model = "bayesr")
	#	}
	
	#-----------------------------------------------------------------------------------------------------#
	#							Startup
	#-----------------------------------------------------------------------------------------------------#
	time1 = as.numeric(Sys.time())
	
	
	getManifest()
	Trait_index = which(Manifest_env$Ref_gwas_manifest$short==Trait)
	
	#-----------------------------------------------------------------------------------------------------#
	#							Checks
	#-----------------------------------------------------------------------------------------------------#

	# check: if manifest Trait exists, else warning with options and return FAIL
	if(length(Trait_index)==0){
		warning("\n\nEntered trait('",Trait,"') does not match any of the existing traits in manifest!","\n","  Options:\n    - ",paste0(Manifest_env$Ref_gwas_manifest$short,collapse = "\n    - "),"\n\n")
		return(message("calcPGS failed (Trait)!\n"))
	}
	
	# check: if model is any of the available ones
	possiblemodels = c("lasso","lasso-sparse", "ridge", "bolt", "bayesr", "bayesr-shrink") # 
	if(!Model%in%possiblemodels){
		warning("\n\nEntered model('",Model,"') does not match any of the possible models supported!","\n","  Options:\n    - ",paste0(possiblemodels,collapse = "\n    - "),"\n\n")
		return(message("calcPGS failed (Model)!\n"))	
	}
	
	temp_manifest = Manifest_env$Ref_gwas_manifest[Trait_index,]
	
	# show items
	{cat("#-----------------------------#\n")
	cat(paste0("Trait: ",Trait,"\n" ))
	cat(paste0("Generation of PRS model: ",Manifest_env$Ref_gwas_manifest[Trait_index,"short"]," \n"))
	cat(paste0("Using: ",Model," \n"))
	cat("#-----------------------------#\n\n\n")}
	
	Sys.sleep(3) # to hava a brief moment to see what you selected
	
	#-----------------------------------------------------------------------------------------------------#
	#							Input
	#-----------------------------------------------------------------------------------------------------#
	# load(paste0(Settings_env$s_ROOT_dir,Settings_env$s_out_folder,"Example/Pheno.Rdata"))


	gwas_loc = paste0(Settings_env$s_ROOT_dir,Settings_env$s_out_folder,"DATA/gwas/",temp_manifest$short,".summaries")
		
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
	#if(!fil e.exists(paste0(Settings_env$s_data_loc_ref,".flag"))){
	#	source(paste0(Settings_env$s_ROOT_dir,"Scripts/LDAK/Cal_Ref_1000G.R"))
	#}


	#-----------------------------------------------------------------------------------------------------#
	#							Prepare location and folders
	#-----------------------------------------------------------------------------------------------------#
	Settings_env$s_data_loc_ref2 = wslPath(Settings_env$s_data_loc_ref)
	Settings_env$s_ref_loc_final2 = wslPath(Settings_env$s_ref_loc_final)



	# Parameters for specific PRS models -> in models
	model_dir = paste0(Settings_env$s_ROOT_dir,Settings_env$s_out_folder,"DATA/models/")
	specifi_model_dir = paste0(model_dir,temp_manifest$short)
	specifi_model_dir2 = wslPath(specifi_model_dir)

	temp_summfile = paste0(Settings_env$s_ROOT_dir,Settings_env$s_out_folder,"DATA/gwas/",temp_manifest$short,".summaries") 
	temp_summfile2 = wslPath(temp_summfile)
	temp_summfile_pred = paste0(temp_summfile,"pred") 
	temp_summfile_pred2 = wslPath(temp_summfile_pred)
	
	# make dir if needed
	if(!dir.exists(paste0(specifi_model_dir))){dir.create(file.path(paste0(specifi_model_dir)))}

	#@RRR include this -> data.table::fwrite()
	#data.table::fwrite(temp_gwas,file = temp_summfile,row.names = FALSE,sep = "\t",quote = FALSE)
	data.table::fwrite(list(temp_gwas$Predictor),file = temp_summfile_pred,col.names=FALSE, row.names = FALSE,sep = "\t",quote = FALSE)
	rm(temp_gwas)

	#-----------------------------------------------------------------------------------------------------#
	#							PRS calculation
	#-----------------------------------------------------------------------------------------------------#
	#Settings_env$s_ref_loc_finalfile = "megabayesr"
	#Model defaults "bayesr" # best in LDAK for now...

	#system(paste0("wsl cd ",specifi_model_dir2," ; ",Settings_env$s_ldak," --sum-hers ",Settings_env$s_data_loc_ref2,"ldak.thin --tagfile ",Settings_env$s_data_loc_ref2,"ldak.thin.tagging --summary ",temp_summfile2," --matrix ",Settings_env$s_data_loc_ref2,"ldak.thin.matrix"," --check-sums NO"))
	endcode = system(paste0("wsl cd ",specifi_model_dir2," ; ",Settings_env$s_ldak," --sum-hers ",Settings_env$s_data_loc_ref2,"gbr.hapmap --tagfile ",Settings_env$s_data_loc_ref2,"gbr.hapmap.bld.ldak.quickprs.tagging --summary ",temp_summfile2," --matrix ",Settings_env$s_data_loc_ref2,"gbr.hapmap.bld.ldak.quickprs.matrix"," --check-sums NO --cutoff 0.01")) 
	# @RRR check cutoff, the APOE snps actually meet this!!!

		# check: if failed sum heritabilities
		if(endcode!=0){
			warning("\n\nSummation heritabilities calcualtion failed!\n\n")
			return(message("Final error code: ",endcode,"\n"))
			endcode = 0
		}

	# construct prediction model
	#if(Model=="bayesr"){
	system(paste0("wsl cd ",specifi_model_dir2,"; ",Settings_env$s_ldak,paste0(" --mega-prs ",Model," --model ",Model," --ind-hers ",Settings_env$s_data_loc_ref2,"gbr.hapmap.ind.hers.positive --summary ",temp_summfile2," --cors ",Settings_env$s_data_loc_ref2,"gbr.hapmap --cv-proportion .1 --check-high-LD NO --window-kb 1000 --allow-ambiguous NO --extract ",temp_summfile_pred2," --max-threads 8")))
	#}	# kb 1000
	#@RRR check high-LD YES!? -> solve this
	#@RRR chcek kb -> cm
		# check: if failed construct prediction model
		if(endcode!=0){
			warning("\n\nConstruction of prediction model failed!\n\n")
			return(message("Final error code: ",endcode,"\n"))
			endcode = 0
		}
	
	# LDpred
	#system(paste0("wsl cd ",specifi_model_dir2,"; ",Settings_env$s_ldak,paste0(" --mega-prs ",Settings_env$s_ref_loc_finalfile," --model ","bolt"," --ind-hers ",Settings_env$s_data_loc_ref2,"gbr.hapmap.ind.hers --summary ",temp_summfile2," --cors ",Settings_env$s_data_loc_ref2,"gbr.hapmap --cv-proportion .1 --check-high-LD NO --window-kb 1000 --allow-ambiguous YES --extract ",temp_summfile_pred2," --max-threads 8 --LDpred YES"))) # kb 1000
	#	--ind-hers <indhersfile> - to specify the per-predictor heritabilities.
	#	--summary <sumsfile> - to specify the file containing the summary statistics.
	#	--cors <corstem> - to specify the predictor-predictor correlations.
	#   --LDpred YES potentially works like this???

	#get evaluation/ prs
	#system(paste0("wsl cd ",specifi_model_dir2," ; ",Settings_env$s_ldak," --calc-scores megabayesr --bfile ",Settings_env$s_ref_loc_final2," --scorefile megabayesr.effects --power 0 "))#--pheno quant.pheno @RRR this needs to be included in the end. now im testing with samples that do not have the phenotype; PRS should be "0" overall
	#system(paste0("wsl cd ",specifi_model_dir2," ; ",Settings_env$s_ldak," --jackknife megabayesr --profile megabayesr.profile --num-blocks 200"))

	# cleanup!
	#file.remove(temp_summfile)
	file.remove(temp_summfile_pred)
	
	# Check the number of SNPs in final model
	temp_model = data.table::fread(paste0(specifi_model_dir,"/",Model,".effects"),header = TRUE,sep = " ") # waaay faster now!
		

	# update manifest 
	time2 = as.numeric(Sys.time())
	Manifest_env$Ref_gwas_manifest[Trait_index,"processed"] = 2
	Manifest_env$Ref_gwas_manifest[Trait_index,"finalModelSNPs"] = dim(temp_model)[1]
	Manifest_env$Ref_gwas_manifest[Trait_index,"modelRunningTime"] = round((time2-time1) / 60,0)
	#@RRR add total effect
	#Manifest_env$Ref_gwas_manifest <<- Manifest_env$Ref_gwas_manifest # this needs to be pushed into .globalenv
	rm(temp_model)
	saveManifest()
	
	{cat("\n\n#-----------------------------#\n")
	cat("Completed\n")
	cat(paste0("PRS model stored in:\n"))
	cat(paste0(specifi_model_dir2,"/",Model,".effects","\n"))
	cat(paste0("Took approx ", Manifest_env$Ref_gwas_manifest[Trait_index,"modelRunningTime"] , " minutes.\n"))
	cat("#-----------------------------#\n")}

}