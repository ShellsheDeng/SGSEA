#' Perform the Survival-based Gene Set Enrichment Analysis
#' @description This function can perform the Survival-based Gene Set Enrichment Analysis (SGSEA) based on the survival statistics, log hazard ratios, and the typical case vs. control (or normal vs. tumor) GSEA. This function is calling the fgsea function from the fgsea package.
#' @param pathways A list of pathways annotation (e.g. the result object from getReactome function).
#' @param stats A named list of statistics (e.g. the result object from getLFC or getLHR) with corresponding unique gene symbols. The list should not contain any NA's.
#' @param minGenes The minimal number of genes that are included in a gene set for the test.
#' @param maxGenes The maximum number of genes that are included in a gene set for the test.
#' @param powerParam The default value is 1, meaning that gene-level stats are used as it's. If gseaParam is 0, then all gene-level stats effectively become ones
#' and GSEA test becomes Kolmogorov-Smirnov test. The power of the test that all input gene-level stats are raised to. Also see gseaParam in fgsea function from fgsea package.


#' @import BiocManager
#' @import BiocParallel
#' @import fgsea
#' @return A table of pathway enrichment analysis results. Rows are the tested pathways and columns are the p-values, adjusted p-values, log 2 of the standard errors, enrichment scores,
#' normalized enrichment scores, sample size for each pathway, and leading edge genes. See value in the fgsea function from fgsea package for more details.
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
