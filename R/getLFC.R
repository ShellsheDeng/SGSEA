#' Generate a numeric vector of the log fold changes from the negative binomial generalized linear model
#' @description Return a numeric vector of the log fold changes with corresponding gene symbols as their names. This function is calling DESeq function from DESeq2 package, so it takes care of the normalization procedure within the model. Users don't need to use getNorm function before this step, but still need to filter the low expressed genes.
#' @param countData A data frame contains the raw counts. Rows must be the sample IDs and samples coming from the same experimental group should layout together (e.g. first 10 rows are label 1 and next 10 rows are label 2). Columns must be the unique gene symbols. See KIRC data included in this package as the input example format.
#' @param label1 A group label for the samples (e.g. cancer).
#' @param label2 A group label for the samples (e.g. normal).
#' @param label1_numRep Number of replications for label 1 group (e.g. first 10 rows are from label 1, then input 10).
#' @param label2_numRep Number of replications for label 2 group (e.g. next 20 rows are from label 2, then input 20).
#' @import DESeq2
#' @import stats
#' @return A named list of the log fold changes with their corresponding gene symbols.
#' @export
#'

getLFC <- function(countData,label1,label2,label1_numRep,label2_numRep){

  if(!(is.data.frame(countData))) {
    stop('must be a data frame')
  }

  if(nrow(countData) != (label1_numRep + label2_numRep) ) {
    stop('rows must be the sample IDs and columns must be the gene symbols')
  }

  countData = as.data.frame(t(countData))
  condition <- as.factor(c(rep("label1",label1_numRep),rep("label2",label2_numRep)))
  coldata<- data.frame(row.names = colnames(countData),condition)
  dds<-DESeq2::DESeqDataSetFromMatrix(countData = round(countData),
                              colData = coldata,
                              design= ~ condition)
  dds<- DESeq2::DESeq(dds)
  dds.res<-DESeq2::results(dds,contrast = c("condition","label1","label2"))
  dds.res<-as.data.frame(dds.res)
  dds.res<-stats::na.omit(dds.res)
  lfc <- dds.res$log2FoldChange
  names(lfc)<-rownames(dds.res)
  lfc<-na.omit(lfc)
  return(lfc)


}
