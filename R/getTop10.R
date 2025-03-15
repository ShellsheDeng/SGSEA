#' Generate a table of the top 10 significant pathways with positive NES as well as the top 10 significant pathways with negative NES

#' @description This function identifies the top 10 enriched pathways with positive normalized enrichment scores (NES)
#' and the top 10 pathways with negative NES, embedding them into a ggplot object with enrichment barcode plots.
#'
#' @param sgsea.result A data frame containing SGSEA results (e.g., the output from `getSGSEA`).
#' @param pathways A named list of pathway annotations (e.g., the output from `getReactome`).
#' @param stats A named list of statistics (e.g., the output from `getLFC` or `getLHR`), where names correspond to unique gene symbols.
#' The list should not contain any `NA` values.
#' @param plotParam A numeric value to adjust the displayed enrichment scores. Lower values (close to 0) produce a flatter plot. Default is 1.
#' @import fgsea
#' @import utils
#' @return A ggplot object displaying the top 10 enriched pathways with positive NES and the top 10 enriched pathways with negative NES,
#' embedded with enrichment barcode plots.
#' @export
#'

getTop10 <- function(sgsea.result,pathways,stats,plotParam){

  sgsea.result <- data.frame(sgsea.result)

  # Ensure NES and padj columns exist
  if (!("NES" %in% colnames(sgsea.result)) || !("padj" %in% colnames(sgsea.result))) {
    stop("Error: `sgsea.result` must contain NES and padj columns.")
  }

  # Identify positive NES pathways
  Pos <- sgsea.result[sgsea.result$NES > 0,]
  if (nrow(Pos) > 0) {
    PosTopSig <- utils::head(order(Pos$padj, decreasing = FALSE), n = min(10, nrow(Pos)))
    PosTopPathways <- Pos$pathway[PosTopSig]
  } else {
    PosTopPathways <- character(0)  # Empty if no significant pathways
  }


  # Identify negative NES pathways
  Neg <- sgsea.result[sgsea.result$NES < 0, ]
  if (nrow(Neg) > 0) {
    NegTopSig <- utils::head(order(Neg$padj, decreasing = FALSE), n = min(10, nrow(Neg)))
    NegTopPathways <- Neg$pathway[NegTopSig]
  } else {
    NegTopPathways <- character(0)  # Empty if no significant pathways
  }

  # Combine the top pathways
  topPathways <- c(PosTopPathways, rev(NegTopPathways))

  # Ensure topPathways exist before plotting
  if (length(topPathways) == 0) {
    warning("No significant pathways found in SGSEA results.")
    return(NULL)
  }
  # Generate the enrichment plot
  return(fgsea::plotGseaTable(pathways=pathways[topPathways],
                              stats=stats,
                              fgseaRes=sgsea.result,
                              gseaParam=plotParam))

}
