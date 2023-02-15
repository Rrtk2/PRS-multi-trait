#' removeGWASfromManifest
#' @return Removes a line (row) from the manifest, based on the given ID.
#' @param short The unique ID for the GWAS trait to be removed.
#' @examples removeGWASfromManifest(trait = "Height")
#' @export
# Remove a trait / GWAS
removeGWASfromManifest = function(
	trait=c("UniqueTraitName"),
	FORCE = FALSE){
		# Get manifest
		getManifest()
		
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
		#Manifest_env$Ref_gwas_manifest <<- Manifest_env$Ref_gwas_manifest
		
		# Save manifest
		saveManifest()
		getManifest(0)
}