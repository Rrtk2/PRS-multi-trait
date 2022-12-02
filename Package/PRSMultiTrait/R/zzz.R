.onLoad <- function(libname, pkgname){
	#Settings_env <- new.env()
	assign("Settings_env", new.env(), parent.env(.GlobalEnv))
	
	#Settings_env <- new.env()
	assign("Manifest_env", new.env(), parent.env(.GlobalEnv))
	
}


.onAttach <- function(libname, pkgname) {

	# Welcome message
	packageStartupMessage(cat("This is the PRSMultiTrait load flag!\n"))
	

	#-----------------------------------------------------------------------------------------------------#
	#							Comment
	#-----------------------------------------------------------------------------------------------------#
	# Use '<<-' to assign to global envir. Do this here or seetings might be lost

	#-----------------------------------------------------------------------------------------------------#
	#							SEED
	#-----------------------------------------------------------------------------------------------------#
	# set seed for consistency
	Settings_env$s_seed = 42

	#-----------------------------------------------------------------------------------------------------#
	#							ROOT FOLDER
	#-----------------------------------------------------------------------------------------------------#
	# define ROOT here 
	if(!dir.exists(paste0(file.path(system.file(package="PRSMultiTrait")),"/Core"))){dir.create(file.path(paste0(file.path(system.file(package="PRSMultiTrait")),"/Core")))}
	
	Settings_env$s_ROOT_dir = file.path(system.file(package="PRSMultiTrait"), "Core//")

	Settings_env$s_manifest_path = file.path(system.file(package="PRSMultiTrait","/"))	
		
	Settings_env$s_ROOT_current_folder_name = "Internal_files"

	#Settings_env$s_figure_folder_name = "Plots"

	#-----------------------------------------------------------------------------------------------------#
	#							GET FUNCTIONS
	#-----------------------------------------------------------------------------------------------------#

	# source functions
	#source(paste0(Settings_env$s_ROOT_dir,"Scripts/Functions/Functions.R"))

	#-----------------------------------------------------------------------------------------------------#
	#							GET PROGRAM LOCATIONS
	#-----------------------------------------------------------------------------------------------------#
	# if installed using installer, these should be OK. Else adapt!!!
	Settings_env$s_plinkloc = paste0(Settings_env$s_ROOT_dir,"Programs/Plink2/plink2.exe")
	
	Settings_env$s_ldak = PRSMultiTrait::wslPath(paste0(Settings_env$s_ROOT_dir,"Programs/LDAK/ldak5.2.linux"))




	#-----------------------------------------------------------------------------------------------------#
	#							DEFINE OUTPUT FOLDER
	#-----------------------------------------------------------------------------------------------------#
	# change this to generate a different run, stored in new location
	Settings_env$s_out_folder = paste0(Settings_env$s_ROOT_current_folder_name,"/")


	# define out loc
	Settings_env$s_OUT_dir = paste0(Settings_env$s_ROOT_dir,Settings_env$s_out_folder)


	# define figure folder
	#Settings_env$s_figure_folder = paste0(Settings_env$s_ROOT_dir,Settings_env$s_out_folder,Settings_env$s_figure_folder_name,"/")


	#-----------------------------------------------------------------------------------------------------#
	#							MAKE OUTPUT FOLDERS IF NEEDED
	#-----------------------------------------------------------------------------------------------------#
	# main folders
	temp_all_dirs = c("Functions","Predict","DATA")
	if(!dir.exists(paste0(Settings_env$s_OUT_dir))){dir.create(file.path(paste0(Settings_env$s_OUT_dir)))}
	lapply(temp_all_dirs,function(i){if(!dir.exists(paste0(Settings_env$s_OUT_dir,i))){dir.create(file.path(paste0(Settings_env$s_OUT_dir,i)))}})

	# make output folders under ~/DATA
	temp_all_dirs2 = c("gwas","models")
	lapply(temp_all_dirs2,function(i){if(!dir.exists(paste0(Settings_env$s_OUT_dir,"DATA/",i))){dir.create(file.path(paste0(Settings_env$s_OUT_dir,"DATA/",i)))}})


	#-----------------------------------------------------------------------------------------------------#
	#							REF PANEL
	#-----------------------------------------------------------------------------------------------------#
	Settings_env$s_ref_out_name = "gbr.hapmap"#"1000G_phase3_final"

	Settings_env$s_data_loc_ref = paste0(Settings_env$s_ROOT_dir,"Reference/gbr_hapmap/") # 1000G code is: paste0(Settings_env$s_ROOT_dir,"Data_RAW/1000Genomes/")
	Settings_env$s_ref_loc_final = paste0(Settings_env$s_data_loc_ref,Settings_env$s_ref_out_name)


	#-----------------------------------------------------------------------------------------------------#
	#							INSTALLER (last as it needs locations based on items before)
	#-----------------------------------------------------------------------------------------------------#
	#source(paste0(Settings_env$s_ROOT_dir,"Scripts/.MAIN/Installer.R"))


	#-----------------------------------------------------------------------------------------------------#
	#							Make SETTINGS file (IF NOT EXISTS)
	#-----------------------------------------------------------------------------------------------------#

	if(!file.exists(paste0(Settings_env$s_OUT_dir,"SETTINGS.txt"))){
		temp_settings_names = ls(envir=Settings_env)[grep(ls(envir=Settings_env),pattern = "^s_")]

		temp_set = data.frame(variable = temp_settings_names, value = NA)

		for(i in 1:nrow(temp_set)){
			temp_set[i,"value"] =  get(temp_set[i,"variable"],envir=Settings_env )
		}

		write.table("SETTINGS:",file = paste0(Settings_env$s_OUT_dir,"SETTINGS.txt"),sep = "\t",quote = FALSE,row.names = FALSE,col.names = FALSE)
		write.table(temp_set,file = paste0(Settings_env$s_OUT_dir,"SETTINGS.txt"),sep = "\t",quote = FALSE,row.names = FALSE,col.names = TRUE,append = TRUE)
		write.table("\nVERSION:",file = paste0(Settings_env$s_OUT_dir,"SETTINGS.txt"),sep = "\t",quote = FALSE,row.names = FALSE,col.names = FALSE,append = TRUE)
		write.table(data.frame(name=names(version),value=unlist(version)),file = paste0(Settings_env$s_OUT_dir,"SETTINGS.txt"),sep = "\t",quote = FALSE,row.names = FALSE,col.names = FALSE,append = TRUE)
		write.table("\nSYSTEM INFO:",file = paste0(Settings_env$s_OUT_dir,"SETTINGS.txt"),sep = "\t",quote = FALSE,row.names = FALSE,col.names = FALSE,append = TRUE)
		write.table(data.frame(name=names(Sys.info()),value=unlist(Sys.info())),file = paste0(Settings_env$s_OUT_dir,"SETTINGS.txt"),sep = "\t",quote = FALSE,row.names = FALSE,col.names = FALSE,append = TRUE)
		write.table("\nBASE PACKAGES:",file = paste0(Settings_env$s_OUT_dir,"SETTINGS.txt"),sep = "\t",quote = FALSE,row.names = FALSE,col.names = FALSE,append = TRUE)
		write.table(sessionInfo()$basePkgs,file = paste0(Settings_env$s_OUT_dir,"SETTINGS.txt"),sep = "\t",quote = FALSE,row.names = FALSE,col.names = FALSE,append = TRUE)
		write.table("\nOTHER PACKAGES:",file = paste0(Settings_env$s_OUT_dir,"SETTINGS.txt"),sep = "\t",quote = FALSE,row.names = FALSE,col.names = FALSE,append = TRUE)
		write.table(names(sessionInfo()$otherPkgs),file = paste0(Settings_env$s_OUT_dir,"SETTINGS.txt"),sep = "\t",quote = FALSE,row.names = FALSE,col.names = FALSE,append = TRUE)

	}

}