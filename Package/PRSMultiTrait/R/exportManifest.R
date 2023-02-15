#' exportManifest
#' @return This function will export the manifest used in this package to the specified folder. The manifest is the heart of the package, this must never get corrupted.
#' @param Path The folder path to save the manifest in. Automatically generates a tab-delimited file called 'Manifest.tsv' in specified folder.
#' @examples
#' exportManifest(Path = "C:/Users/Default/Downloads/")
#' @export
exportManifest = function(Path = NA){
	if(is.na(Path)){
		stop("Path is NA, set path first!")
	}else{
		cat(paste0("\nWriting manifest to:\n",paste0(Path,"Manifest.tsv") ,"\n\n"))
		getManifest()
		write.table(Manifest_env$Ref_gwas_manifest,file = paste0(Path,"Manifest.tsv"),sep = "\t",row.names=FALSE,quote=FALSE)
		
	}
}


