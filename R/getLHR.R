#' Generate a named numeric vector of the log hazard ratios from Cox Proportional Hazards Model
#' @description Return a numeric vector of log hazard ratios with corresponding gene symbols as their names. This function is calling coxph function from the survival package. Data should be filtered and normalized before entering this step.
#' @param normalizedData A data frame contains the normalized counts. Rows must be the sample IDs. Columns must be the unique gene symbols. See KIRC data included in this package as the input example format.
#' @param survTime A numeric vector of patient's survival times. User should be aware of matching the gene symbols from the normalized count data with each individual's survival times.
#' @param survStatus A numeric vector of patient's survival status. Normally 0=alive, 1=dead. Or 1=alive, 2=death. If omitted, all subjects are assumed to have an event. User should be aware of matching the gene symbols from the normalized count data with each individual's survival status.
#' @import survival
#' @return A named list of the log hazard ratios with their corresponding gene symbols.
#' @export


getLHR <- function (normalizedData, survTime, survStatus) {
  if(!(is.data.frame(normalizedData))) {
    stop('must be a data frame')
  }

  if(nrow(normalizedData) != length(survTime)) {
    stop('In count data, rows must be the sample IDs and columns must be the gene symbols')
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
