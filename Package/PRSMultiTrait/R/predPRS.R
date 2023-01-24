#' predPRS
#' @return This fucntion will run the calculation of the PGS of the given GWAS, it will automatically save these PGS which can be extracted with collect_all_PRS(). Make sure the bfiles are using a chr:bp ids and are using wsl-pathing notation in the fucntion.
#' @examples predPRS(bfile = wslpath("C:/path/to/examplecohort"), Trait = "Height")
#' @export
predPRS = function(bfile = NA, Trait = NA, OverlapSNPsOnly=FALSE, Force = FALSE){
	#-----------------------------------------------------------------------------------------------------#
	#							Note
	#-----------------------------------------------------------------------------------------------------#

	# To do all for cohort instantly:
	#	for( i in which(Manifest_env$Ref_gwas_manifest$processed==2)){
	#		predPRS(bfile = wslPath(paste0(Settings_env$s_ROOT_dir,"Reference/Example/1000G_phase3_final_2")), Trait = Manifest_env$Ref_gwas_manifest$short[i])
	#	}
	
	#-----------------------------------------------------------------------------------------------------#
	#							Startup
	#-----------------------------------------------------------------------------------------------------#
	# first get the manifest and check processed 	
	getManifest(1)
	
	Trait_index = which(Manifest_env$Ref_gwas_manifest$short==Trait)
	
	# check: if manifest Trait exists, else warning with options and return FAIL
	if(length(Trait_index)==0){
		#warning("\n\nEntered trait('",Trait,"') does not match any of the existing traits in manifest!","\n","  Options:\n    -",paste0(Manifest_env$Ref_gwas_manifest$short,collapse = "\n    -"),"\n\n")
		return(message(paste0("\n\nEntered trait('",Trait,"') does not match any of the existing traits in manifest!","\n","  Options:\n    -",paste0(Manifest_env$Ref_gwas_manifest$short,collapse = "\n    -"),"\n\n","predPRS failed!\n")))
	}
	
	# check: if bfile contains BP:CHR IDS
	testedNotation = system(paste0("wsl awk 'NR==1{print $2}' ",bfile,".bim"), intern = TRUE)
	if(length(strsplit(testedNotation,split = ":")[[1]])!=2){ # @RRR maybe this is not robust, time will tell
		return(message(paste0("\n\nEntered bfile ('",bfile,"') does not contain the correct ID format!\n","This should be CHR:BP (such as 1:2345678) and not (",testedNotation,")","\n\n")))
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
	model_dir = paste0(Settings_env$s_ROOT_dir,Settings_env$s_out_folder,"DATA/models/")
	specifi_model_dir = paste0(model_dir,temp_manifest$short)
	specifi_model_dir2 = wslPath(specifi_model_dir)



	#-----------------------------------------------------------------------------------------------------#
	#							Main algorithm
	#-----------------------------------------------------------------------------------------------------#
	temp_outfile = paste0(Settings_env$s_ROOT_dir,Settings_env$s_out_folder,"Predict/",temp_data_name,"_",temp_manifest$short)
	temp_outfile2 = wslPath(temp_outfile)

	#-----------------------------------------------------------------------------------------------------#
	#							Make TEMP effects file
	#-----------------------------------------------------------------------------------------------------#
	#OverlapSNPsOnly = FALSE
	# redoes the PGS based on available SNPs
	if(OverlapSNPsOnly){
		cat(paste0("\n\nOnly selecting SNPs that overlap in data AND model. Can lead to lower predictive power!\n"))
		# Get data snps 
		a = windowsPath(paste0(bfile,".bim"))
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