#' collect_all_PRS
#' @return This function will return all the generated PGSs that were ran on a specific cohort, it will automatically load all and prompt a dataframe with PGS as columns and samples as rows.
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
	
	# find root
	Predictroot = paste0(Settings_env$s_ROOT_dir,Settings_env$s_ROOT_current_folder_name,"/Predict/")

	# find all files in predict folder
	all_files = list.files(Predictroot)
	

	# if no trait is specified do get all traits, else the specific one
	if(is.na(Trait)){
		select_files = grep(all_files ,pattern = paste0("(",cohort,")(?=.*",Model,"*)(?=.*profile$)"),perl = TRUE) # magic of regex; searches A: the cohort name and B: model and C:any file with A and B ending on ".profile"
	}else{
		select_files = grep(all_files ,pattern = paste0("(",cohort,")(?=.*",Trait,"*)(?=.*",Model,"*)(?=.*profile$)"),perl = TRUE)
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