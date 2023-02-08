#' prepareGWAS
#' @return
#' @examples
#' @export
prepareGWAS = function(trait = "UniqueTraitName"){

	#-----------------------------------------------------------------------------------------------------#
	#							Note
	#-----------------------------------------------------------------------------------------------------#

	# To do all instantly:
	#	for( i in which(Manifest_env$Ref_gwas_manifest$processed==0)){
	#		prepareGWAS(Manifest_env$Ref_gwas_manifest$short[i])
	#	}
	
	#@RRR MOVE TO SETTINGS PLEASE :) updated 23-1-2023
	#listofStandardizedGWASes = c('AD_jans' ,'Ad_no_APOE' ,'AD1' ,'AD2' ,'Adiponectin' ,'ASD' ,'BD' ,'BL' ,'BMI' ,'BW' ,'Bwfetal' ,'Bwmaternal' ,'ChildhoodObesity' ,'Chronotype' ,'EA' ,'ExtremeBMI' ,'ExtremeHeight' ,'ExtremeWHR' ,'family_AD' ,'HbA1c' ,'HC' ,'HDL' ,'Height' ,'Height22' ,'Heigth1' ,'InfantHeadCircumference' ,'LDL' ,'MDD' ,'ObesityClass1' ,'ObesityClass2' ,'ObesityClass3' ,'Overweight' ,'PubertalGrowth' ,'RA' ,'SHR' ,'SleepDuration' ,'T2D' ,'TC' ,'test_height' ,'TG' ,'WC' ,'WHR')

	# Get manifest
	getManifest()
	
	# check if trait exists
	if(sum(Manifest_env$Ref_gwas_manifest$short%in%trait) == 0){
		message("Trait('",trait,"') not found!")
		message("  Options:\n    - ",paste0(Manifest_env$Ref_gwas_manifest$short,collapse = "\n    - "))
		return(message("Preparing GWAS into standardized format aborted."))
	}
	
	# check if trait is accepted
	#if(!trait%in%listofStandardizedGWASes){
	#	message("Trait('",trait,"') not supported yet!")
	#	message("  Options:\n    - ",paste0(listofStandardizedGWASes,collapse = "\n    - "))
	#	return(message("Preparing GWAS into standardized format aborted."))
	#}
	

	# Select the trait from manifest
	temp_manifest = Manifest_env$Ref_gwas_manifest[Manifest_env$Ref_gwas_manifest$short%in%trait,]
	
	
	# Check if file exists
	if(!file.exists(temp_manifest$filename)){
		message("File does not seem to exist!")
		message(paste0("Is this correct?\n",temp_manifest$filename))
		return(message("Preparing GWAS into standardized format aborted."))
	}
	
	# Stating start to work on: 
	message("(prepareGWAS.R)    Processing '",trait,"'!")
	

	#Read the GWAS data
	temp_gwas = data.table::fread(temp_manifest$filename,header = TRUE,sep = "\t",fill=TRUE) # waaay faster now!
	temp_gwas_dim_pre_init = dim(temp_gwas)
	
	# Make sure no BP or CHR are missing (NA); remove!
	temp_gwas = temp_gwas[!(is.na(temp_gwas$CHR)|is.na(temp_gwas$BP)),]
	cat("GWAS loaded, found",dim(temp_gwas)[1],"(non-NA) SNPs\n")
	
	# Check if there are multi-alleles in the gwas, remove!
	temp_gwas = temp_gwas[nchar(temp_gwas$A1)==1 & nchar(temp_gwas$A2)==1,]
	cat(" of which",dim(temp_gwas)[1], "(",paste0(round(((dim(temp_gwas)[1]) / temp_gwas_dim_pre_init[1])*100,1),"% )"," have non-multi-alleles!\n"))
	

	# check if there are any that are misaligned to the referecne (UK biobank)
	load(paste0(Settings_env$s_ROOT_dir,"Reference/gbr_hapmap/All_SNPS_Hapmap.Rdata")) # waaay faster now!
	temp_gwas_dim_pre = dim(temp_gwas)
	temp_gwas = temp_gwas[paste0(temp_gwas$CHR,":",temp_gwas$BP)%in%All_SNPS_Hapmap,]
	temp_gwas_dim_post = dim(temp_gwas)
	cat("  of which",(temp_gwas_dim_post[1]), "(",paste0(round(((temp_gwas_dim_post[1]) / temp_gwas_dim_pre_init[1])*100,1),"% )"," SNPs remaining after Hapmap filter"),"\n")
	
	
	# Check if Alleles are correct (MAF should be Minor, not Major)
	temp_ref = data.table::fread(paste0(Settings_env$s_ROOT_dir,"Reference/gbr_hapmap/gbr.hapmap.cors.bim"),header = FALSE,sep = "\t",fill=TRUE) # waaay faster now!
	

	
	temp_gwas_dim_pre = dim(temp_gwas)
	# chekc set that A1 is A2 and A2 is A1 (flipped)
	temp_A12A21_index = as.logical(temp_ref[match(paste0(temp_gwas$CHR,":",temp_gwas$BP),temp_ref$V2),"V5"] == temp_gwas$A2) & as.logical(temp_ref[match(paste0(temp_gwas$CHR,":",temp_gwas$BP),temp_ref$V2),"V6"] == temp_gwas$A1)
	if(length(temp_A12A21_index)>0){
	

		if(c("BETA")%in%colnames(temp_gwas)){
			temp_a1 = temp_gwas$A1[temp_A12A21_index]
			temp_a2 = temp_gwas$A2[temp_A12A21_index]
			temp_gwas$A1[temp_A12A21_index] = temp_a2
			temp_gwas$A2[temp_A12A21_index] = temp_a1
			temp_gwas$BETA[temp_A12A21_index] = -temp_gwas$BETA[temp_A12A21_index]
			rm(list=c("temp_a1","temp_a2"))
		}
		
		if(c("OR")%in%colnames(temp_gwas)){
			temp_a1 = temp_gwas$A1[temp_A12A21_index]
			temp_a2 = temp_gwas$A2[temp_A12A21_index]
			temp_gwas$A1[temp_A12A21_index] = temp_a2
			temp_gwas$A2[temp_A12A21_index] = temp_a1
			temp_gwas$OR[temp_A12A21_index] = -temp_gwas$OR[temp_A12A21_index]
			rm(list=c("temp_a1","temp_a2"))
		}
	
	
	}
	
	cat("   of which",(as.numeric(table(temp_A12A21_index)["TRUE"])), "(",paste0(round(as.numeric(table(temp_A12A21_index)["TRUE"] / temp_gwas_dim_pre_init[1])*100,1),"% )"," SNPs were flipped"),"\n")
	
	# check set that A1 is A1 and A2 is A2 (correct)
	#temp_A11A22_index = as.logical(temp_ref[match(paste0(temp_gwas$CHR,":",temp_gwas$BP),temp_ref$V2),"V5"] == temp_gwas$A1) & as.logical(temp_ref[match(paste0(temp_gwas$CHR,":",temp_gwas$BP),temp_ref$V2),"V6"] == temp_gwas$A2)
	temp_gwas = temp_gwas[as.logical(temp_ref[match(paste0(temp_gwas$CHR,":",temp_gwas$BP),temp_ref$V2),"V5"] == temp_gwas$A1),]
	temp_gwas = temp_gwas[as.logical(temp_ref[match(paste0(temp_gwas$CHR,":",temp_gwas$BP),temp_ref$V2),"V6"] == temp_gwas$A2),]
	
	temp_gwas_dim_post = dim(temp_gwas)
	cat("    >> total ",(temp_gwas_dim_post[1]), "(",paste0(round(((temp_gwas_dim_post[1]) / temp_gwas_dim_pre_init[1])*100,1),"% )"," SNPs remaining after allele check << "),"\n")
	
	rm(list=  c("All_SNPS_Hapmap","temp_gwas_dim_pre","temp_gwas_dim_post"))
	

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
	
		#if(temp_manifest$short%in%listofStandardizedGWASes){
			cat("(prepareGWAS.R)    Using standardized CONT GWAS processing\n")
			temp_gwas = data.frame(Predictor=paste0(temp_gwas$CHR,":",temp_gwas$BP),
						A1=toupper(temp_gwas$A1),
						A2=toupper(temp_gwas$A2),
						n=temp_gwas$N,
						Direction=sign(temp_gwas$BETA),
						P=temp_gwas$P)
		#}else{
		#	message("Trait('",trait,"') not supported yet!")
		#	message("  Options:\n    - ",paste0(listofStandardizedGWASes,collapse = "\n    - "))
		#	return(message("Preparing GWAS into standardized format aborted."))
		#}
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
		
		#if(temp_manifest$short%in%listofStandardizedGWASes){
			cat("(prepareGWAS.R)    Using standardized CAT GWAS processing\n")
			temp_gwas = data.frame(Predictor=paste0(temp_gwas$CHR,":",temp_gwas$BP),
						A1=toupper(temp_gwas$A1),
						A2=toupper(temp_gwas$A2),
						n=temp_gwas$N,
						Direction=sign((temp_gwas$OR-1)), #@RRR Check if this is correct; should be! OR is centered around 1.
						P=temp_gwas$P)
		#}else{
		#	message("Trait('",trait,"') not supported yet!")
		#	message("  Options:\n    - ",paste0(listofStandardizedGWASes,collapse = "\n    - "))
		#	return(message("Preparing GWAS into standardized format aborted."))
		#}
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
	#save(list=c(temp_manifest$short),file = paste0(Settings_env$s_ROOT_dir,Settings_env$s_out_folder,"DATA/gwas/",temp_manifest$short,".Rdata")) # @RRR OPTIONAL. This is only for loading in R. This line should be commented out at some point
	data.table::fwrite(get(temp_manifest$short),file = paste0(Settings_env$s_ROOT_dir,Settings_env$s_out_folder,"DATA/gwas/",temp_manifest$short,".summaries"),row.names = FALSE,sep = "\t",quote = FALSE) # FASTERRRR
	
	# update settings
	Manifest_env$Ref_gwas_manifest[Manifest_env$Ref_gwas_manifest$short%in%trait,"processed"] = 1
	Manifest_env$Ref_gwas_manifest[Manifest_env$Ref_gwas_manifest$short%in%trait,"rawSNPs"] = dim(temp_gwas )[1]
	


	# Update manifest
	saveManifest()
	
	cat("Done processing '",trait,"'!\n\n")
}
