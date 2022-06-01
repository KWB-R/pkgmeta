[![R-CMD-check](https://github.com/KWB-R/pkgmeta/workflows/R-CMD-check/badge.svg)](https://github.com/KWB-R/pkgmeta/actions?query=workflow%3AR-CMD-check)
[![pkgdown](https://github.com/KWB-R/pkgmeta/workflows/pkgdown/badge.svg)](https://github.com/KWB-R/pkgmeta/actions?query=workflow%3Apkgdown)
[![codecov](https://codecov.io/github/KWB-R/pkgmeta/branch/main/graphs/badge.svg)](https://codecov.io/github/KWB-R/pkgmeta)
[![Project Status](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![CRAN_Status_Badge](https://www.r-pkg.org/badges/version/pkgmeta)]()
[![R-Universe_Status_Badge](https://kwb-r.r-universe.dev/badges/pkgmeta)](https://kwb-r.r-universe.dev/)
[![DOI](https://zenodo.org/badge/doi/10.5281/zenodo.3604092.svg)](10.5281/zenodo.3604092)

R Package for meta-analysis of KWB-R packages on
Github. It is a wrapper to the R packages 'codemetar' and 'pkgnet' for
providing insights into the development of the R packages on Github.

## Installation

For installing the latest release of this R package run the following code below:

```r
# Enable repository from kwb-r
options(repos = c(
  kwbr = 'https://kwb-r.r-universe.dev',
  CRAN = 'https://cloud.r-project.org'))
  
# Download and install pkgmeta in R
install.packages('pkgmeta')

# Browse the pkgmeta manual pages
help(package = 'pkgmeta')
```

## Usage 

Checkout the available [articles](articles/) on how to use this R package.
