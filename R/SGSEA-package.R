#' SGSEA: Survival-based Gene Set Enrichment Analysis Package
#'
#' The SGSEA package provides functions to analyze the relationship between
#' transcriptomic variation and survival using gene set enrichment analysis.
#'
#' @section Main Functions:
#' - `getNorm()`: Normalizes input gene expression data.
#' - `getLHR()`: Computes log hazard ratio (LHR) with optional covariates.
#' - `getLFC()`: Computes log fold change (LFC).
#' - `getReactome()`: Retrieves Reactome pathways.
#' - `getGO()`: Retrieves Gene Ontology (GO) terms.
#' - `getSGSEA()`: Runs the SGSEA analysis.
#' - `getEnrichPlot()`: Generates an enrichment plot for a pathway.
#' - `getTop10()`: Identifies the top 10 enriched and bottom 10 pathways.
#' - `downloadExampleData()`: Downloads an example dataset.
#' - `exportRankedGenes()`: Export Ranked Genes with Cox Hazard Ratios to a CSV file
#' - `runExample()`: Launch to a corresponding SGSEA Shiny app
#'
#' @section Example Script:
#' To download and open the example script, run:
#' \preformatted{
#' script_path <- system.file("scripts", "SGSEA_example_script.R", package = "SGSEA")
#' file.copy(script_path, "SGSEA_example_script.R")
#' file.edit("SGSEA_example_script.R")
#' }
#'
#' @keywords package
#' @name SGSEA
#' @noRd

NULL

## Keep Existing Metadata
#' @keywords internal
"_PACKAGE"

## usethis namespace: start
#' @importFrom stats na.omit
#' @importFrom utils setTxtProgressBar
#' @importFrom utils txtProgressBar
## usethis namespace: end
NULL
