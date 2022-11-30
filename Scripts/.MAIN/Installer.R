#-----------------------------------------------------------------------------------------------------#
# 							GENERAL INFORMATION
#-----------------------------------------------------------------------------------------------------#
# File description:
#	Name
#		Installer.R
#
#	Purpose 
#		This code installs plink2 LDAK and gzip
#
# Author comment:
#	Rick A. Reijnders 
#	ra.reijnders@maastrichtuniversity.nl
#
#	Personal comment:
#
#
#-----------------------------------------------------------------------------------------------------#
#							make folders if needed
#-----------------------------------------------------------------------------------------------------#
if(!dir.exists(paste0(paste0(s_ROOT_dir,"Programs/")))){dir.create(file.path(paste0(paste0(s_ROOT_dir,"Programs/"))))}
lapply(c("LDAK","Plink2"),function(i){if(!dir.exists(paste0(paste0(s_ROOT_dir,"Programs/"),i))){dir.create(file.path(paste0(paste0(s_ROOT_dir,"Programs/"),i)))}})

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
if(!file.exists(f_windowspath(s_ldak))){

	# print message for installer
	cat(">> LDAK not detected on expected location! <<\n")
	cat("   - Installing LDAK from dougspeed.com\n\n")

	# Download file into temp file
	download.file("https://dougspeed.com/wp-content/uploads/ldak5.2.linux_.zip",paste0(s_ROOT_dir,"Programs/","LDAK/temp"))

	# Unzip
	unzip(paste0(s_ROOT_dir,"Programs/","LDAK/temp"),exdir=paste0(s_ROOT_dir,"Programs/","LDAK"))  # unzip your file 

	# Remove temp file
	file.remove(paste0(s_ROOT_dir,"Programs/","LDAK/temp"))

}
#-----------------------------------------------------------------------------------------------------#
#							Plink2
#-----------------------------------------------------------------------------------------------------#
if(!file.exists(s_plinkloc)){

	# print message for installer
	cat(">> Plink2 not detected on expected location! <<\n")
	cat("   - Installing Plink2 from cog-genomics.org\n\n")

	# Download file into temp file
	download.file("https://s3.amazonaws.com/plink2-assets/alpha3/plink2_win64_20221024.zip",paste0(s_ROOT_dir,"Programs/","Plink2/temp"))

	# Unzip
	unzip(paste0(s_ROOT_dir,"Programs/","Plink2/temp"),exdir=paste0(s_ROOT_dir,"Programs/","Plink2"))  # unzip your file 

	# Remove temp file
	file.remove(paste0(s_ROOT_dir,"Programs/","Plink2/temp"))

}
##-----------------------------------------------------------------------------------------------------#
##							GnuWin32
##-----------------------------------------------------------------------------------------------------#
## Download file into temp file
#download.file("https://s3.amazonaws.com/plink2-assets/alpha3/plink2_win64_20221024.zip",paste0(s_ROOT_dir,"Programs/","GnuWin32/temp"))
#
## Unzip
#unzip(paste0(s_ROOT_dir,"Programs/","GnuWin32/temp"),exdir=paste0(s_ROOT_dir,"Programs/","GnuWin32"))  # unzip your file 
#
## Remove temp file
#file.remove(paste0(s_ROOT_dir,"Programs/","GnuWin32/temp"))


#-----------------------------------------------------------------------------------------------------#
#							Reference panel
#-----------------------------------------------------------------------------------------------------#
if(!file.exists(paste0(s_ref_loc_final,".cats"))){

	# print message for installer
	cat(">> Reference panel not detected on expected location! <<\n")
	cat("   - Installing reference panel from link\n\n")

	if(!dir.exists(paste0(paste0(s_ROOT_dir,"Data_RAW/gbr_hapmap/")))){dir.create(file.path(paste0(paste0(s_ROOT_dir,"Data_RAW/gbr_hapmap/"))))}

	# Download file into temp file
	download.file("https://surfdrive.surf.nl/files/index.php/s/T3RLErWHxIyW5IM/download",paste0(s_ROOT_dir,"Data_RAW/temp.zip"),"curl")

	# Unzip
	unzip(paste0(s_ROOT_dir,"Data_RAW/temp.zip"),exdir=paste0(s_ROOT_dir,"Data_RAW"))  # unzip your file 

	# Remove temp file
	file.remove(paste0(s_ROOT_dir,"Data_RAW/temp.zip"))

}



#-----------------------------------------------------------------------------------------------------#
#							Toy example
#-----------------------------------------------------------------------------------------------------#
if(!file.exists(paste0(paste0(s_ROOT_dir,"Data_RAW/Example/"),"1000G_phase3_final_2.bed"))){

	# print message for installer
	cat(">> Example (toy) data not detected on expected location! <<\n")
	cat("   - Installing example (toy) data panel from link\n\n")

	if(!dir.exists(paste0(paste0(s_ROOT_dir,"Data_RAW/Example/")))){dir.create(file.path(paste0(paste0(s_ROOT_dir,"Data_RAW/Example/"))))}

	# Download file into temp file
	download.file("https://surfdrive.surf.nl/files/index.php/s/rjUmOgWaLfbk5DI/download",paste0(s_ROOT_dir,"Data_RAW/Example/temp.zip"),"curl")

	# Unzip
	unzip(paste0(s_ROOT_dir,"Data_RAW/Example/temp.zip"),exdir=paste0(s_ROOT_dir,"Data_RAW/Example"))  # unzip your file 

	# Remove temp file
	file.remove(paste0(s_ROOT_dir,"Data_RAW/Example/temp.zip"))

}
