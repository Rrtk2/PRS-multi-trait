#' prepareGWAS
#' @return
#' @examples
#' @export
prepareGWAS = function(trait = "UniqueTraitName"){

	#@RRR MOVE TO SETTINGS PLEASE :)
	listofStandardizedGWASes = c("Birth_length","BMI","ASD")

	# Get manifest
	getManifest()
	
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
	#save(list=c(temp_manifest$short),file = paste0(Settings_env$s_ROOT_dir,Settings_env$s_out_folder,"DATA/gwas/",temp_manifest$short,".Rdata")) # @RRR OPTIONAL. This is only for loading in R. This line should be commented out at some point
	data.table::fwrite(get(temp_manifest$short),file = paste0(Settings_env$s_ROOT_dir,Settings_env$s_out_folder,"DATA/gwas/",temp_manifest$short,".summaries"),row.names = FALSE,sep = "\t",quote = FALSE) # FASTERRRR
	
	# update settings
	Manifest_env$Ref_gwas_manifest[!Manifest_env$Ref_gwas_manifest$short%in%trait,"processed"] = 1
	Manifest_env$Ref_gwas_manifest[!Manifest_env$Ref_gwas_manifest$short%in%trait,"rawSNPs"] = dim(temp_gwas )[1]
	


	# Update manifest
	saveManifest()
	
	
}
