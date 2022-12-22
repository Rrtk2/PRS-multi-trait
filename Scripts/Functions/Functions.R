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
#							Other fucntions
#-----------------------------------------------------------------------------------------------------#
# this function should be on the top to avoid possible confusion about functions not loaded before getting used
# this function gets the current path and acesses it via wsl
# so from C:/ to /mnt/c/ 
# ONLY works with single letter drives
# checks where is the first ':' then uses that as a reference
f_wslpath = function(localpath){
	temp_drive = gsub(localpath,pattern = "/.*$",replacement = "")
	wsl_drive = paste0("/mnt/",tolower(substr(temp_drive ,1,1)),"/")
	
	temp_path = substr(localpath,(unlist(gregexpr(':', localpath))[1] + 2),nchar(localpath))
	
	
	return(paste0(wsl_drive,temp_path))
}

f_windowspath = function(localpath){
	wsl_drive = gsub(localpath,pattern = "^/mnt/(?=[A-z])|/.*$",replacement = "",perl=TRUE)
	wind_drive = paste0(toupper(wsl_drive),":/")
	
	
	
	temp_path = gsub(localpath,pattern = "^/mnt/[A-z]/",replacement = "",perl=TRUE)
	
	
	return(paste0(wind_drive,temp_path))
}

#-----------------------------------------------------------------------------------------------------#
#							Manifest Functions
#-----------------------------------------------------------------------------------------------------#
#Get active manifest info
f_getManifest = function(printManifest=FALSE){
	load(file = paste0(Settings_env$s_ROOT_dir,s_out_folder,"DATA/manifest/Manifest_env$Ref_gwas_manifest.Rdata"),envir = .GlobalEnv) 
	if(printManifest){
		cat("GWAS manifest file (Manifest_env$Ref_gwas_manifest):\n\n")
		print(Manifest_env$Ref_gwas_manifest)
		cat("\n\n")
	}
}


#Save manifest
f_saveManifest = function(){
	save(Manifest_env$Ref_gwas_manifest,file = paste0(Settings_env$s_ROOT_dir,s_out_folder,"DATA/manifest/Manifest_env$Ref_gwas_manifest.Rdata"))  # save in same folder, with name matching object
}

# get available traits
f_getTraits = function(){
	# Get manifest
	f_getManifest() 
	cat("GWAS manifest (loaded from file)\n\n")
	cat("Trait:\t|\tDescription:\n")
	cat("-----------------------------------------\n")
	cat(apply(data.frame(short = Manifest_env$Ref_gwas_manifest$short,trait = Manifest_env$Ref_gwas_manifest$trait),1,function(x){paste0(x,collapse = "\t|\t")}),sep = "\n")
	cat("\n\n")
}

# Add a trait / GWAS
f_addGWAStoManifest = function(
	short=c("UniqueTraitName"),
	n=c(10000), # default 10,000? @RRR discuss
	filename=c("?"),
	year=c("?"),
	trait=c("?"),
	DOI=c("?"),
	genomeBuild = c("?"),
	traitType = c("?"),
	rawSNPs = c("?"),
	finalModelSNPs = c("?"),
	modelRunningTime = c("?"),
	usedRefSet = c("?"),
	processed=c(0),
	FORCE = FALSE){
		# Get manifest
		f_getManifest()
		
		# Collect data in df style
		temp_man = data.frame(short = short,
			n=n,
			filename=filename,
			year=year,
			trait=trait,
			DOI=DOI,
			genomeBuild = genomeBuild,
			traitType = traitType,
			rawSNPs = rawSNPs,
			finalModelSNPs = finalModelSNPs,
			modelRunningTime = modelRunningTime,
			usedRefSet = usedRefSet,
			processed=processed)
			
		# First check the items to be added
		apply(temp_man,2,function(x){cat(paste0(x,"\n"))})
		
			
		# input? FORCE
		if(!FORCE){
			cat("\n>> Press [y] if information correct, then press [ENTER] <<")
			check = readline()
			if(check!="y"){
				return(message("Adding GWAS to Manifest aborted."))
			}
		}
		
		if(temp_man$short%in%Manifest_env$Ref_gwas_manifest$short){
			message("Adding GWAS to Manifest failed!")
			return(message("'short' name is taken! Please check the input or make another unique name."))
		}
			
		# Inplement data
		Manifest_env$Ref_gwas_manifest[dim(Manifest_env$Ref_gwas_manifest)[1]+1,] = temp_man
		Manifest_env$Ref_gwas_manifest <<- Manifest_env$Ref_gwas_manifest
		
		# Save manifest
		f_saveManifest()
		f_getManifest(1)
}

# Remove a trait / GWAS
f_removeGWASfromManifest = function(
	trait=c("UniqueTraitName"),
	FORCE = FALSE){
		# Get manifest
		f_getManifest()
		
		# check if trait exists
		if(sum(Manifest_env$Ref_gwas_manifest$short%in%trait) == 0){
			message("Trait('",trait,"') not found!")
			message("  Options:\n    - ",paste0(Manifest_env$Ref_gwas_manifest$short,collapse = "\n    - "))
			return(message("Removing GWAS from Manifest failed."))
		}
		
		# input? FORCE
		if(!FORCE){
			cat(paste0("Are you sure you want to remove trait ('",trait,"')?\n"))
			cat("This means you are removing line:\n\n")
			cat(paste0(Manifest_env$Ref_gwas_manifest[Manifest_env$Ref_gwas_manifest$short%in%trait,],"\n"))
			cat("\n>> Press [y] if information correct, then press [ENTER] <<")
			check = readline()
			if(check!="y"){
				return(message("Removing GWAS from Manifest aborted."))
			}
		}
		
					
		# Inplement data
		Manifest_env$Ref_gwas_manifest = Manifest_env$Ref_gwas_manifest[!Manifest_env$Ref_gwas_manifest$short%in%trait,]
		Manifest_env$Ref_gwas_manifest <<- Manifest_env$Ref_gwas_manifest
		
		# Save manifest
		f_saveManifest()
		f_getManifest(1)
}


# Adjust a trait / GWAS
f_modifyGWASinManifest = function(short=c("UniqueTraitName"),
	n=NA,
	filename=NA,
	year=NA,
	trait=NA,
	DOI=NA,
	genomeBuild = NA,
	traitType = NA,
	rawSNPs = NA,
	finalModelSNPs = NA,
	modelRunningTime = NA,
	usedRefSet = NA,
	processed=NA,
	FORCE = FALSE){
		# Get manifest
		f_getManifest()
		
		# check if trait exists
		if(sum(Manifest_env$Ref_gwas_manifest$short%in%short) == 0){
			message("Trait('",short,"') not found!")
			message("  Options:\n    - ",paste0(Manifest_env$Ref_gwas_manifest$short,collapse = "\n    - "))
			return(message("Modifying GWAS in Manifest failed."))
		}
		
		# process changes
		# make base of selected trait
		temp_man = Manifest_env$Ref_gwas_manifest[Manifest_env$Ref_gwas_manifest$short%in%short,]
		# check which are NOT NA
		for(temp_selected_column in c("n","filename","year","trait","DOI","genomeBuild","traitType","rawSNPs","finalModelSNPs","modelRunningTime","usedRefSet","processed")){
			# check which are NOT NA
			if(!is.na(get(temp_selected_column ))){
				message(paste0("Modifying ",temp_selected_column))
				temp_man[,(temp_selected_column )] = get(temp_selected_column)
			}
		
		}
		
		
		# input? FORCE
		if(!FORCE){
			cat(paste0("Are you sure you want to modify trait ('",short,"')?\n"))
			cat("This means you are modifying line:\n\n")
			cat(paste0(Manifest_env$Ref_gwas_manifest[Manifest_env$Ref_gwas_manifest$short%in%short,],"\n"))
			cat("This will be changed into:\n\n")
			cat(paste0(temp_man,"\n"))
			cat("\n>> Press [y] if information correct, then press [ENTER] <<")
			check = readline()
			if(check!="y"){
				return(message("Modifying GWAS in Manifest aborted."))
			}
		}
		
					
		# Inplement data
		Manifest_env$Ref_gwas_manifest[Manifest_env$Ref_gwas_manifest$short%in%short,] = temp_man
		Manifest_env$Ref_gwas_manifest <<- Manifest_env$Ref_gwas_manifest
		
		# Save manifest
		f_saveManifest()
		f_getManifest(1)
}

#-----------------------------------------------------------------------------------------------------#
#							Prepare GWAS 
#-----------------------------------------------------------------------------------------------------#

f_prepareGWAS = function(trait = "UniqueTraitName"){

	#@RRR MOVE TO SETTINGS PLEASE :)
	listofStandardizedGWASes = c("Birth_length","BMI","ASD")

	# Get manifest
	f_getManifest()
	
	# check if trait exists
	if(sum(Manifest_env$Ref_gwas_manifest$short%in%trait) == 0){
		message("Trait('",trait,"') not found!")
		message("  Options:\n    - ",paste0(Manifest_env$Ref_gwas_manifest$short,collapse = "\n    - "))
		return(message("Preparing GWAS into standardized format aborted."))
	}
	
	# check if trait is accepted
	if(!trait%in%listofStandardizedGWASes){
		message("Trait('",trait,"') not supported yet!")
		message("  Options:\n    - ",paste0(listofStandardizedGWASes,collapse = "\n    - "))
		return(message("Preparing GWAS into standardized format aborted."))
	}
	
	# Select the trait from manifest
	temp_manifest = Manifest_env$Ref_gwas_manifest[Manifest_env$Ref_gwas_manifest$short%in%trait,]
	
	#Read the GWAS data
	temp_gwas = data.table::fread(temp_manifest$filename,header = TRUE,sep = "\t",fill=TRUE) # waaay faster now!
	
	# Make sure no BP or CHR are missing (NA); remove!
	temp_gwas = temp_gwas[!(is.na(temp_gwas$CHR)|is.na(temp_gwas$BP)),]
	cat("GWAS loaded, found",dim(temp_gwas)[1],"(non-NA) SNPs")
	
	# Check if there are multi-alleles in the gwas, remove!
	temp_gwas = temp_gwas[nchar(temp_gwas$A1)==1 & nchar(temp_gwas$A2)==1,]
	cat(" of which",dim(temp_gwas)[1],"have non-multi-alleles!\n")
	

	# Check if temp_manifest$traitType is OK
	if(!(temp_manifest$traitType == "CAT" | temp_manifest$traitType == "CONT")){
		message("Trait-type must be set to 'CAT' or 'CONT'!")
		message("Currently this is set to ",temp_manifest$traitType)
		return(message("TraitType is incorrect, preparing GWAS into standardized format aborted."))
	}
	
	#################################
	#	CONT method
	#################################
	if(temp_manifest$traitType=="CONT"){
	
		# Check if GWAS contains all required columns
		requiredcols = c("CHR",  "BP",   "A1",   "A2", "N",   "BETA",   "P" )
		coltest = requiredcols%in%colnames(temp_gwas)
		if(sum(!coltest)>0){
			message("Missing required columns in GWAS data!")
			return(message("Column ",paste0(requiredcols[!coltest],collapse = " & ")," is missing in GWAS file."))
		}
	
		if(temp_manifest$short%in%listofStandardizedGWASes){
			cat("(Functions.R)    Using standardized CONT GWAS processing\n")
			temp_gwas = data.frame(Predictor=paste0(temp_gwas$CHR,":",temp_gwas$BP),
						A1=toupper(temp_gwas$A1),
						A2=toupper(temp_gwas$A2),
						n=temp_gwas$N,
						Direction=sign(temp_gwas$BETA),
						P=temp_gwas$P)
		}else{
			message("Trait('",trait,"') not supported yet!")
			message("  Options:\n    - ",paste0(listofStandardizedGWASes,collapse = "\n    - "))
			return(message("Preparing GWAS into standardized format aborted."))
		}
	}
	
	
	#################################
	#	CAT method
	#################################
	if(temp_manifest$traitType=="CAT"){
	
		# Check if GWAS contains all required columns
		requiredcols = c("CHR",  "BP",   "A1",   "A2", "N",   "OR",   "P" )
		coltest = requiredcols%in%colnames(temp_gwas)
		if(sum(!coltest)>0){
			message("Missing required columns in GWAS data!")
			return(message("Column ",paste0(requiredcols[!coltest],collapse = " & ")," is missing in GWAS file."))
		}
		
		if(temp_manifest$short%in%listofStandardizedGWASes){
			cat("(Functions.R)    Using standardized CAT GWAS processing\n")
			temp_gwas = data.frame(Predictor=paste0(temp_gwas$CHR,":",temp_gwas$BP),
						A1=toupper(temp_gwas$A1),
						A2=toupper(temp_gwas$A2),
						n=temp_gwas$N,
						Direction=sign((temp_gwas$OR-1)), #@RRR Check if this is correct; should be! OR is centered around 1.
						P=temp_gwas$P)
		}else{
			message("Trait('",trait,"') not supported yet!")
			message("  Options:\n    - ",paste0(listofStandardizedGWASes,collapse = "\n    - "))
			return(message("Preparing GWAS into standardized format aborted."))
		}
	}
	
	
	
	
	
	# Check for duplicated predictors and remove
	if(sum(duplicated(temp_gwas$Predictor)==TRUE)>0){
		cat("Found duplicated CHR:BPs, removing",as.numeric(table(duplicated(temp_gwas$Predictor))["TRUE"]), "SNPs\n")
		temp_gwas = temp_gwas[!duplicated(temp_gwas$Predictor),]
		cat(dim(temp_gwas)[1],"remaining\n")
	
	}
	
	# Collect the data and write a summaries format
	# assign to short name, then store
	assign(x=temp_manifest$short, temp_gwas)
	#save(list=c(temp_manifest$short),file = paste0(Settings_env$s_ROOT_dir,s_out_folder,"DATA/gwas/",temp_manifest$short,".Rdata")) # @RRR OPTIONAL. This is only for loading in R. This line should be commented out at some point
	data.table::fwrite(get(temp_manifest$short),file = paste0(Settings_env$s_ROOT_dir,s_out_folder,"DATA/gwas/",temp_manifest$short,".summaries"),row.names = FALSE,sep = "\t",quote = FALSE) # FASTERRRR
	
	# update settings
	Manifest_env$Ref_gwas_manifest[!Manifest_env$Ref_gwas_manifest$short%in%trait,"processed"] = 1
	Manifest_env$Ref_gwas_manifest[!Manifest_env$Ref_gwas_manifest$short%in%trait,"rawSNPs"] = dim(temp_gwas )[1]
	


	# Update manifest
	f_saveManifest()
	
	
}


#-----------------------------------------------------------------------------------------------------#
#							Calculate PGS model
#-----------------------------------------------------------------------------------------------------#

f_calcPGS_LDAK = function(Trait = NA,Model = "bayesr"){
	#-----------------------------------------------------------------------------------------------------#
	#							Startup
	#-----------------------------------------------------------------------------------------------------#
	time1 = as.numeric(Sys.time())
	possiblemodels = c("bayesr") # @RRR need to add support for others!
	
	f_getManifest(1)
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
	# load(paste0(Settings_env$s_ROOT_dir,s_out_folder,"Example/Pheno.Rdata"))


	gwas_loc = paste0(Settings_env$s_ROOT_dir,s_out_folder,"DATA/gwas/",temp_manifest$short,".summaries")
		
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
	Settings_env$s_data_loc_ref2 = f_wslpath(Settings_env$s_data_loc_ref)
	Settings_env$s_ref_loc_final2 = f_wslpath(Settings_env$s_ref_loc_final)



	# Parameters for specific PRS models -> in models
	model_dir = paste0(Settings_env$s_ROOT_dir,s_out_folder,"DATA/models/")
	specifi_model_dir = paste0(model_dir,temp_manifest$short)
	specifi_model_dir2 = f_wslpath(specifi_model_dir)

	temp_summfile = paste0(Settings_env$s_ROOT_dir,s_out_folder,"DATA/gwas/",temp_manifest$short,".summaries") 
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
	Settings_env$s_ref_loc_finalfile = "megabayesr"
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
	if(Model=="bayesr"){
		endcode = system(paste0("wsl cd ",specifi_model_dir2,"; ",Settings_env$s_ldak,paste0(" --mega-prs ",Settings_env$s_ref_loc_finalfile," --model ",Model," --ind-hers ",Settings_env$s_data_loc_ref2,"gbr.hapmap.ind.hers.positive --summary ",temp_summfile2," --cors ",Settings_env$s_data_loc_ref2,"gbr.hapmap --cv-proportion .1 --check-high-LD NO --window-kb 1000 --allow-ambiguous NO --extract ",temp_summfile_pred2," --max-threads 8")))
	}	# kb 1000
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
	temp_model = data.table::fread(paste0(specifi_model_dir,"/",Settings_env$s_ref_loc_finalfile,".effects"),header = TRUE,sep = " ") # waaay faster now!
		

	# update manifest 
	time2 = as.numeric(Sys.time())
	Manifest_env$Ref_gwas_manifest[Trait_index,"processed"] = 2
	Manifest_env$Ref_gwas_manifest[Trait_index,"finalModelSNPs"] = dim(temp_model)[1]
	Manifest_env$Ref_gwas_manifest[Trait_index,"modelRunningTime"] = round((time2-time1) / 60,0)
	#@RRR add total effect
	Manifest_env$Ref_gwas_manifest <<- Manifest_env$Ref_gwas_manifest # this needs to be pushed into .globalenv
	rm(temp_model)
	f_saveManifest()
	
	{cat("\n\n#-----------------------------#\n")
	cat("Completed\n")
	cat(paste0("PRS model stored in:\n"))
	cat(paste0(specifi_model_dir2,"/",Settings_env$s_ref_loc_finalfile,".effects","\n"))
	cat(paste0("Took approx ", Manifest_env$Ref_gwas_manifest[Trait_index,"modelRunningTime"] , " minutes.\n"))
	cat("#-----------------------------#\n")}

}

#-----------------------------------------------------------------------------------------------------#
#							PRS predict
#-----------------------------------------------------------------------------------------------------#

f_predPRS = function(bfile = NA, Trait = NA, OverlapSNPsOnly=FALSE, Force = FALSE){

	#-----------------------------------------------------------------------------------------------------#
	#							Startup
	#-----------------------------------------------------------------------------------------------------#
	# first get the manifest and check processed 	
	f_getManifest(1)
	
	Trait_index = which(Manifest_env$Ref_gwas_manifest$short==Trait)
	
	# check: if manifest Trait exists, else warning with options and return FAIL
	if(length(Trait_index)==0){
		#warning("\n\nEntered trait('",Trait,"') does not match any of the existing traits in manifest!","\n","  Options:\n    -",paste0(Manifest_env$Ref_gwas_manifest$short,collapse = "\n    -"),"\n\n")
		return(message(paste0("\n\nEntered trait('",Trait,"') does not match any of the existing traits in manifest!","\n","  Options:\n    -",paste0(Manifest_env$Ref_gwas_manifest$short,collapse = "\n    -"),"\n\n","predPRS failed!\n")))
	}
	
	# check: if bfile contains BP:CHR IDS
	testedNotation = system(paste0("wsl awk 'NR==1{print $2}' ",bfile,".bim"), intern = TRUE)
	if(length(strsplit(testedNotation,split = ":")[[1]])!=2){ # @RRR maybe this is not robust, time will tell
		return(paste0("\n\nEntered bfile ('",bfile,"') does not contain the correct ID format!\n","This should be CHR:BP (such as 1:2345678) and not (",testedNotation,")","\n\n"))
	}
	
	# show info
	{cat("#-----------------------------------#\n")
	cat(paste0("Trait: ",Trait,"\n" ))
	cat(paste0("Calculation of PRS scores of: ",Manifest_env$Ref_gwas_manifest[Trait_index,"short"]," \n"))
	cat(paste0("Data: ",gsub(bfile,pattern = "^.*./",replacement = ""), "\n"))
	cat("#-----------------------------------#\n\n\n")}
	temp_data_name = gsub(bfile,pattern = "^.*./",replacement = "")
	temp_manifest = Manifest_env$Ref_gwas_manifest[Trait_index,]
	Sys.sleep(1) # to hava a brief moment to see what you selected
	
	#-----------------------------------------------------------------------------------------------------#
	#							parameters
	#-----------------------------------------------------------------------------------------------------#
	# Parameters for specific PRS models -> in models
	model_dir = paste0(Settings_env$s_ROOT_dir,s_out_folder,"DATA/models/")
	specifi_model_dir = paste0(model_dir,temp_manifest$short)
	specifi_model_dir2 = f_wslpath(specifi_model_dir)



	#-----------------------------------------------------------------------------------------------------#
	#							Main algorithm
	#-----------------------------------------------------------------------------------------------------#
	temp_outfile = paste0(Settings_env$s_ROOT_dir,s_out_folder,"Predict/",temp_data_name,"_",temp_manifest$short)
	temp_outfile2 = f_wslpath(temp_outfile)

	#-----------------------------------------------------------------------------------------------------#
	#							Make TEMP effects file
	#-----------------------------------------------------------------------------------------------------#
	#OverlapSNPsOnly = FALSE
	# redoes the PGS based on available SNPs
	if(OverlapSNPsOnly){
		cat(paste0("\n\nOnly selecting SNPs that overlap in data AND model. Can lead to lower predictive power!\n"))
		# Get data snps 
		a = f_windowspath(paste0(bfile,".bim"))
		b = data.frame(data.table::fread(a,header = FALSE,sep = "\t")) # waaay faster now!
		All_data_snps = b[,"V2"]
		rm(b)
		#All_data_snps
		
		#paste0(specifi_model_dir,"/megabayesr.effects")
		
		profile = read.table(paste0(specifi_model_dir,"/megabayesr.effects"),header = TRUE,sep = " ")
		prp = table(!profile$Predictor%in%All_data_snps)
		missing_effect = sum(abs(profile[!profile$Predictor%in%All_data_snps,5])) 
		total_effect = sum(abs(profile[,5]))
		
		# chcek if SNPs lost are collectively important enough to stop the predicion
		cat(paste0("\n\nProp. SNPS found = ",as.numeric(round(prp["FALSE"]/sum(prp)*100,1)),"% (",as.numeric(prp["TRUE"])," SNPs missing)\n"))
		cat(paste0("Missing SNPs effect totals ",round(missing_effect,1)," out of ",round(total_effect,1),", this is ",round((missing_effect/total_effect)*100,1),"% of the total effect!\n\n"))
		if(round((missing_effect/total_effect)*100,1)>5){
			warning(paste0("\n\nData does not contain all essential SNPs to make a reliable PGS score!\nData missingness results in a ",round((missing_effect/total_effect)*100,1),"% loss of effect, which is greater than 5%!\n\n"))
			
			# if forcing, continue working, else pop error and stop
			if(!Force){
				return(message("predPRS failed due to missing essential SNPs!\n"))
			}else{
				warning(paste0("\n\nForcing PGS calculation with high missingness!\n\n"))
				
				# put warnings into logfile!
				# write logfile of warnings
				zz <- file(paste0(temp_outfile,"_warnings.log"), open="wt")
					sink(zz, type="output")
					
					# actual message
					cat(paste0("Data does not contain all essential SNPs to make a reliable PGS score!\nData missingness results in a ",round((missing_effect/total_effect)*100,1),"% loss of effect, which is greater than 5%!"))
					cat(paste0("\nForcing PGS calculation with high missingness!"))
					cat(paste0("\nProp. SNPS found = ",as.numeric(round(prp["FALSE"]/sum(prp)*100,1)),"% (",as.numeric(prp["TRUE"])," SNPs missing)"))
					cat(paste0("\nMissing SNPs effect totals ",round(missing_effect,1)," out of ",round(total_effect,1),", this is ",round((missing_effect/total_effect)*100,1),"% of the total effect!"))
				
					## reset message sink and close the file connection
					sink(type="output")
				close(zz)
				
				
				Sys.sleep(1)
			}
		}
		
		# SElect all SNPs from PGS model overlapping with data	 		
		profile = profile[profile$Predictor%in%All_data_snps,]
		write.table(profile,file=paste0(specifi_model_dir,"/megabayesr.effecttemp"),sep = " ",quote=FALSE,row.names = F)
		
		#get evaluation/ prs
		endcode = system(paste0("wsl cd ",specifi_model_dir2," ; ",Settings_env$s_ldak," --calc-scores ",temp_outfile2," --bfile ",bfile," --scorefile ",paste0(specifi_model_dir2,"/megabayesr.effecttemp")," --power 0"))#--pheno quant.pheno @RRR this needs to be included in the end. now im testing with samples that do not have the phenotype; PRS should be "0" centered--max-threads 8
		
		# remove temp
		file.remove(paste0(specifi_model_dir,"/megabayesr.effecttemp"))
		
	}else{
	
		#get evaluation / prs
		endcode = system(paste0("wsl cd ",specifi_model_dir2," ; ",Settings_env$s_ldak," --calc-scores ",temp_outfile2," --bfile ",bfile," --scorefile ",paste0(specifi_model_dir2,"/megabayesr.effects")," --power 0 "))#--pheno quant.pheno @RRR this needs to be included in the end. now im testing with samples that do not have the phenotype; PRS should be "0" centered-allow-multi NO
	}
 
	# check: if error
	if(endcode!=0){
		warning("\n\nPRS Calcualtion failed!\n\n")
		return(message("Final error code: ",endcode,"\n"))
		endcode = 0
	}
	
	


	
	{cat("\n\n#-----------------------------#\n")
	cat("Completed\n")
	cat(paste0("Found in:\n"))
	cat(paste0(temp_outfile2,"\n"))
	cat("#-----------------------------#\n")}
}

#-----------------------------------------------------------------------------------------------------#
#							Collect all predicted things
#-----------------------------------------------------------------------------------------------------#

f_collect_all_PRS = function (cohort = NA){
	# check if cohort exists; im assuming writign the correct name is not a problem, cause i dont check
	if(is.na(cohort)){
		return(warning("Cohort name is NA"))
	}
	
	# find root
	Predictroot = paste0(Settings_env$s_ROOT_dir,"Data_QC/",s_ROOT_current_folder_name,"/Predict/")

	# find all files in predict folder
	all_files = list.files(Predictroot)
	

	# Get all profiles
	select_files = grep(all_files ,pattern = paste0("(",cohort,")(?=.*profile$)"),perl = TRUE) # magic of regex; searches A: the cohort name and B: any file with A ending on ".profile"
	#@RRR fix grep name chort not FULLY CMPLETE MATCh

	# make into 1 object
	PGS = list()
	for(i in select_files){
		current_file = all_files[i]
		current_trait = gsub(current_file,pattern = paste0(cohort,".|.profile"),replacement = "")
		profile = read.table(paste0(Predictroot,current_file),header = TRUE,sep = "\t")
		PGS[current_trait]= data.frame(as.numeric(profile[,"Profile_1"])) # always  Profile_1, only running 1 at a time
	}

	
	# return this object
	PGS = data.frame(PGS)
	rownames(PGS) = profile$ID1
	return(PGS)
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

