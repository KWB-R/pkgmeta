[![R-CMD-check](https://github.com/KWB-R/pkgmeta/workflows/R-CMD-check/badge.svg)](https://github.com/KWB-R/pkgmeta/actions?query=workflow%3AR-CMD-check)
[![pkgdown](https://github.com/KWB-R/pkgmeta/workflows/pkgdown/badge.svg)](https://github.com/KWB-R/pkgmeta/actions?query=workflow%3Apkgdown)
[![codecov](https://codecov.io/github/KWB-R/pkgmeta/branch/main/graphs/badge.svg)](https://codecov.io/github/KWB-R/pkgmeta)
[![Project Status](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![CRAN_Status_Badge](https://www.r-pkg.org/badges/version/pkgmeta)]()
[![R-Universe_Status_Badge](https://kwb-r.r-universe.dev/badges/pkgmeta)](https://kwb-r.r-universe.dev/)
[![DOI](https://zenodo.org/badge/doi/10.5281/zenodo.3604092.svg)](10.5281/zenodo.3604092)

# pkgmeta

R Package for meta-analysis of KWB-R packages on
Github. It is a wrapper to the R packages 'codemetar' and 'pkgnet' for
providing insights into the development of the R packages on Github.

## Installation

For details on how to install KWB-R packages checkout our [installation tutorial](https://kwb-r.github.io/kwb.pkgbuild/articles/install.html).

```r
### Optionally: specify GitHub Personal Access Token (GITHUB_PAT)
### See here why this might be important for you:
### https://kwb-r.github.io/kwb.pkgbuild/articles/install.html#set-your-github_pat

# Sys.setenv(GITHUB_PAT = "mysecret_access_token")

# Install package "remotes" from CRAN
if (! require("remotes")) {
  install.packages("remotes", repos = "https://cloud.r-project.org")
}

# Install KWB package 'pkgmeta' from GitHub
remotes::install_github("KWB-R/pkgmeta")
```

## Documentation

Release: [https://kwb-r.github.io/pkgmeta](https://kwb-r.github.io/pkgmeta)

Development: [https://kwb-r.github.io/pkgmeta/dev](https://kwb-r.github.io/pkgmeta/dev)
