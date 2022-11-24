#' Generate log hazard ratios from Cox Proportional Hazards Model
#' @description Return a list of log hazard ratios with corresponding gene symbols as their names. This function is calling coxph function from survival package.
#' @param normalizedData a data frame contains normalized counts. Columns should be the gene symbols and rows should be sample IDs.
#' Data should also be filtered before entering this step.
#' @param survTime a numeric vector of survival times. User should be aware of keeping the same order of gene symbols for survival times and the genes in normalizedData.
#' @param survStatus a numeric vector indicating events. Normally 0=alive, 1=dead. Or 1=alive, 2=death. If omitted, all subjects are assumed to have an event.
#' User should be aware of keeping the same order of gene symbols for survival status and the genes in normalizedData.
#' @import survival
#' @return a named list of log hazard ratios with corresponding gene symbols.
#' @export


getLHR <- function (normalizedData, survTime, survStatus) {
  if(!(is.data.frame(normalizedData))) {
    stop(paste0( normalizedData, 'must be a data frame'))
  }

  lhr<-c()
  for (i in 1:length(normalizedData)){
    m <- survival::coxph(Surv(survTime, survStatus) ~ normalizedData[,i] )
    mout<- summary(m)
    lhr[i]=mout$coefficients[1]
  }
    names(lhr)<- colnames(normalizedData)
    return(lhr)

}
