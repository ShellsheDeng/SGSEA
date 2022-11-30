#' get top10 head and tail significant pathways
#'
#' @param sgsea.result a table from getSGSEA results.
#' @param pathways the human pathways imported from Reactome. Same object as input in getSGSEA function.
#' @param stats a named list of log hazard ratios. Same object as input in getSGSEA function.
#' @param plotParam The parameter to adjust the displayed values. If close to 0, will get a flatten plot. The Default is 1.
#' @import fgsea
#' @import utils
#' @return a table of top10 head and tail significant pathways in a ggplot object with enrichment barcode plots.
#' @export
#'

getTop10 <- function(sgsea.result,pathways,stats,plotParam){

  Pos <- sgsea.result[sgsea.result$NES > 0]
  PosTopSig <- utils::head(order(Pos$padj), n=10)
  PosTopPathways <- Pos$pathway[PosTopSig]

  Neg <- sgsea.result[sgsea.result$NES < 0]
  NegTopSig <- utils::head(order(Neg$padj), n=10)
  NegTopPathways <- Neg$pathway[NegTopSig]

  topPathways <- c(PosTopPathways, rev(NegTopPathways))

  fgsea::plotGseaTable(pathways=pathways[topPathways], stats=stats, fgseaRes=sgsea.result,
                       gseaParam=plotParam)
}
