#' Extract the gene annotation with Hugo gene symbols from the Reactome database.
#'
#' @param species Currently only accepts 'human' or 'mouse'
#' @import BiocManager
#' @import reactome.db
#' @import annotate
#' @import org.Mm.eg.db
#' @import org.Hs.eg.db
#' @import AnnotationDbi
#' @importFrom stats na.omit
#' @importFrom  utils setTxtProgressBar txtProgressBar
#' @return A large list of pathway annotation with gene symbols.
#' @export
#'



getReactome <- function(species = 'human') {

  db = ''

  if (!requireNamespace("reactome.db", quietly = TRUE)) {
    stop("Package 'reactome.db' is required but not installed. Install it using BiocManager::install('reactome.db').")
  }

  if (!requireNamespace("annotate", quietly = TRUE)) {
    stop("Package 'annotate' is required but not installed. Install it using BiocManager::install('annotate').")
  }

    if(species == 'human') {
    if (!requireNamespace("org.Hs.eg.db", quietly = TRUE)) {
      stop("Package 'org.Hs.eg.db' is required but not installed. Install it using BiocManager::install('org.Hs.eg.db').")
    }


    db <- "org.Hs.eg.db"

  } else if(species == 'mouse') {
    if (!requireNamespace("org.Mm.eg.db", quietly = TRUE)) {
      stop("Package 'org.Mm.eg.db' is required but not installed. Install it using BiocManager::install('org.Hs.eg.db').")
    }

    db <- "org.Mm.eg.db"
  } else {
    stop(paste0('Species ', species, ' not supported.'))
  }

  reactome_sets_full <- AnnotationDbi::as.list(reactome.db::reactomePATHID2EXTID)

  pb <- txtProgressBar(min = 0, max = length(reactome_sets_full), style = 3)

  reactome_sets <- list()

  for(i in 1:length(reactome_sets_full)) {

    reactome_sets[[i]] <- as.vector(na.omit(annotate::getSYMBOL(reactome_sets_full[[i]], data=db)))
    utils::setTxtProgressBar(pb, i)
  }
  close(pb)
  names(reactome_sets) <- names(reactome_sets_full)

  xx = AnnotationDbi::as.list(reactome.db::reactomePATHID2NAME)

  names(reactome_sets) = xx[names(reactome_sets)]

  reactome_sets <- reactome_sets[lapply(reactome_sets, length)>0]

  return(reactome_sets)
}
