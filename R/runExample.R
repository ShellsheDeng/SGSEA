#' Launch to a corresponding SGSEA Shiny app
#' @description Need to call the package name first to avoid conflict functions from other packages (e.g. SGSEA::runExample())
#' @export

runExample <- function() {
  appDir <- system.file("shiny-examples", "SGSEAapp", package = "SGSEA")
  if (appDir == "") {
    stop("Could not find example directory. Try re-installing `SGSEA`.", call. = FALSE)
  }

  shiny::runApp(appDir, display.mode = "normal")
}
