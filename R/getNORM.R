#' get normalized data
#' @description This function uses mean-variance method to get the normalized values for a count data. It's calling voom function from limma package.
#' @param countsData a data frame contains all numeric counts. Columns should be the gene symbols and rows should be sample IDs.
#' @import limma
#' @return return the same data frame format with normalized counts
#' @export

getNORM <- function (countsData) {

  if(!(is.data.frame(countsData))) {
    stop(paste0(countsData, 'must be a data frame'))
  }

  a<-limma::voom(countsData,plot=T)
  normalizedData<-as.data.frame(a$E)
  return(normalizedData)
}
