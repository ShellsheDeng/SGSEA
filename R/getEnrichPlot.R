#' Enrichment plot for an individual pathway
#'
#' @param pathways the human pathways imported from Reactome. Same object as input in getSGSEA function.
#' @param pathwayName enter the whole name of a specific pathway from your result table with the quotation mark.
#' @param stats log hazard ratios or log fold changes.
#' @import fgsea
#' @import ggplot2
#' @return the enrichment plot for an individual pathway
#' @export
#'

getEnrichPlot <- function(pathways,pathwayName,stats){

  return(fgsea::plotEnrichment(pathways[[pathwayName]],stats) +
           ggplot2::labs(title=pathwayName)
  )


}


