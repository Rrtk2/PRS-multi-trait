#-----------------------------------------------------------------------------------------------------#
# 							GENERAL INFORMATION
#-----------------------------------------------------------------------------------------------------#
# File description:
#	Name
#		Cal_Ref_1000G.R
#
#	Purpose 
#		This code was made as sub-master level regulation script.
#
# Author comment:
#	Rick A. Reijnders 
#	ra.reijnders@maastrichtuniversity.nl
#
#	Personal comment:
#		download via http://dougspeed.com/downloads2/
#			- download file
#			- run /_ldak-folder_/ldak5.2.linux
#			
#
#-----------------------------------------------------------------------------------------------------#
#							Main settings or load
#-----------------------------------------------------------------------------------------------------#
source("C:/DATA_STORAGE/Projects/PRS-multi-trait/Scripts/.Main/Settings.R")



#-----------------------------------------------------------------------------------------------------#
#							refset
#-----------------------------------------------------------------------------------------------------#


# @RRR https://dougspeed.com/reference-panel/
# Reference panel is needed
# 1000Genomes FTP site: http://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/
# bigsnpR has dedicated funtion to DL the 1000G phase 3 in PLINK bed/bim/fam format -> bigsnpr::download_1000G()
bigsnpr::download_1000G(s_data_loc_ref)
# unpack GZ files using gzip 

# make loc
temp_bfile1 = paste0(s_data_loc_ref,"1000G_phase3_common_norel") # fixed name due to DL!

# There are 1) wrong ids -> to chr:bp. 2) duplicated rsids -> rm-dup
system(paste0(s_plinkloc," --bfile ", temp_bfile1, " --set-all-var-ids @:# --make-bed --out ",paste0(temp_bfile1,"_out1")))
system(paste0(s_plinkloc," --bfile ", paste0(temp_bfile1,"_out1"), " --rm-dup --make-bed --out ",paste0(temp_bfile1,"_out")))
system(paste0(s_plinkloc," --bfile ", paste0(temp_bfile1,"_out1"), " --exclude ",paste0(temp_bfile1,"_out.rmdup.mismatch")," --make-bed --out ",s_ref_loc_final))

# remove inital files
temp_files = list.files(s_data_loc_ref)
temp_files = temp_files[grep(temp_files,pattern="1000G_phase3_common_norel")]
file.remove(paste0(s_data_loc_ref,temp_files))

# make loc
temp_bfile1 = s_ref_loc_final
temp_bfile2 = paste0(gsub(temp_bfile1,pattern = "C:/",replacement = "/mnt/c/"))


# this command needs the refernec set -> human is reference set
# Calculate predictor-predictor correlations. USING approx solution@RRR (by --window-kb 3000); ideal is  --window-cm 3
# Takes long (20 min)
system(paste0("wsl cd ",paste0(gsub(s_data_loc_ref,pattern = "C:/",replacement = "/mnt/c/"))," ; ",s_ldak," --calc-cors cors --bfile ", temp_bfile2 ," --window-kb 3000")) # --window-cm 3

#awk 'NR==1{print $1; exit}' "/mnt/c/DATA_STORAGE/Projects/PRS-multi-trait/Data_RAW/1000Genomes/cors.cors.bin"

# >need ldak.thin.ind.hers<
# Estimate per-predictor heritabilities assuming the LDAK-Thin Model
# this drops several snps, which is OK, but you need like at least 1M left (from 1,700,000) in this case 1,412,188 predictors left
system(paste0("wsl cd ",paste0(gsub(s_data_loc_ref,pattern = "C:/",replacement = "/mnt/c/"))," ; ",s_ldak," --thin thin --bfile ",temp_bfile2," --window-prune .98 --window-kb 100"))

# store weigth 1 per snp in new file
system(paste0("wsl cd ",paste0(gsub(s_data_loc_ref,pattern = "C:/",replacement = "/mnt/c/"))," ; awk < thin.in '{print $1, 1}' > weights.thin"))


# calculate the tagging file
system(paste0("wsl cd ",paste0(gsub(s_data_loc_ref,pattern = "C:/",replacement = "/mnt/c/"))," ; ",s_ldak," --calc-tagging ",paste0(gsub(s_data_loc_ref,pattern = "C:/",replacement = "/mnt/c/")),"ldak.thin --bfile ",
paste0(gsub(s_ref_loc_final,pattern = "C:/",replacement = "/mnt/c/"))," --weights ",paste0(gsub(s_data_loc_ref,pattern = "C:/",replacement = "/mnt/c/")),"weights.thin --power -.25 --window-kb 1000 --save-matrix YES"))


#-----------------------------------------------------------------------------------------------------#
#							make flag (done running, to check if refset bed exists with all needed ect)
#-----------------------------------------------------------------------------------------------------#
# flag can be used to store version info, can be used later
write(x = TRUE,file = paste0(s_data_loc_ref,".flag"))