#' Kidney Renal clear cell carcinoma(KIRC)
#'
#' An example of the data structure, which is a subset of Kidney Renal Clear Cell Carcinoma mRNA seq data (version 2016_01_28) from Broad Institute The Cancer Genome Atlas (TCGA) Genome Data Analysis Center (GDAC) Firehose website (http://gdac.broadinstitute.org).
#'
#' @format A data frame with 520 rows (patient ID) and 3000 variables (gene symbols):
#' \describe{
#'   \item{ID}{patient's ID}
#'   \item{survtime}{patient's survival time in days}
#'   \item{status}{1 for alive, 2 for dead}
#'   \item{barcode}{patient's barcode}
#'   \item{A1BG}{gene symbol}
#'   ...
#' }
#' @source <https://gdac.broadinstitute.org/#>
#' @examples
#' data(KIRC)  # lazy loading.
"KIRC"
