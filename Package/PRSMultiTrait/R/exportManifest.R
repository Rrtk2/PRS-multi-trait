#' exportManifest
#' @return
#' @examples
#' exportManifest(Path = "C:/Users/p70072451/Downloads/")
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


