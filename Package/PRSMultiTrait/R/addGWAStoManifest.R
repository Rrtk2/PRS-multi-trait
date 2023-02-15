#' addGWAStoManifest
#' @return This function will add a GWAS with all its needed information to the Manifest file
#' @param short Enter a unique ID for the GWAS trait.
#' @param n Enter the sample size here, can be a rough estimate. This is not functionally used, only for annotation.
#' @param filename Enter the exact location of the curated GWAS.summaries file. This character string is the file argument in data.table::fread.
#' @param year Enter the year of GWAS.
#' @param trait Enter a brief description on the GWAS trait, to further specify if traits are similar.
#' @param DOI Enter the persistent online link to always be able to trace back the GWAS.
#' @param genomeBuild Enter the genomeBuild used in the GWAS, usually hg37.
#' @param traitType Enter the type of GWAS trait. This can ONLY be "CAT" or "CONT", categorical or continuous.
#' @param rawSNPs Automatically estimated, please leave as "?". This is the amount of SNPs in the data to be used to model.
#' @param finalModelSNPs Automatically estimated, please leave as "?". This is the amount of SNPs that are used in the final model.
#' @param modelRunningTime Automatically estimated, please leave as "?". THis is the amount of time taken to train the model.
#' @param usedRefSet Not used yet. Planned to be used when enabling diffent reference sets, no only UKBB.
#' @param processed Please set to 0. This is a variable indicaive of the processing steps taken in the workflow. 0 = new, 1 = QC, 2 is PGM.
#' @param FORCE Set to TRUE if wanting to skip the verification step.
#' @examples addGWAStoManifest(short=c("Height"),	n=c(10000), filename=c("C:/Path/To/GWAS_file"), year=c("2020"), trait=c("Height"), DOI=c("?"),	genomeBuild = c("hg19"), traitType = c("CON"), rawSNPs = c("?"), finalModelSNPs = c("?"), modelRunningTime = c("?"), usedRefSet = c("?"), processed=c(0))
#' The most important attributes are "short", "filename" and "traitType". "traitType" should be "CAT" or "CON".
#' @export

# Add a trait / GWAS
addGWAStoManifest = function(
	short=c("UniqueTraitName"),
	n=c(10000), # default 10,000? @RRR discuss
	filename=c("?"),
	year=c("?"),
	trait=c("?"),# @RRR this attribute name should be different -> TraitDesc
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
		#Manifest_env$Ref_gwas_manifest <<- Manifest_env$Ref_gwas_manifest

		# Save manifest
		saveManifest()
		getManifest(0)
}