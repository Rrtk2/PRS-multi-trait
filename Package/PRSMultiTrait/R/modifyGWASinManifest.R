#' modifyGWASinManifest
#' @return This function will alter an existing GWAS trait in the manifest. This is based on using the 'short' as a method to select which GWAS is needed to be changed, and any other non-NA argument is changed into its alteration.
#' @examples modifyGWASinManifest(short=c("Height"), n = 12345)
#' @export
modifyGWASinManifest = function(short=c("UniqueTraitName"),
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
		getManifest()
		
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
		#Manifest_env$Ref_gwas_manifest <<- Manifest_env$Ref_gwas_manifest
		
		# Save manifest
		saveManifest()
		getManifest(0)
}
