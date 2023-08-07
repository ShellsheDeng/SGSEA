#' Normalized the raw counts data
#' @description This function uses mean-variance method to get a normalized count data. It's using the voom function from limma package. Data should be filtered before entering this step.
#' @param countsData A data frame contains all numeric counts. Rows must be the sample IDs. Columns must be the unique gene symbols. See KIRC data included in this package as the input example format.
#' @import limma
#' @return Return a data frame with normalized counts.
#' @export

getNorm <- function (countsData) {

  if(!(is.data.frame(countsData))) {
    stop(paste0(countsData, 'must be a data frame'))
  }

  a<-limma::voom(countsData,plot=T)
  normalizedData<-as.data.frame(a$E)
  return(normalizedData)
}
