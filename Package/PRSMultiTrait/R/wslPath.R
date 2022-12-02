#' wslPath
#' @return
#' @examples
#' @export
wslPath = function(localpath){
	temp_drive = gsub(localpath,pattern = "/.*$",replacement = "")
	wsl_drive = paste0("/mnt/",tolower(substr(temp_drive ,1,1)),"/")
	
	temp_path = substr(localpath,(unlist(gregexpr(':', localpath))[1] + 2),nchar(localpath))
	
	
	return(paste0(wsl_drive,temp_path))
}