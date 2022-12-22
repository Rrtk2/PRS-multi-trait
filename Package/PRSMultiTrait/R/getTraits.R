#' getManifest
#' @return This fucntion is for vizualization purposes, it shows all the 'shorts' and their descriptions.
#' @examples getTraits()
#' @export
getTraits = function(){
	# Get manifest
	getManifest() 
	cat("GWAS manifest (loaded from file)\n\n")
	cat("Trait:\t|\tDescription:\n")
	cat("-----------------------------------------\n")
	cat(apply(data.frame(short = Manifest_env$Ref_gwas_manifest$short,trait = Manifest_env$Ref_gwas_manifest$trait),1,function(x){paste0(x,collapse = "\t|\t")}),sep = "\n")
	cat("\n\n")
}