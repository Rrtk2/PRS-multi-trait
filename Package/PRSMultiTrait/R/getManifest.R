#' getManifest
#' @return
#' @examples
#' @export
getManifest = function(printManifest=FALSE){
	load(file = paste0(Settings_env$s_manifest_path,"data/Ref_gwas_manifest.rda"),envir = Manifest_env) 
	if(printManifest){
		cat("GWAS manifest file (Ref_gwas_manifest):\n\n")
		print(Manifest_env$Ref_gwas_manifest)
		cat("\n\n")
	}
}
