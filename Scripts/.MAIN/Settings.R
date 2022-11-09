#-----------------------------------------------------------------------------------------------------#
#							Comment
#-----------------------------------------------------------------------------------------------------#
# Use '<<-' to assign to global envir. Do this here or seetings might be lost

#-----------------------------------------------------------------------------------------------------#
#							SEED
#-----------------------------------------------------------------------------------------------------#
# set seed for consistency
s_seed <<- 42

#-----------------------------------------------------------------------------------------------------#
#							ROOT FOLDER
#-----------------------------------------------------------------------------------------------------#
# define ROOT here 
s_ROOT_dir <<- "C:/DATA_STORAGE/Projects/PRS-multi-trait/"
s_ROOT_current_folder_name <<- "Test_branch"

s_figure_folder_name <<- "Plots"


#-----------------------------------------------------------------------------------------------------#
#							GET FUNCTIONS
#-----------------------------------------------------------------------------------------------------#

# source functions
source(paste0(s_ROOT_dir,"Scripts\\Functions\\Functions.R"))

#-----------------------------------------------------------------------------------------------------#
#							GET PROGRAM LOCATIONS
#-----------------------------------------------------------------------------------------------------#
# if installed using installer, these should be OK. Else adapt!!!
s_plinkloc = paste0(s_ROOT_dir,"Programs/Plink2/plink2.exe")
#s_gzip = paste0(s_ROOT_dir,"Programs/GnuWin32/bin/gzip.exe")
s_ldak = f_wslpath(paste0(s_ROOT_dir,"/Programs/LDAK/ldak5.2.linux"))




#-----------------------------------------------------------------------------------------------------#
#							DEFINE OUTPUT FOLDER
#-----------------------------------------------------------------------------------------------------#
# change this to generate a different run, stored in new location
s_out_folder <<- paste0("Data_QC/",s_ROOT_current_folder_name,"/")


# define out loc
s_OUT_dir <<- paste0(s_ROOT_dir,s_out_folder)


# define figure folder
s_figure_folder <<- paste0(s_ROOT_dir,s_out_folder,s_figure_folder_name,"/")



#-----------------------------------------------------------------------------------------------------#
#							MAKE OUTPUT FOLDERS IF NEEDED
#-----------------------------------------------------------------------------------------------------#
# main folders
temp_all_dirs = c(s_figure_folder_name,"Manifest","Functions","LDAK","Predict","SumStats","DATA")
if(!dir.exists(paste0(s_OUT_dir))){dir.create(file.path(paste0(s_OUT_dir)))}
lapply(temp_all_dirs,function(i){if(!dir.exists(paste0(s_OUT_dir,i))){dir.create(file.path(paste0(s_OUT_dir,i)))}})

# make output folders under ~/DATA
temp_all_dirs2 = c("manifest","gwas","models")
lapply(temp_all_dirs2,function(i){if(!dir.exists(paste0(s_OUT_dir,"DATA/",i))){dir.create(file.path(paste0(s_OUT_dir,"DATA/",i)))}})


#-----------------------------------------------------------------------------------------------------#
#							PRS
#-----------------------------------------------------------------------------------------------------#
s_ref_out_name = "gbr.hapmap"#"1000G_phase3_final"

s_data_loc_ref = paste0(s_ROOT_dir,"Data_RAW/gbr_hapmap/") # 1000G code is: paste0(s_ROOT_dir,"Data_RAW/1000Genomes/")
s_ref_loc_final = paste0(s_data_loc_ref,s_ref_out_name)





#-----------------------------------------------------------------------------------------------------#
#							Make SETTINGS file (IF NOT EXISTS)
#-----------------------------------------------------------------------------------------------------#

if(!file.exists(paste0(s_OUT_dir,"SETTINGS.txt"))){
	temp_settings_names = ls()[grep(ls(),pattern = "^s_")]

	temp_set = data.frame(variable = temp_settings_names, value = NA)

	for(i in 1:nrow(temp_set)){
		temp_set[i,"value"] =  get(temp_set[i,"variable"] )
	}

	write.table("SETTINGS:",file = paste0(s_OUT_dir,"SETTINGS.txt"),sep = "\t",quote = FALSE,row.names = FALSE,col.names = FALSE)
	write.table(temp_set,file = paste0(s_OUT_dir,"SETTINGS.txt"),sep = "\t",quote = FALSE,row.names = FALSE,col.names = TRUE,append = TRUE)
	write.table("\nVERSION:",file = paste0(s_OUT_dir,"SETTINGS.txt"),sep = "\t",quote = FALSE,row.names = FALSE,col.names = FALSE,append = TRUE)
	write.table(data.frame(name=names(version),value=unlist(version)),file = paste0(s_OUT_dir,"SETTINGS.txt"),sep = "\t",quote = FALSE,row.names = FALSE,col.names = FALSE,append = TRUE)
	write.table("\nSYSTEM INFO:",file = paste0(s_OUT_dir,"SETTINGS.txt"),sep = "\t",quote = FALSE,row.names = FALSE,col.names = FALSE,append = TRUE)
	write.table(data.frame(name=names(Sys.info()),value=unlist(Sys.info())),file = paste0(s_OUT_dir,"SETTINGS.txt"),sep = "\t",quote = FALSE,row.names = FALSE,col.names = FALSE,append = TRUE)
	write.table("\nBASE PACKAGES:",file = paste0(s_OUT_dir,"SETTINGS.txt"),sep = "\t",quote = FALSE,row.names = FALSE,col.names = FALSE,append = TRUE)
	write.table(sessionInfo()$basePkgs,file = paste0(s_OUT_dir,"SETTINGS.txt"),sep = "\t",quote = FALSE,row.names = FALSE,col.names = FALSE,append = TRUE)
	write.table("\nOTHER PACKAGES:",file = paste0(s_OUT_dir,"SETTINGS.txt"),sep = "\t",quote = FALSE,row.names = FALSE,col.names = FALSE,append = TRUE)
	write.table(names(sessionInfo()$otherPkgs),file = paste0(s_OUT_dir,"SETTINGS.txt"),sep = "\t",quote = FALSE,row.names = FALSE,col.names = FALSE,append = TRUE)

}