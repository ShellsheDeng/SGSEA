# Survival-based Gene Set Enrichment Analysis (SGSEA)
This R package currently contains 9 functions to perform SGSEA and the standard case vs. control GSEA: getNorm, getLHR, getLFC, getReactome, getGO, getSGSEA, getEnrichPlot and getTOP10, downloadExampleData. There is 1 example data set included in the package and named "KIRC" for users to know what the input data format should be. In addition, users can use 'SGSEA::runExample()' to launch the corresponding SGSEA shiny app and experiment the package with this interactive web page before reading through the potential lengthy function documentations.

# Download and Open Example Script
To access the example script that demonstrates the full SGSEA workflow, run the following in R:

```r
script_path <- system.file("scripts", "SGSEA_example_script.R", package = "SGSEA")
file.copy(script_path, "SGSEA_example_script.R")
file.edit("SGSEA_example_script.R")  # Open it in RStudio

Download this package from GitHub: 
1. install BiocManager and devtools
2. devtools::install_github('ShellsheDeng/SGSEA')
