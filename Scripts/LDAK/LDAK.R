#-----------------------------------------------------------------------------------------------------#
# 							GENERAL INFORMATION
#-----------------------------------------------------------------------------------------------------#
# File description:
#	Name
#		LDAK.R
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

ldak = paste0("/mnt/c/DATA_STORAGE/Projects/PRS/Programs/ldak5.2.linux_/ldak5.2.linux")
data_loc = paste0("/mnt/c/DATA_STORAGE/Projects/PRS/Data_RAW/Test_dataset/data/")


#-----------------------------------------------------------------------------------------------------#
#							Input
#-----------------------------------------------------------------------------------------------------#
# load(paste0(s_ROOT_dir,s_out_folder,"Example/Pheno.Rdata"))



#-----------------------------------------------------------------------------------------------------#
#							Main algorithm
#-----------------------------------------------------------------------------------------------------#


# this generates 'summary stats' from infividual level, as summ is needed later
system(paste0("wsl cd ",data_loc," ; pwd ;",ldak," --linear quant --bfile human --pheno quant.pheno"))
#We identify SNPs that are within high-LD regions by running
system(paste0("wsl cd ",data_loc," ; ",ldak," --cut-genes highld --bfile human --genefile highld.txt"))# -> in example case fails!

# Calculate predictor-predictor correlations.
system(paste0("wsl cd ",data_loc," ; ",ldak," --calc-cors cors --bfile human --window-cm 3"))

# >need ldak.thin.ind.hers<
# Estimate per-predictor heritabilities assuming the LDAK-Thin Model
system(paste0("wsl cd ",data_loc," ; ",ldak," --thin thin --bfile human --window-prune .98 --window-kb 100"))

# store weigth 1 per snp in new file
system(paste0("wsl cd ",data_loc," ; awk < thin.in '{print $1, 1}' > weights.thin"))



# calculate the tagging file
system(paste0("wsl cd ",data_loc," ; ",ldak," --calc-tagging ldak.thin --bfile human --weights weights.thin --power -.25 --window-cm 1 --save-matrix YES"))
system(paste0("wsl cd ",data_loc," ; ",ldak," --sum-hers ldak.thin --tagfile ldak.thin.tagging --summary quant.summaries --matrix ldak.thin.matrix"))


# construct prediction model
system(paste0("wsl cd ",data_loc,"; ",ldak," --mega-prs megabayesr --model bayesr --ind-hers ldak.thin.ind.hers --summary quant.summaries --cors cors --cv-proportion .1 --check-high-LD NO --window-cm 1 --allow-ambiguous YES"))


#get evaluation/ prs
system(paste0("wsl cd ",data_loc," ; ",ldak," --calc-scores megabayesr --bfile human --scorefile megabayesr.effects --power 0 --pheno quant.pheno"))
system(paste0("wsl cd ",data_loc," ; ",ldak," --jackknife megabayesr --profile megabayesr.profile --num-blocks 200"))



#-----------------------------------------------------------------------------------------------------#
#							plot?
#-----------------------------------------------------------------------------------------------------#
# need to see what next steps are @RRR

#  for now final predicting model effect sizes to be plotted?

SNP_effects = read.table(paste0("C:/DATA_STORAGE/Projects/PRS/Data_RAW/Test_dataset/data/","megabayesr.effects"),sep = " ",header = TRUE)
SNP_profile = read.table(paste0("C:/DATA_STORAGE/Projects/PRS/Data_RAW/Test_dataset/data/","megabayesr.profile"),sep = "\t",header = TRUE)
Samples_pheno = read.table(paste0("C:/DATA_STORAGE/Projects/PRS/Data_RAW/Test_dataset/data/","quant.pheno"),sep = " ",header = TRUE)

# prs scores:
SNP_profile$Profile_1

plot(y = SNP_profile$Profile_1, x = SNP_profile$Phenotype)

#-----------------------------------------------------------------------------------------------------#
#							output
#-----------------------------------------------------------------------------------------------------#
# save(Result,file = paste0(s_ROOT_dir,s_out_folder,"Example/Result.Rdata"))  # save in same folder, with name matching object

# save.image(paste0(s_ROOT_dir,s_out_folder,"DE/IMAGE_workspace.Rdata")) # save image

#-----------------------------------------------------------------------------------------------------#
#							Cleanup
#-----------------------------------------------------------------------------------------------------#
Rclean() # remove all temp_ prefix variables


#-----------------------------------------------------------------------------------------------------#
#							Par compute by chr
#-----------------------------------------------------------------------------------------------------#
#for j in {21..22}; do
#./ldak.out --calc-cors cors$j --bfile human --window-cm 3 --chr $j
#done
#
#rm list.txt; for j in {21..22}; do echo "cors$j" >> list.txt; done
#./ldak.out --join-cors cors --corslist list.txt