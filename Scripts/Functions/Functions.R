#-----------------------------------------------------------------------------------------------------#
# 							GENERAL INFORMATION
#-----------------------------------------------------------------------------------------------------#
# File description:
#	Name
#		Functions.R
#
#	Purpose 
#		This code was made as sub-master level regulation script.
#
# Author comment:
#	Rick A. Reijnders 
#	ra.reijnders@maastrichtuniversity.nl
#
#	Personal comment:
#
#
#-----------------------------------------------------------------------------------------------------#
#							Main Functions
#-----------------------------------------------------------------------------------------------------#

#-----------------------------------------------------------------------------------------------------#
#							PLOTTING 
#-----------------------------------------------------------------------------------------------------#

# Auto generate high res images. PDF and TIFF at location given below
# default is 7 inch; this is now 480 (px?) in this function (so both pdf and tidd scale nice)
Rplot = function(insert=NA,title="Temp_title",resolution = 350, width = 480, height = 480){
	pdf(paste0(s_figure_folder,title,".pdf"),width = width/(480/7),height = height/(480/7)) 
		print({insert})
	dev.off()


	tiff(paste0(s_figure_folder,title,".tiff"),width = width*(resolution/72), height = height*(resolution/72),res = resolution)
		print({insert})
	dev.off()
}

#-----------------------------------------------------------------------------------------------------#
#							Cleanup
#-----------------------------------------------------------------------------------------------------#
Rclean = function(){
	rm(list=ls(envir = .GlobalEnv)[grep(ls(envir = .GlobalEnv),pattern = "^temp_")],envir = .GlobalEnv)
}

#-----------------------------------------------------------------------------------------------------#
#							output
#-----------------------------------------------------------------------------------------------------#

