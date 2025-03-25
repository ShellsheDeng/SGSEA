#' Download Example Data for SGSEA
#'
#' This function allows users to download the example datasets ("KIRC" or "KIRC_DEA")
#' provided with the SGSEA package. These datasets demonstrate the expected input formats
#' for SGSEA analyses.
#' @name downloadExampleData
#' @param dataset A string specifying which dataset to download: "KIRC" or "KIRC_DEA" (default: "KIRC").
#' @param file_name A string specifying the file name to save the example dataset as (default: "KIRC_example.csv").
#' @param path A string specifying the directory where the file should be saved (default: current working directory).
#' @return A message indicating where the file was saved.
#' @importFrom utils globalVariables
#' @examples
#' \dontrun{
#'   SGSEA::downloadExampleData()                     # Downloads KIRC
#'   SGSEA::downloadExampleData("KIRC_DEA")           # Downloads KIRC_DEA
#'   SGSEA::downloadExampleData("KIRC_DEA", "DEA.csv")
#' }
#' @export

utils::globalVariables(c("KIRC", "KIRC_DEA"))

downloadExampleData <- function(dataset = "KIRC", file_name = paste0(dataset, "_example.csv"), path = getwd()) {
  # Validate dataset choice
  if (!dataset %in% c("KIRC", "KIRC_DEA")) {
    stop("Invalid dataset name. Please choose either 'KIRC' or 'KIRC_DEA'.")
  }

  # Load the dataset dynamically
  data(list = dataset, package = "SGSEA", envir = environment())

  # Check if the dataset exists
  if (!exists(dataset, envir = environment())) {
    stop(paste("Example dataset", dataset, "not found in SGSEA package."))
  }

  # Get the actual dataset object
  dataset_obj <- get(dataset, envir = environment())

  # Create full file path
  file_path <- file.path(path, file_name)

  # Save the dataset
  write.csv(dataset_obj, file = file_path, row.names = FALSE)

  message("Example dataset '", dataset, "' saved to: ", file_path)
  return(invisible(file_path))
}
