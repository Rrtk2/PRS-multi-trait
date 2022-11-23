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
#							Calculate PGS model
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
	endcode = system(paste0("wsl cd ",specifi_model_dir2," ; ",s_ldak," --sum-hers ",s_data_loc_ref2,"gbr.hapmap --tagfile ",s_data_loc_ref2,"gbr.hapmap.bld.ldak.quickprs.tagging --summary ",temp_summfile2," --matrix ",s_data_loc_ref2,"gbr.hapmap.bld.ldak.quickprs.matrix"," --check-sums NO --cutoff 0.01")) 
	# @RRR check cutoff, the APOE snps actually meet this!!!

		# check: if failed sum heritabilities
		if(endcode!=0){
			warning("\n\nSummation heritabilities calcualtion failed!\n\n")
			return(message("Final error code: ",endcode,"\n"))
			endcode = 0
		}

	# construct prediction model
	if(Model=="bayesr"){
		endcode = system(paste0("wsl cd ",specifi_model_dir2,"; ",s_ldak,paste0(" --mega-prs ",s_ref_loc_finalfile," --model ",Model," --ind-hers ",s_data_loc_ref2,"gbr.hapmap.ind.hers.positive --summary ",temp_summfile2," --cors ",s_data_loc_ref2,"gbr.hapmap --cv-proportion .1 --check-high-LD NO --window-kb 1000 --allow-ambiguous NO --extract ",temp_summfile_pred2," --max-threads 8")))
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
	#@RRR add total effect
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
#							PRS predict
#-----------------------------------------------------------------------------------------------------#

f_predPRS = function(bfile = NA, Trait = NA, OverlapSNPsOnly=FALSE, Force = FALSE){

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
	specifi_model_dir2 = f_wslpath(specifi_model_dir)



	#-----------------------------------------------------------------------------------------------------#
	#							Main algorithm
	#-----------------------------------------------------------------------------------------------------#
	temp_outfile = paste0(s_ROOT_dir,s_out_folder,"Predict/",temp_data_name,"_",temp_manifest$short)
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
		endcode = system(paste0("wsl cd ",specifi_model_dir2," ; ",s_ldak," --calc-scores ",temp_outfile2," --bfile ",bfile," --scorefile ",paste0(specifi_model_dir2,"/megabayesr.effecttemp")," --power 0"))#--pheno quant.pheno @RRR this needs to be included in the end. now im testing with samples that do not have the phenotype; PRS should be "0" centered--max-threads 8
		
		# remove temp
		file.remove(paste0(specifi_model_dir,"/megabayesr.effecttemp"))
		
	}else{
	
		#get evaluation / prs
		endcode = system(paste0("wsl cd ",specifi_model_dir2," ; ",s_ldak," --calc-scores ",temp_outfile2," --bfile ",bfile," --scorefile ",paste0(specifi_model_dir2,"/megabayesr.effects")," --power 0 "))#--pheno quant.pheno @RRR this needs to be included in the end. now im testing with samples that do not have the phenotype; PRS should be "0" centered-allow-multi NO
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
	Predictroot = paste0(s_ROOT_dir,"Data_QC/",s_ROOT_current_folder_name,"/Predict/")

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
	PGS["samples"] = data.frame(profile$ID1)
	PGS = data.frame(PGS)
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

