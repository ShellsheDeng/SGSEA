# **Survival-based Gene Set Enrichment Analysis (SGSEA)**

The **SGSEA** R package provides **nine functions** for conducting **Survival-based Gene Set Enrichment Analysis (SGSEA)** and **standard case vs. control GSEA**:

- `getNorm()`: Normalizes input gene expression data.
- `getLHR()`: Computes log hazard ratios (LHR).
- `getLFC()`: Computes log fold changes (LFC).
- `getReactome()`: Retrieves pathway annotations from Reactome.
- `getGO()`: Retrieves Gene Ontology (GO) terms.
- `getSGSEA()`: Runs SGSEA analysis.
- `getEnrichPlot()`: Generates an enrichment plot for a specific pathway.
- `getTop10()`: Identifies the top 10 enriched and bottom 10 pathways.
- `downloadExampleData()`: Provides example datasets for testing.
- `exportRankedGenes()`: Export Ranked Genes with Cox Hazard Ratios.

## **Example Dataset**
The package includes **two example dataset, "KIRC" and "KIRC_DEA"**, which helps users understand the required input format. The first one for conducting SGSEA and the second one for conducting regular GSEA.

## **Shiny App**
Users can run the **SGSEA Shiny app** for an **interactive analysis experience** before diving into detailed function documentation:
```r
SGSEA::runExample()
```

# Download and Open Example Script

```r
script_path <- system.file("scripts", "SGSEA_example_script.R", package = "SGSEA")
file.copy(script_path, "SGSEA_example_script.R")
file.edit("SGSEA_example_script.R")  # Open it in RStudio
```

# Installation, install SGSEA from GitHub: 
```r
install.packages("BiocManager")
install.packages("devtools")
devtools::install_github("ShellsheDeng/SGSEA")
```


## License

SGSEA is released under the **GNU General Public License v3 (GPLv3)**.  
- The **SGSEA R package** is licensed under GPLv3.  
- The **Shiny App** and all generated results fall under the same GPLv3 license.  

For more details, visit: [GNU GPLv3 License](https://www.gnu.org/licenses/gpl-3.0.html)

