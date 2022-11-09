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
#							Main settings or load
#-----------------------------------------------------------------------------------------------------#
source("C:/DATA_STORAGE/Projects/PRS-multi-trait/Scripts/.Main/Settings.R")

#-----------------------------------------------------------------------------------------------------#
#							make folders if needed
#-----------------------------------------------------------------------------------------------------#
if(!dir.exists(paste0(paste0(s_ROOT_dir,"Programs/")))){dir.create(file.path(paste0(paste0(s_ROOT_dir,"Programs/"))))}
temp_all_dirs = c("LDAK","Plink2")
lapply(temp_all_dirs,function(i){if(!dir.exists(paste0(paste0(s_ROOT_dir,"Programs/"),i))){dir.create(file.path(paste0(paste0(s_ROOT_dir,"Programs/"),i)))}})


#-----------------------------------------------------------------------------------------------------#
#							LDAK
#-----------------------------------------------------------------------------------------------------#
# Download file into temp file
download.file("https://dougspeed.com/wp-content/uploads/ldak5.2.linux_.zip",paste0(s_ROOT_dir,"Programs/","LDAK/temp"))

# Unzip
unzip(paste0(s_ROOT_dir,"Programs/","LDAK/temp"),exdir=paste0(s_ROOT_dir,"Programs/","LDAK"))  # unzip your file 

# Remove temp file
file.remove(paste0(s_ROOT_dir,"Programs/","LDAK/temp"))
#-----------------------------------------------------------------------------------------------------#
#							Plink2
#-----------------------------------------------------------------------------------------------------#
# Download file into temp file
download.file("https://s3.amazonaws.com/plink2-assets/alpha3/plink2_win64_20221024.zip",paste0(s_ROOT_dir,"Programs/","Plink2/temp"))

# Unzip
unzip(paste0(s_ROOT_dir,"Programs/","Plink2/temp"),exdir=paste0(s_ROOT_dir,"Programs/","Plink2"))  # unzip your file 

# Remove temp file
file.remove(paste0(s_ROOT_dir,"Programs/","Plink2/temp"))

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


