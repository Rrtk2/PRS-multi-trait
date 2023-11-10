#' checkDataIDs
#' @return This function will check the IDs of the b-files of the cohort of interest. These need to be chr:bp format. This function will automatically convert the IDs, and generate new b-files with a "_chrpb" postfix.
#' @param path The path to the b-file (bim).
#' @examples path = "C:/Users/p70072451/Downloads/ADNI/ADNI_QC_EUR05_2.bim"; checkDataIDs(path)
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
	#							Check IDs
	#-----------------------------------------------------------------------------------------------------#

	# load the bimfile 
	bim <- data.table::fread(file = path)

	# perform check; crude check on all ids contain ':', if missing, then auto reformat
	check_number_snps = 100
	check_out = as.logical(table((grepl(head(bim$V2,check_number_snps),pattern = ":") & 
	length(strsplit(head(bim$V2,check_number_snps),":")) == 1))["TRUE"] == check_number_snps) & !(FALSE%in%(lapply(strsplit(head(bim$V2,check_number_snps),":"),length)==2))

		
	if(check_out){
		cat("(checkDataIDs.R)    ID is ok!\n\n")
		
	}else{
		cat("(checkDataIDs.R)    ID is transformed to chr:bp!\n\n")
		
		CHR.BP = paste(bim$V1,bim$V4,sep = ":")
		SNPconv = data.frame(bim$V2,CHR.BP)
		
		data.table::fwrite(SNPconv, file = paste0(path_SNPnames,"SNPconverter.txt"), quote = FALSE, col.names = FALSE, row.names = FALSE,sep="\t")

		# set variables for plink
		path_data_wsl = (gsub(path,pattern = "\\.bim$",replacement = ""))
		path_SNPnames_wsl = (paste0(path_SNPnames,"SNPconverter.txt"))
		
		# change IDs
		system(paste(Settings_env$s_plinkloc,"--bfile",path_data_wsl,"--maf 0.05 --make-bed --out",paste0(path_data_wsl,"_chrbp"),"--update-name", path_SNPnames_wsl))
		
		# ID potential duplcated IDs
		#plink --file input_file --list-duplicate-vars
		system(paste(Settings_env$s_plinkloc,"--bfile",paste0(path_data_wsl,"_chrbp")," --rm-dup force-first --make-bed --out",paste0(path_data_wsl,"_chrbp_nodup")))
		

		message("(checkDataIDs.R)    New bfiles generated with name: ",paste0(gsub(path_data_wsl ,pattern = "^.*/",replacement = ""),"_chrbp_nodup"),"!")
	}



	#-----------------------------------------------------------------------------------------------------#
	#							Check misalighned SNPs
	#-----------------------------------------------------------------------------------------------------#
	# Check if the Data has any misalighned SNPs or such, check with HAPMAP, the database we use to set up the PGS models. If these align here, it should not throw errors later in the generation of PGS
	# In the past this has happend, that the data (cohort) had mismatched SNPs, throwing error.
	cat("(checkDataIDs.R)    Checking misaligned SNPs\n\n")
	
	# check if there are any that are misaligned to the referecne (UK biobank)
	load(paste0(Settings_env$s_ROOT_dir,"Reference/gbr_hapmap/All_SNPS_Hapmap.Rdata")) # waaay faster now!
	temp_gwas_dim_pre = length(CHR.BP )
	#temp_gwas = temp_gwas[CHR.BP%in%All_SNPS_Hapmap,]
	SNPselectList = CHR.BP%in%All_SNPS_Hapmap
	temp_gwas_dim_post = sum(SNPselectList)
	cat("(checkDataIDs.R)    ",(temp_gwas_dim_post[1]), "(",paste0(round(((temp_gwas_dim_post[1]) / temp_gwas_dim_pre[1])*100,1),"% )"," SNPs remaining after Hapmap filter"),"\n")
	
	# write the SNPs to be selected
	data.table::fwrite(data.frame(CHR.BP[SNPselectList]), file = paste0(path_SNPnames,"SNPselect.txt"), quote = FALSE, col.names = FALSE, row.names = FALSE,sep="\t")

	# ID potential duplcated IDs
	#plink --file input_file --list-duplicate-vars
	system(paste(Settings_env$s_plinkloc,"--bfile",paste0(path_data_wsl,"_chrbp_nodup")," --extract ",paste0(path_SNPnames,"SNPselect.txt")," --make-bed --out",paste0(path_data_wsl,"_chrbp_nodup_hapmapfilter")))
	
	# Check if Alleles are correct (MAF should be Minor, not Major)
	# get the reference HAPMAP
	temp_ref = data.table::fread(paste0(Settings_env$s_ROOT_dir,"Reference/gbr_hapmap/gbr.hapmap.cors.bim"),header = FALSE,sep = "\t",fill=TRUE) # waaay faster now!
	
	# get the newly made fixed data 
	temp_data = data.table::fread(paste0(path_data_wsl,"_chrbp_nodup_hapmapfilter.bim"),header = FALSE,sep = "\t",fill=TRUE) # waaay faster now!
	
		
	# Joining on relevant columns (V2 in this case)
	merged_data = merge(temp_data, temp_ref, by = "V2", suffixes = c("_temp_data", "_temp_ref"))

	# Checking if V5 and V6 align for all SNPs; and also case where all is flipped
	temp_align = merged_data$V5_temp_data == merged_data$V5_temp_ref & merged_data$V6_temp_data == merged_data$V6_temp_ref | merged_data$V5_temp_data == merged_data$V6_temp_ref & merged_data$V6_temp_data == merged_data$V5_temp_ref

	cat("   of which",sum(!temp_align),"SNPs were misaligned (removed)","\n")
		

	# write the SNPs to be selected
	data.table::fwrite(data.frame(merged_data$V2[temp_align]), file = paste0(path_SNPnames,"SNPselect.txt"), quote = FALSE, col.names = FALSE, row.names = FALSE,sep="\t")

	# ID potential duplcated IDs
	#plink --file input_file --list-duplicate-vars
	system(paste(Settings_env$s_plinkloc,"--bfile",paste0(path_data_wsl,"_chrbp_nodup_hapmapfilter")," --extract ",paste0(path_SNPnames,"SNPselect.txt")," --make-bed --out",paste0(path_data_wsl,"_chrbp_nodup_hapmapfilter_done")))
	

	#cat("   of which",(as.numeric(table(temp_A12A21_index)["TRUE"])), "(",paste0(round(as.numeric(table(temp_A12A21_index)["TRUE"] / temp_gwas_dim_pre_init[1])*100,1),"% )"," SNPs were flipped"),"\n")
	cat("(checkDataIDs.R)    ",(length(merged_data$V2[temp_align])), "(",paste0(round(((length(merged_data$V2[temp_align])) / temp_gwas_dim_pre[1])*100,1),"% )"," SNPs remaining after Hapmap filter"),"\n")
	message("(checkDataIDs.R)    New bfiles generated with name: ",paste0(gsub(path_data_wsl ,pattern = "^.*/",replacement = ""),"_chrbp_nodup_hapmapfilter_done"),"!")

}