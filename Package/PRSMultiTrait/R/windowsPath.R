#' windowsPath
#' @return
#' @examples
#' @export
windowsPath = function(localpath){
	wsl_drive = gsub(localpath,pattern = "^/mnt/(?=[A-z])|/.*$",replacement = "",perl=TRUE)
	wind_drive = paste0(toupper(wsl_drive),":/")
	
	
	temp_path = gsub(localpath,pattern = "^/mnt/[A-z]/",replacement = "",perl=TRUE)
	
	
	return(paste0(wind_drive,temp_path))
}