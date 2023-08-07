#' Extract the gene annotation with Hugo gene symbols from the Reactome database.
#'
#' @param species Currently only accepts 'human' or 'mouse'
#' @import BiocManager
#' @import reactome.db
#' @import annotate
#' @import org.Mm.eg.db
#' @import org.Hs.eg.db
#' @importFrom stats na.omit
#' @importFrom  utils setTxtProgressBar txtProgressBar
#' @return A large list of pathway annotation with gene symbols.
#' @export
#'



getReactome <- function(species = 'human') {

  db = ''

  if(species == 'human') {
    requireNamespace("org.Hs.eg.db", quietly = TRUE)
    db <- 'org.Hs.eg'
  } else if(species == 'mouse') {
    requireNamespace("org.Mm.eg.db", quietly = TRUE)
    db <- 'org.Mm.eg'
  } else {
    stop(paste0('Species ', species, ' not supported.'))
  }

  reactome_sets_full <- as.list(reactomePATHID2EXTID)

  pb <- txtProgressBar(min = 0, max = length(reactome_sets_full), style = 3)

  reactome_sets <- list()

  for(i in 1:length(reactome_sets_full)) {
    reactome_sets[[i]] <- as.vector(na.omit(getSYMBOL(reactome_sets_full[[i]], data=db)))
    setTxtProgressBar(pb, i)
  }
  close(pb)
  names(reactome_sets) <- names(reactome_sets_full)

  xx = as.list(reactomePATHID2NAME)

  names(reactome_sets) = xx[names(reactome_sets)]

  reactome_sets <- reactome_sets[lapply(reactome_sets, length)>0]

  return(reactome_sets)
}
