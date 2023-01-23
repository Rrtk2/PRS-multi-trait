#' importManifest
#' @return
#' @examples
#' @export
#' importManifest(Path = "C:/Users/p70072451/Downloads/Manifest.tsv")
importManifest = function(Path = NA){
	if(is.na(Path)){
		stop("Path is NA, set path first!")
	}else{
		cat(paste0("\nReading manifest from:\n",paste0(Path) ,"\n\n"))
		Manifest_env$Ref_gwas_manifest = read.table(file = paste0(Path),sep = "\t",header = TRUE)
		
		saveManifest()
		
	}
}


