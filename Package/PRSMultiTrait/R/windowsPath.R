#' windowsPath
#' @return This function transforms a linux path to Windows path
#' @param localpath Insert a linux path to be changed to a Windows path
#' @examples windowsPath(localpath = "c/mnt/Users/Default/Downloads/Manifest.tsv")
#' @export
windowsPath = function(localpath){
	wsl_drive = gsub(localpath,pattern = "^/mnt/(?=[A-z])|/.*$",replacement = "",perl=TRUE)
	wind_drive = paste0(toupper(wsl_drive),":/")
	
	
	temp_path = gsub(localpath,pattern = "^/mnt/[A-z]/",replacement = "",perl=TRUE)
	
	
	return(paste0(wind_drive,temp_path))
}