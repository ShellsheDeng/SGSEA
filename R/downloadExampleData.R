#' Download Example Data for SGSEA
#'
#' This function allows users to download the example dataset ("KIRC")
#' provided with the SGSEA package. The dataset demonstrates the expected input format.
#' @name downloadExampleData
#' @param file_name A string specifying the file name to save the example dataset as (default: "KIRC_example.csv").
#' @param path A string specifying the directory where the file should be saved (default: current working directory).
#' @return A message indicating where the file was saved.
#' @importFrom utils globalVariables

#' @examples
#' \dontrun{
#'   SGSEA::downloadExampleData()
#' }
#' @export

utils::globalVariables("KIRC")

downloadExampleData <- function(file_name = "KIRC_example.csv", path = getwd()) {
  # Explicitly load the dataset
  data("KIRC", package = "SGSEA", envir = environment())

  if (!exists("KIRC", where = "package:SGSEA")) {
    stop("Example dataset 'KIRC' not found in SGSEA package. Ensure the package is correctly installed.")
  }

  # Create full file path
  file_path <- file.path(path, file_name)

  # Save the dataset
  write.csv(KIRC, file = file_path, row.names = FALSE)

  message("Example dataset saved to: ", file_path)
  return(invisible(file_path))
}
