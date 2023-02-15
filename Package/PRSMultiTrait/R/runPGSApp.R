#' runPGSApp
#' @return This function will start the shiny interface to use this package. This way interacting with the package will be faster, more effecient, and less error-prone. 
#' @examples runPGSApp()
#' @export
runPGSApp <- function() {
  appDir <- system.file("myapp", package = "PRSMultiTrait")
  if (appDir == "") {
    stop("Could not find myapp. Try re-installing `mypackage`.", call. = FALSE)
  }

  shiny::runApp(appDir, display.mode = "normal")
}