#' installDependenciesAndData
#' @return This function is essential in the workings for the PRSMultiTrait package, as it installs, checks, and sets everything up. 
#' @examples installDependenciesAndData()
#' @export
installDependenciesAndData = function(){
	#-----------------------------------------------------------------------------------------------------#
	#							make folders if needed
	#-----------------------------------------------------------------------------------------------------##
	# Programs
	if(!dir.exists(paste0(paste0(Settings_env$s_ROOT_dir,"Programs/")))){dir.create(file.path(paste0(paste0(Settings_env$s_ROOT_dir,"Programs/"))))}
	lapply(c("LDAK","Plink2"),function(i){if(!dir.exists(paste0(paste0(Settings_env$s_ROOT_dir,"Programs/"),i))){dir.create(file.path(paste0(paste0(Settings_env$s_ROOT_dir,"Programs/"),i)))}})

	
	#-----------------------------------------------------------------------------------------------------#
	#							Check WSL
	#-----------------------------------------------------------------------------------------------------#
	if(!system("wsl uname",intern = TRUE)=="Linux"){
		cat(">> Windows Subsystem for Linux (WSL) is NOT installed! <<\n")
		cat("Please install this first. See documentation! \n" )
		stop("WSL not installed, initializing workflow has been aborted.")
	}


	#-----------------------------------------------------------------------------------------------------#
	#							LDAK
	#-----------------------------------------------------------------------------------------------------#
	# check if LDAK is installed 
	if(!file.exists(windowsPath(Settings_env$s_ldak))){

		# print message for installer
		cat(">> LDAK not detected on expected location! <<\n")
		cat("   - Installing LDAK from dougspeed.com\n\n")

		# Download file into temp file
		download.file("https://dougspeed.com/wp-content/uploads/ldak5.2.linux_.zip",paste0(Settings_env$s_ROOT_dir,"Programs/","LDAK/temp"))

		# Unzip
		unzip(paste0(Settings_env$s_ROOT_dir,"Programs/","LDAK/temp"),exdir=paste0(Settings_env$s_ROOT_dir,"Programs/","LDAK"))  # unzip your file 

		# Remove temp file
		file.remove(paste0(Settings_env$s_ROOT_dir,"Programs/","LDAK/temp"))

	}
	#-----------------------------------------------------------------------------------------------------#
	#							Plink2
	#-----------------------------------------------------------------------------------------------------#
	if(!file.exists(Settings_env$s_plinkloc)){

		# print message for installer
		cat(">> Plink2 not detected on expected location! <<\n")
		cat("   - Installing Plink2 from cog-genomics.org\n\n")

		# Download file into temp file
		download.file("https://s3.amazonaws.com/plink2-assets/alpha3/plink2_win64_20221024.zip",paste0(Settings_env$s_ROOT_dir,"Programs/","Plink2/temp"))

		# Unzip
		unzip(paste0(Settings_env$s_ROOT_dir,"Programs/","Plink2/temp"),exdir=paste0(Settings_env$s_ROOT_dir,"Programs/","Plink2"))  # unzip your file 

		# Remove temp file
		file.remove(paste0(Settings_env$s_ROOT_dir,"Programs/","Plink2/temp"))

	}
	##-----------------------------------------------------------------------------------------------------#
	##							GnuWin32
	##-----------------------------------------------------------------------------------------------------#
	## Download file into temp file
	#download.file("https://s3.amazonaws.com/plink2-assets/alpha3/plink2_win64_20221024.zip",paste0(Settings_env$s_ROOT_dir,"Programs/","GnuWin32/temp"))
	#
	## Unzip
	#unzip(paste0(Settings_env$s_ROOT_dir,"Programs/","GnuWin32/temp"),exdir=paste0(Settings_env$s_ROOT_dir,"Programs/","GnuWin32"))  # unzip your file 
	#
	## Remove temp file
	#file.remove(paste0(Settings_env$s_ROOT_dir,"Programs/","GnuWin32/temp"))


	#-----------------------------------------------------------------------------------------------------#
	#							Reference panel
	#-----------------------------------------------------------------------------------------------------#
	# Reference set folder
	if(!dir.exists(paste0(paste0(Settings_env$s_ROOT_dir,"Reference/")))){dir.create(file.path(paste0(paste0(Settings_env$s_ROOT_dir,"Reference/"))))}
	
	if(!file.exists(paste0(Settings_env$s_ref_loc_final,".cats"))){

		# print message for installer
		cat(">> Reference panel not detected on expected location! <<\n")
		cat("   - Installing reference panel from link\n\n")

		#if(!dir.exists(paste0(paste0(Settings_env$s_ROOT_dir,"Data_RAW/gbr_hapmap/")))){dir.create(file.path(paste0(paste0(Settings_env$s_ROOT_dir,"Data_RAW/gbr_hapmap/"))))}

		# Download file into temp file
		download.file("https://surfdrive.surf.nl/files/index.php/s/T3RLErWHxIyW5IM/download",paste0(Settings_env$s_ROOT_dir,"Reference/temp.zip"),"curl")

		# Unzip
		unzip(paste0(Settings_env$s_ROOT_dir,"Reference/temp.zip"),exdir=paste0(Settings_env$s_ROOT_dir,"Reference"))  # unzip your file 

		# Remove temp file
		file.remove(paste0(Settings_env$s_ROOT_dir,"Reference/temp.zip"))

	}



	#-----------------------------------------------------------------------------------------------------#
	#							Toy example
	#-----------------------------------------------------------------------------------------------------#
	if(!file.exists(paste0(paste0(Settings_env$s_ROOT_dir,"Reference/Example/"),"1000G_phase3_final_2.bed"))){

		# print message for installer
		cat(">> Example (toy) data not detected on expected location! <<\n")
		cat("   - Installing example (toy) data panel from link\n\n")

		if(!dir.exists(paste0(paste0(Settings_env$s_ROOT_dir,"Reference/Example/")))){dir.create(file.path(paste0(paste0(Settings_env$s_ROOT_dir,"Reference/Example/"))))}

		# Download file into temp file
		download.file("https://surfdrive.surf.nl/files/index.php/s/rjUmOgWaLfbk5DI/download",paste0(Settings_env$s_ROOT_dir,"Reference/Example/temp.zip"),"curl")

		# Unzip
		unzip(paste0(Settings_env$s_ROOT_dir,"Reference/Example/temp.zip"),exdir=paste0(Settings_env$s_ROOT_dir,"Reference/Example"))  # unzip your file 

		# Remove temp file
		file.remove(paste0(Settings_env$s_ROOT_dir,"Reference/Example/temp.zip"))

	}
	
	#-----------------------------------------------------------------------------------------------------#
	#							MODELS data
	#-----------------------------------------------------------------------------------------------------#

	# print message for installer
	cat(">> Installing PGS models <<\n\n")
	#cat("   - Installing example (toy) data panel from link\n\n")

	#if(!dir.exists(paste0(paste0(Settings_env$s_ROOT_dir,"Reference/Example/")))){dir.create(file.path(paste0(paste0(Settings_env$s_ROOT_dir,"Reference/Example/"))))}

	# Download file into temp file
	download.file("https://surfdrive.surf.nl/files/index.php/s/WZd5luvblyYaS4n/download",paste0(Settings_env$s_OUT_dir,"DATA/models/temp.zip"),"curl")

	# Unzip
	unzip(paste0(Settings_env$s_OUT_dir,"DATA/models/temp.zip"),exdir=paste0(Settings_env$s_OUT_dir,"DATA/models"))  # unzip your file 

	# Remove temp file
	file.remove(paste0(Settings_env$s_OUT_dir,"DATA/models/temp.zip"))
	
	#-----------------------------------------------------------------------------------------------------#
	#							Manifest
	#-----------------------------------------------------------------------------------------------------#
	if(!file.exists(paste0(paste0(Settings_env$s_ROOT_dir,"Manifest/"),"Ref_gwas_manifest.rda"))){
		
		# Make folder if needed
		if(!dir.exists(paste0(paste0(Settings_env$s_ROOT_dir,"Manifest/")))){dir.create(file.path(paste0(paste0(Settings_env$s_ROOT_dir,"Manifest/"))))}
	
		# print message for installer
		cat(">> Manifest not detected on expected location! <<\n")
		cat("   - Getting Manifest from link\n\n")
	

		# Download file into temp file
		download.file("https://surfdrive.surf.nl/files/index.php/s/1zi299F4rs3aIwt/download",paste0(Settings_env$s_ROOT_dir,"Manifest/","temp.zip"),"curl")

		# Unzip
		unzip(paste0(Settings_env$s_ROOT_dir,"Manifest/","temp.zip"),exdir=paste0(Settings_env$s_ROOT_dir,"Manifest"))  # unzip your file 

		# Remove temp file
		file.remove(paste0(Settings_env$s_ROOT_dir,"Manifest/","temp.zip"))
	}
}