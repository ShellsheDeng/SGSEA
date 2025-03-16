#' Export Ranked Genes with Cox Hazard Ratios to a CSV file
#' @description
#' Saves a ranked list of genes with their log hazard ratios to a specified file.
#'
#'
#' @param lhr_results A named numeric vector (output from getLHR) where names are gene symbols and values are log hazard ratios.
#' @param file_path A character string specifying the file path to save the results. Default is "Ranked_Genes.csv".
#' @return The file path where the ranked gene list is saved.
#' @export

exportRankedGenes <- function(lhr_results, file_path = "ranked_genes.csv") {


  # Check if input is a named numeric vector
  if (!is.numeric(lhr_results) || is.null(names(lhr_results))) {
    stop("lhr_results must be a named numeric vector (output from getLHR).")
  }

  # Convert named vector to a data frame
  ranked_genes <- data.frame(Gene = names(lhr_results), LHR = lhr_results,
                             stringsAsFactors = FALSE)

  # Order genes by LHR (highest to lowest)
  ranked_genes <- ranked_genes[order(-ranked_genes$LHR), ]

  # Save to CSV
  write.csv(ranked_genes, file = file_path, row.names = FALSE)

  message("Ranked gene list saved to: ", file_path)
  return(invisible(file_path))

}
