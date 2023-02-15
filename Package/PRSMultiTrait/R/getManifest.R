#' getManifest
#' @return This function is used internally a lot, to make sure the manifest file is leading at all times. It loads the manifest object in its manifest env. It can be prompted to be shown if printManifest is set to TRUE.
#' @param printManifest Show (print) the manifest in the console.
#' @examples getManifest(1)
#' @export
getManifest = function(printManifest=FALSE){
	load(file = paste0(Settings_env$s_manifest_path,"/Ref_gwas_manifest.rda"),envir = Manifest_env) 
	if(printManifest){
		cat("GWAS manifest file (Ref_gwas_manifest):\n\n")
		print(Manifest_env$Ref_gwas_manifest)
		cat("\n\n")
	}
}
