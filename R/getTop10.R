#' Generate a table of the top 10 significant pathways within positive NES as well as the top 10 significant pathways within negative NES
#'
#' @param sgsea.result A data frame (e.g. an object from getSGSEA results).
#' @param pathways A list of pathways annotation (e.g. the result object from getReactome function).
#' @param stats A named list of statistics (e.g. the result object from getLFC or getLHR) with corresponding unique gene symbols. The list should not contain any NA's.
#' @param plotParam The parameter to adjust the displayed values. If close to 0, will get a flatten plot. The Default is 1.
#' @import fgsea
#' @import utils
#' @return A data frame of the top 10 significant  pathways within positive NES as well as the top 10 significant pathways within negative NES in a ggplot object embedded with the enrichment barcode plots.
#' @export
#'

getTop10 <- function(sgsea.result,pathways,stats,plotParam){

  sgsea.result <- data.frame(sgsea.result)
  Pos <- sgsea.result[sgsea.result$NES > 0,]
  PosTopSig <- utils::head(order(Pos$padj), n=10)
  PosTopPathways <- Pos$pathway[PosTopSig]

  Neg <- sgsea.result[sgsea.result$NES < 0,]
  NegTopSig <- utils::head(order(Neg$padj), n=10)
  NegTopPathways <- Neg$pathway[NegTopSig]

  topPathways <- c(PosTopPathways, rev(NegTopPathways))

  return(fgsea::plotGseaTable(pathways=pathways[topPathways], stats=stats, fgseaRes=sgsea.result,
                       gseaParam=plotParam))

}
