#' wslPath
#' @return
#' @examples
#' @export
runApp <- function() {
  appDir <- system.file("myapp", package = "PRSMultiTrait")
  if (appDir == "") {
    stop("Could not find myapp. Try re-installing `mypackage`.", call. = FALSE)
  }

  shiny::runApp(appDir, display.mode = "normal")
}