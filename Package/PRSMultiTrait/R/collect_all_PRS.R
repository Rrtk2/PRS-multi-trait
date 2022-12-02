#' collect_all_PRS
#' @return
#' @examples
#' @export
collect_all_PRS = function (cohort = NA){
	# check if cohort exists; im assuming writign the correct name is not a problem, cause i dont check
	if(is.na(cohort)){
		return(warning("Cohort name is NA"))
	}
	
	# find root
	Predictroot = paste0(Settings_env$s_ROOT_dir,Settings_env$s_ROOT_current_folder_name,"/Predict/")

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
	if(TRUE%in%duplicated(profile$ID1)){
		message(paste0("\nFound duplicates in names, making unique names. Please check!!\nFormat is [NAME].1, [NAME].2 ect\n\n"))
		rownames(PGS) = make.names(profile$ID1,unique = TRUE)
	}else{
		rownames(PGS) = profile$ID1
	}
	return(PGS)
}