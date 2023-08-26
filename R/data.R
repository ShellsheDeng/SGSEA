#' Kidney Renal clear cell carcinoma(KIRC)
#'
#' An example of the data structure, which is a subset of Kidney Renal Clear Cell Carcinoma mRNA seq data (version 2016_01_28) from Broad Institute The Cancer Genome Atlas (TCGA) Genome Data Analysis Center (GDAC) Firehose website (http://gdac.broadinstitute.org).
#'
#' @format A data frame with 50 observations and 10 variables:
#' \describe{
#'   \item{ID}{patient's ID}
#'   \item{survtime}{patient's survival time in days}
#'   \item{status}{1 for alive, 2 for dead}
#'   \item{A1BG}{gene symbol}
#'   \item{A1CF}{gene symbol}
#'   \item{A2BP1}{gene symbol}
#'   \item{A2LD1}{gene symbol}
#'   \item{A2ML1}{gene symbol}
#'   \item{A2M}{gene symbol}
#'   \item{A4GALT}{gene symbol}
#' }
#' @source <https://gdac.broadinstitute.org/#>
#' @examples
#' data(KIRC)  # lazy loading.
"KIRC"
