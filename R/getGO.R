#' Gets gene sets with Hugo gene symbols to use with SGSEA analysis based on GO terms.
#'
#' @param species currently accepts 'human' or 'mouse'
#'
#' @import BiocManager
#' @import GO.db
#' @import annotate
#' @import AnnotationDbi
#' @import org.Mm.eg.db
#' @import org.Hs.eg.db
#' @importFrom stats na.omit
#' @importFrom utils setTxtProgressBar txtProgressBar
#'
#' @return A list of gene sets from the Gene Ontology database
#'
#' @export
#'
getGO <- function(species = 'human') {

   db <- ''
  # Load correct annotation database
  if (species == 'human') {
    if (!requireNamespace("org.Hs.eg.db", quietly = TRUE)) {
      stop("Package 'org.Hs.eg.db' is required but not installed. Install it using BiocManager::install('org.Hs.eg.db').")
    }
    db <- "org.Hs.eg.db"
  } else if (species == 'mouse') {
    if (!requireNamespace("org.Mm.eg.db", quietly = TRUE)) {
      stop("Package 'org.Mm.eg.db' is required but not installed. Install it using BiocManager::install('org.Mm.eg.db').")
    }
    db <- "org.Mm.eg.db"
  } else {
    stop(paste0('Species ', species, ' not supported.'))
  }

  # Ensure GO.db is loaded
  if (!requireNamespace("GO.db", quietly = TRUE)) {
    stop("Package 'GO.db' is required but not installed. Install it using BiocManager::install('GO.db').")
  }

  # Retrieve GO terms mapped to gene IDs using AnnotationDbi::select
  go_mapping <- AnnotationDbi::select(
    get(db),
    keys = keys(get(db), keytype = "ENTREZID"),
    columns = c("SYMBOL", "GO"),
    keytype = "ENTREZID"
  )

  # Remove NA values and ensure proper mapping
  go_mapping <- na.omit(go_mapping)

  # Create a list of GO terms with corresponding gene symbols
  go_sets_full <- split(go_mapping$SYMBOL, go_mapping$GO)

  pb <- txtProgressBar(min = 0, max = length(go_sets_full), style = 3)

  go_sets <- list()

  for (i in seq_along(go_sets_full)) {
    go_sets[[i]] <- unique(na.omit(go_sets_full[[i]]))
    setTxtProgressBar(pb, i)
  }
  close(pb)

  names(go_sets) <- names(go_sets_full)

  # Use GO.db to get GO term descriptions
  go_descriptions <- sapply(names(go_sets), function(go_id) {
    term <- tryCatch(Term(GOTERM[[go_id]]), error = function(e) NA)
    if (!is.na(term)) term else go_id
  })

  names(go_sets) <- go_descriptions

  # Remove empty lists
  go_sets <- go_sets[lengths(go_sets) > 0]

  return(go_sets)
}
