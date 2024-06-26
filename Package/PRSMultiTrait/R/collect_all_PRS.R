#' collect_all_PRS
#' @return This function will return all the generated PGSs that were ran on a specific cohort, it will automatically load all and prompt a dataframe with PGS as columns and samples as rows.
#' @param cohort Enter the file name (not the path) of the cohort the polygenic scores need collecing for.
#' @param Model Enter the model to collect the polygenic scores for specified trait.
#' @param Trait Enter the unique GWAS trait ID of interest to collect the polygenic scores using specified model.
#' @examples all_PGS = collect_all_PRS(cohort = "examplecohort")
#' @export
collect_all_PRS = function (cohort = NA, Model = "bayesr", Trait = NA){
	# check if cohort exists; im assuming writign the correct name is not a problem, cause i dont check
	if(is.na(cohort)){
		return(warning("Cohort name is NA"))
	}
	
	# check: if model is any of the available ones
	possiblemodels = c("lasso","lasso-sparse", "ridge", "bolt", "bayesr", "bayesr-shrink") # 
	if(!Model%in%possiblemodels){
		warning("\n\nEntered model('",Model,"') does not match any of the possible models supported!","\n","  Options:\n    - ",paste0(possiblemodels,collapse = "\n    - "),"\n\n")
		return(message("predPRS failed (Model)!\n"))	
	}
	
	# check if trait exists
	if(!is.na(Trait)){
		if(sum(Manifest_env$Ref_gwas_manifest$short%in%Trait) == 0){
			message("Trait('",Trait,"') not found!")
			message("  Options:\n    - ",paste0(Manifest_env$Ref_gwas_manifest$short,collapse = "\n    - "))
			return(message("Preparing GWAS into standardized format aborted."))
		}
	}
	
	# find root
	Predictroot = paste0(Settings_env$s_ROOT_dir,Settings_env$s_ROOT_current_folder_name,"/Predict/")

	# find all files in predict folder, only .profile
	all_files = list.files(Predictroot)
	all_files = all_files[grep(all_files,pattern = "\\.profile")]

	# if no trait is specified do get all traits, else the specific one
	if(is.na(Trait)){
		select_files = grep(all_files ,pattern = paste0(cohort,"_.*._", Model, ".profile"),perl = TRUE) # magic of regex; searches A: the cohort name and B: model and C:any file with A and B ending on ".profile"
	}else{
		select_files = grep(all_files ,pattern = paste0(cohort,"_",Trait,"_", Model, ".profile"),perl = TRUE)
	}
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
	if(TRUE%in%duplicated(profile$ID1)){
		message(paste0("\nFound duplicates in names, making unique names. Please check!!\nFormat is [NAME].1, [NAME].2 ect\n\n"))
		rownames(PGS) = make.names(profile$ID1,unique = TRUE)
	}else{
		rownames(PGS) = profile$ID1
	}
	return(PGS)
}