#' get survival-based gene set enrichment anaysis
#' @description Perform a gene set enrichment analysis based on the survival statistics,
#' the log hazard ratio, by calling the functions from fgsea package,
#' and compare with pathways from Reactome database.


#' @param pathways a list of human pathways imported from Reactome database.
#' @param stats a named list of statistics(logHazardRatio or logFoldChange) with corresponding gene symbols. The gene symbols should be unique. The list should not contain any NA's.
#' @param minGenes the minimal number of genes that are included in a gene set for the test.
#' @param maxGenes the maximum number of genes that are included in a gene set for the test.
#' @param powerParam The default value is 1, meaning that gene-level stats are used as it's. If gseaParam is 0, then all gene-level stats effectively become ones
#' and GSEA test becomes Kolmogorov-Smirnov test. The power of the test that all input gene-level stats are raised to. Also see gseaParam in fgsea function from fgsea package.


#' @import BiocManager
#' @import BiocParallel
#' @import fgsea
#' @return A table of GSEA results.Rows are the tested pathways and columns are
#' name of the pathway, p-value of the enrichment test, a BH-adjusted p-value, Enrichment Scores,
#' Normalized enrichment score to the corresponding the sample size, and leading edge. Also see
#' Value in the fgsea function from fgsea package.
#'
#' @export


getSGSEA <- function (pathways, stats, minGenes, maxGenes, powerParam=1) {

  s.fgsea.result <- fgsea::fgsea(pathways = pathways,
                          stats    = stats,
                          minSize  = minGenes,
                          maxSize  = maxGenes,
                          gseaParam = powerParam)

  return(s.fgsea.result)
}
