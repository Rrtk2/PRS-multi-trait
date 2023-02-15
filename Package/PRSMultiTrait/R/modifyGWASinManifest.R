#' modifyGWASinManifest
#' @return This function will alter an existing GWAS trait in the manifest. This is based on using the 'short' as a method to select which GWAS is needed to be changed, and any other non-NA argument is changed into its alteration.
#' @param short A unique ID for the GWAS trait.
#' @param n The sample size here, can be a rough estimate. This is not functionally used, only for annotation.
#' @param filename The exact location of the curated GWAS.summaries file. This character string is the file argument in data.table::fread.
#' @param year The year of GWAS.
#' @param trait A brief description on the GWAS trait, to further specify if traits are similar.
#' @param DOI The persistent online link to always be able to trace back the GWAS.
#' @param genomeBuild The genomeBuild used in the GWAS, usually hg37.
#' @param traitType The type of GWAS trait. This can ONLY be "CAT" or "CONT", categorical or continuous.
#' @param rawSNPs This is the amount of SNPs in the data to be used to model.
#' @param finalModelSNPs This is the amount of SNPs that are used in the final model.
#' @param modelRunningTime THis is the amount of time taken to train the model.
#' @param usedRefSet Planned to be used when enabling diffent reference sets, no only UKBB.
#' @param processed This is a variable indicaive of the processing steps taken in the workflow. 0 = new, 1 = QC, 2 is PGM.
#' @param FORCE Set to TRUE if wanting to skip the verification step.
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
