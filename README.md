# Survaival-based Gene Set Enrichment Analysis
This R package currently contains 7 functions to perform the SGSEA and the typical case vs. control (or normal vs. tumor) GSEA ("getNorm","getLHR","getLFC","getReactome","getSGSEA","getEnrichPlot" and "getTOP10"). There is 1 data set named "KIRC" for users to know what the input data format should be. In addition, a corresponding SGSEA shiny app is included in this package by calling 'runExample()' to launch the app, so user can experiment the package with this interactive web page before reading through the potential lengthy function documentations.

Download this package from GitHub: 
1. install BiocManager and devtools
2. devtools::install_github('ShellsheDeng/SGSEA')
