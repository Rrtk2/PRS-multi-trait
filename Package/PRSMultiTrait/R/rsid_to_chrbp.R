#' rsid_to_chrbp
#' @return This function will change the rsIDs to chr:bp (@:#) format; adds "_chrbp" postfix
#' @param path The path to the b-file (bim).
#' @examples path = "C:/Users/p70072451/Downloads/ADNI/ADNI_QC_EUR05_2.bim"; rsid_to_chrbp(path)
#' @export
rsid_to_chrbp = function(path = NA){
	
	#-----------------------------------------------------------------------------------------------------#
	#							checks and note
	#-----------------------------------------------------------------------------------------------------#
	if(is.na(path)){
		return(message("Path is NA."))
	}
	
	# Stating start to work on: 
	message("(rsid_to_chrbp.R)    Changing IDs on '",path,"'!")
	
	# basically running --set-all-var-ids @:#
	system(paste(Settings_env$s_plinkloc, "--bfile",
	gsub(path,pattern = "\\.bim",replacement = ""), "--set-all-var-ids @:# --make-bed --out", 
	paste0(gsub(path,pattern = "\\.bim",replacement = ""),"_chrbp")))
	
	# report done
	message("(rsid_to_chrbp.R)    New bfiles generated with name: ", paste0(gsub(path,pattern = "\\.bim",replacement = ""),"_chrbp"))

}