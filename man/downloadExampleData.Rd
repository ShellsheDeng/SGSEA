% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/downloadExampleData.R
\name{downloadExampleData}
\alias{downloadExampleData}
\title{Download Example Data for SGSEA}
\arguments{
\item{file_name}{A string specifying the file name to save the example dataset as (default: "KIRC_example.csv").}

\item{path}{A string specifying the directory where the file should be saved (default: current working directory).}
}
\value{
A message indicating where the file was saved.
}
\description{
This function allows users to download the example dataset ("KIRC")
provided with the SGSEA package. The dataset demonstrates the expected input format.
}
\examples{
\dontrun{
  SGSEA::downloadExampleData()
}
}
