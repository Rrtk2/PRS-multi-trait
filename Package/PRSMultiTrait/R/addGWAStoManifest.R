#' addGWAStoManifest
#' @return
#' @examples
#' @export

# Add a trait / GWAS
addGWAStoManifest = function(
	short=c("UniqueTraitName"),
	n=c(10000), # default 10,000? @RRR discuss
	filename=c("?"),
	year=c("?"),
	trait=c("?"),
	DOI=c("?"),
	genomeBuild = c("?"),
	traitType = c("?"),
	rawSNPs = c("?"),
	finalModelSNPs = c("?"),
	modelRunningTime = c("?"),
	usedRefSet = c("?"),
	processed=c(0),
	FORCE = FALSE){
		# Get manifest
		getManifest()
		
		# Collect data in df style
		temp_man = data.frame(short = short,
			n=n,
			filename=filename,
			year=year,
			trait=trait,
			DOI=DOI,
			genomeBuild = genomeBuild,
			traitType = traitType,
			rawSNPs = rawSNPs,
			finalModelSNPs = finalModelSNPs,
			modelRunningTime = modelRunningTime,
			usedRefSet = usedRefSet,
			processed=processed)
			
		# First check the items to be added
		apply(temp_man,2,function(x){cat(paste0(x,"\n"))})
		
			
		# input? FORCE
		if(!FORCE){
			cat("\n>> Press [y] if information correct, then press [ENTER] <<")
			check = readline()
			if(check!="y"){
				return(message("Adding GWAS to Manifest aborted."))
			}
		}
		
		if(temp_man$short%in%Manifest_env$Ref_gwas_manifest$short){
			message("Adding GWAS to Manifest failed!")
			return(message("'short' name is taken! Please check the input or make another unique name."))
		}
			
		# Inplement data
		Manifest_env$Ref_gwas_manifest[dim(Manifest_env$Ref_gwas_manifest)[1]+1,] = temp_man
		Manifest_env$Ref_gwas_manifest <<- Manifest_env$Ref_gwas_manifest
		
		# Save manifest
		saveManifest()
		getManifest(1)
}