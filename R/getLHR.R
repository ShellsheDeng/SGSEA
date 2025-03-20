#' Generate log hazard ratios from a Cox Proportional Hazards Model with optional covariates

#' @description Computes log hazard ratios (LHR) for each gene in the dataset by fitting separate Cox proportional hazards models.
#' Users can optionally include additional covariates (e.g., age, gender) in the models.
#' Data should be filtered and normalized before using this function.

#' @param normalizedData A data frame containing **normalized gene expression counts**.
#' Rows represent samples, and columns represent **genes (features)**.
#' @param survTime A numeric vector of patient survival times, **matching the rows in `normalizedData`**.
#' @param survStatus A numeric vector of patient survival status (e.g., 0 = alive, 1 = dead).
#' @param covariates An **optional** data frame of additional covariates (e.g., age, gender, treatment group).
#' Each row must match a sample in `normalizedData`, and each column represents a covariate.
#' @import survival
#' @return A **named numeric vector** of log hazard ratios (LHRs), where names are gene symbols.
#' Each LHR represents the effect size of a gene on survival, estimated from its own Cox model.
#' @export




getLHR <- function (normalizedData, survTime, survStatus, covariates = NULL) {
  # Input validation
  if(!(is.data.frame(normalizedData))) {
    stop('Error: normalizedData must be a data frame')
  }

  if(nrow(normalizedData) != length(survTime)) {
    stop("Error: Mismatch in dimensions.  Ensure survival vectors match the rows of 'normalizedData'.")
  }

  if (!is.null(covariates)) {
    if (!is.data.frame(covariates) || nrow(covariates) != nrow(normalizedData)) {
      stop("Error: 'covariates' must be a data frame with the same number of rows as 'normalizedData'.")
    }
  }


  # Ensure LHR vector is initialized correctly
  lhr <- rep(NA, ncol(normalizedData))  # Initialize with NA values

  # Assign gene names to LHR vector
  names(lhr) <- colnames(normalizedData)


  #for (i in 1:length(normalizedData)){
  #  m <- survival::coxph(Surv(survTime, survStatus) ~ normalizedData[,i] )
  #  mout<- summary(m)
  #  lhr[i]=mout$coefficients[1]
  #}

  # Iterate through each gene
  for (i in seq_along(colnames(normalizedData))) {

    # Construct the formula dynamically
    formula_str <- paste("Surv(survTime, survStatus) ~ GeneExpression")

    if (!is.null(covariates)) {
      covariate_names <- colnames(covariates)
      formula_str <- paste(formula_str, paste(covariate_names, collapse = " + "))
    }

    formula_obj <- as.formula(formula_str)

    # Ensure correct data structure
    data_model <- if (is.null(covariates)) {
      data.frame(GeneExpression = normalizedData[, i], survTime, survStatus)
    } else {
      data.frame(GeneExpression = normalizedData[, i], covariates, survTime, survStatus)
    }

    # Fit Cox model safely with tryCatch
    model <- tryCatch(
      {
        survival::coxph(formula_obj, data = data_model)
      },
      error = function(e) NULL  # Return NULL on failure instead of NA
    )

    # Extract log hazard ratio (LHR) if model is successful
    if (!is.null(model) && inherits(model, "coxph")) {
      summary_model <- summary(model)
      lhr[i] <- summary_model$coefficients[1, 1]  # Extract LHR
    }
  }



  return(lhr)
}
