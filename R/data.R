#' Example KIRC (Kidney Renal clear cell carcinoma) dataset
#'
#' A curated subset of Kidney Renal Clear Cell Carcinoma (KIRC) mRNA-seq data (version 2016_01_28) from the TCGA GDAC Firehose portal.
#' This dataset is used to demonstrate the SGSEA workflow.
#'
#' @format A data frame with 50 patients (rows) and 623 variables (columns):
#' \describe{
#'   \item{ID}{Patient identifier}
#'   \item{survtime}{Survival time in days}
#'   \item{status}{Survival status (1 = alive, 2 = dead)}
#'   \item{Gene expression columns}{The remaining ~620 columns contain expression values for selected genes (e.g., A1BG, A1CF, A4GALT, etc.)}
#'}



#' @source <https://gdac.broadinstitute.org/#>
#' @examples
#' data(KIRC)  # lazy loading.
#' head(KIRC)
"KIRC"




#' KIRC_DEA: Curated Dataset for Differential Expression Analysis
#'
#' A subset of the Kidney Renal Clear Cell Carcinoma (KIRC) mRNA-seq data from TCGA, curated for differential expression analysis.
#' This dataset contains 140 samples (70 tumor and 70 normal) with raw gene expression counts and corresponding TCGA sample IDs.
#' Tumor samples have IDs containing "01A", while normal samples contain "11A".
#' Gene symbols start from the very first column and each row corresponds to a TCGA sample. Sample IDs are stored as row names.
#'
#' @format A data frame with 140 rows (samples) and 620 gene symbols as columns. The row names are TCGA sample IDs.
#' \describe{
#'  \item{Gene expression columns}{Columns represent expression values for genes (e.g., AAAS, ABCD3, ABL1, etc.)}
#' }
#' @source \url{https://gdac.broadinstitute.org/}
#' @examples
#' data(KIRC_DEA)
#' head(KIRC_DEA)
"KIRC_DEA"
