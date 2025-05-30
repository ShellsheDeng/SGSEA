% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/SGSEA-package.R
\name{SGSEA}
\alias{SGSEA}
\title{SGSEA: Survival-based Gene Set Enrichment Analysis Package}
\description{
The SGSEA package provides functions to analyze the relationship between
transcriptomic variation and survival using gene set enrichment analysis.
}
\section{Main Functions}{

\itemize{
\item \code{getNorm()}: Normalizes input gene expression data.
\item \code{getLHR()}: Computes log hazard ratio (LHR).
\item \code{getLFC()}: Computes log fold change (LFC).
\item \code{getReactome()}: Retrieves Reactome pathways.
\item \code{getGO()}: Retrieves Gene Ontology (GO) terms.
\item \code{getSGSEA()}: Runs the SGSEA analysis.
\item \code{getEnrichPlot()}: Generates an enrichment plot for a pathway.
\item \code{getTOP10()}: Identifies the top 10 enriched and bottom 10 pathways.
\item \code{downloadExampleData()}: Downloads an example dataset.
}
}

\section{Example Script}{

To download and open the example script, run:
\preformatted{
script_path <- system.file("scripts", "SGSEA_example_script.R", package = "SGSEA")
file.copy(script_path, "SGSEA_example_script.R")
file.edit("SGSEA_example_script.R")
}
}

\keyword{package}
