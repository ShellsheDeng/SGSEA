#' Compute Log Fold Change (LFC) using DESeq2 for Case-Control Expression Data
#' @description This function performs differential expression analysis using a negative binomial GLM implemented in the DESeq2 package.
#' It returns a named numeric vector of log2 fold changes (LFC) for each gene. Data should be raw counts, already filtered for low expression.
#'
#' @param countData A data frame of raw gene expression counts.
#' Rows must be sample IDs and columns must be gene symbols.
#' Data should be filtered and normalized before using this function.

#' @param label1 Character label for the first condition (e.g., "cancer").
#' @param label2 Character label for the second condition (e.g., "normal").
#' @param label1_numRep Number of samples in the `label1` group.
#' @param label2_numRep Number of samples in the `label2` group.
#'
#' @return A named numeric vector of log2 fold changes, where names are gene symbols.
#' @import DESeq2
#' @importFrom stats na.omit
#' @export
#'
#' @examples
#' data(KIRC_DEA)
#' countData <- KIRC_DEA[, -1]
#' lfc <- getLFC(countData, label1 = "cancer", label2 = "normal", label1_numRep = 70, label2_numRep = 70)



getLFC <- function(countData,label1,label2,label1_numRep,label2_numRep){

  if(!(is.data.frame(countData))) {
    stop('countData must be a data frame')
  }


  if(nrow(countData) != (label1_numRep + label2_numRep) ) {
    stop('Row count must equal label1_numRep + label2_numRep.')
  }


  countData = as.data.frame(t(countData))
  condition <- as.factor(c(rep("label1",label1_numRep),rep("label2",label2_numRep)))
  coldata<- data.frame(row.names = colnames(countData),condition)

  dds<-DESeq2::DESeqDataSetFromMatrix(countData = round(countData),
                              colData = coldata,
                              design= ~ condition)

  dds<- DESeq2::DESeq(dds)
  dds.res<-DESeq2::results(dds,contrast = c("condition","label1","label2"))
  dds.res<-stats::na.omit(as.data.frame(dds.res))

  lfc <- dds.res$log2FoldChange
  names(lfc)<-rownames(dds.res)

  return(lfc)


}
