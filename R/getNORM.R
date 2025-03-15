#' Normalized the raw counts data
#' @description This function uses mean-variance method to get a normalized count data.
#' using the voom function from limma package. Data should be filtered
#' before entering this step.
#'
#' @param countsData A data frame contains all numeric counts.
#' Rows must be the sample IDs. Columns must be the unique gene symbols.
#' See the included 'KIRC' dataset for an example.
#'@param plot Logical. If `TRUE`, a mean-variance plot will be generated. Default is `FALSE`.

#' @import limma
#' @return a data frame with normalized counts.
#' @export

getNorm <- function (countsData,plot = FALSE) {

  # Ensure input is a data frame
  if(!(is.data.frame(countsData))) {
    stop(paste0(countsData, 'must be a data frame'))
  }

  # Ensure all columns are numeric (gene expression)
  if (!all(sapply(countsData, is.numeric))) {
    stop("All columns in 'countsData' must be numeric gene expression values.")
  }

  # Ensure column names are unique
  if (anyDuplicated(colnames(countsData))) {
    stop("Column names (gene symbols) must be unique.")
  }

  # Normalize the data using voom
  a<-limma::voom(countsData,plot= plot)
  normalizedData<-as.data.frame(a$E)
  return(normalizedData)
}
