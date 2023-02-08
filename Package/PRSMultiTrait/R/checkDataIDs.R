#' checkDataIDs
#' @return
#' @examples
#' @export
checkDataIDs = function(path = NA){
	
	#-----------------------------------------------------------------------------------------------------#
	#							checks and note
	#-----------------------------------------------------------------------------------------------------#
	#example: path = "C:/Users/p70072451/Downloads/ADNI/ADNI_QC_EUR05_2.bim"
	path_SNPnames = paste0(gsub(path,pattern = "/[^/]+$",replacement = ""),"/")
	
	if(is.na(path)){
		return(message("Checking GWAS IDs failed, Path is NA."))
	}
	
	# Stating start to work on: 
	message("(checkDataIDs.R)    Checking IDs on '",path,"'!")
	
	#-----------------------------------------------------------------------------------------------------#
	#							MAIN
	#-----------------------------------------------------------------------------------------------------#

	# load the bimfile 
	bim <- data.table::fread(file = path)

	# perform check; crude check on all ids contain ':', if missing, then auto reformat
	check_out = as.logical(table(grepl(bim$V2,pattern = ":"))["TRUE"] ==length(bim$V2))

	
	if(check_out){
		cat("ID is ok!\n\n")
		
	}else{
		cat("ID is transformed to chr:bp!\n\n")
		
		CHR.BP = paste(bim$V1,bim$V4,sep = ":")
		SNPconv = data.frame(bim$V2,CHR.BP)
		
		data.table::fwrite(SNPconv, file = paste0(path_SNPnames,"SNPconverter.txt"), quote = FALSE, col.names = FALSE, row.names = FALSE,sep="\t")

		# set variables for plink
		path_data_wsl = (gsub(path,pattern = "\\.bim$",replacement = ""))
		path_SNPnames_wsl = (paste0(path_SNPnames,"SNPconverter.txt"))
		
		system(paste(Settings_env$s_plinkloc,"--bfile",path_data_wsl,"--maf 0.05 --make-bed --out",paste0(path_data_wsl,"_chrbp"),"--update-name", path_SNPnames_wsl))
		
		message("(checkDataIDs.R)    New bfiles generated with name: ",paste0(gsub(path_data_wsl ,pattern = "^.*/",replacement = ""),"_chrbp"),"!")
	}

}