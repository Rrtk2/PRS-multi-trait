#' importManifest
#' @return This function will import the manifest used in this package from the specified file. The manifest is the heart of the package, this must never get corrupted.
#' @param Path The specific file path to get the manifest from. Must be a tab-delimited file. See formatting example at exportManifest().
#' @examples
#' importManifest(Path = "C:/Users/Default/Downloads/Manifest.tsv")
#' @export
importManifest = function(Path = NA){
	if(is.na(Path)){
		stop("Path is NA, set path first!")
	}else{
		cat(paste0("\nReading manifest from:\n",paste0(Path) ,"\n\n"))
		Manifest_env$Ref_gwas_manifest = read.table(file = paste0(Path),sep = "\t",header = TRUE)
		
		saveManifest()
		
	}
}


