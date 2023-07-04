#' Generate log fold change from the negative binomial generalized linear model
#' @description Return a list of log fold changes with corresponding gene symbols as their names. This function is calling DESeq function from DESeq2 package.
#' @param countData a data frame contains only counts. Rows should be sample IDs and columns are the gene symbols and should be unique. Data should be filtered before entering this step.
#' @param label1 group label for the samples.
#' @param label2 group label for the samples.
#' @param numRep Number of replications for each condition.
#' @import DESeq2
#' @import stats
#' @return a named list of log fold changes with corresponding gene symbols.
#' @export
#'

getLFC <- function(countData,label1,label2,numRep){

  if(!(is.data.frame(countData))) {
    stop(paste0(countData, 'must be a data frame'))
  }

  condition <- factor(rep(c("label1","label2"),each=numRep))
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