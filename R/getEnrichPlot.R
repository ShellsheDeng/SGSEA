#' Create an individual enrichment plot for a specific pathway
#' @description
#' This function is used to visuliaze the results for specific pathways of interest from SGSEA and it calls the fgsea package to produce the plot.
#'
#' @param pathways A list of human pathways imported from the Reactome database. Same object as the argument in getSGSEA function.
#' @param pathwayName Enter the whole name of a specific pathway from getSGSEA result table with the quotation mark.
#' @param stats Log hazard ratios or log fold changes.
#' @import fgsea
#' @import ggplot2
#' @return An enrichment plot for a specific pathway
#' @export
#'

getEnrichPlot <- function(pathways,pathwayName,stats){

  return(fgsea::plotEnrichment(pathways[[pathwayName]],stats) +
           ggplot2::labs(title=pathwayName)
  )


}


