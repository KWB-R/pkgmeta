### How to build an R package from scratch


author <- list(name = "Michael Rustler",
               orcid = "0000-0003-0647-7726",
               url = "http://mrustl.de")

pkg <- list(name = "pkgmeta",
            title = "R Package for meta-analysis of KWB-R packages on Github",
            desc  = paste("R Package for meta-analysis of KWB-R packages on Github.",
"It is a wrapper to the R packages 'codemetar' and 'pkgnet' for providing insights",
"into the development of the R packages on Github"))

usethis::create_package(path = file.path("..", pkg$name))
fs::file_delete(path = "DESCRIPTION")

kwb.pkgbuild::use_pkg(author,
                     pkg,
                     version = "0.1.0.9000",
                     stage = "experimental")


pkg_dependencies <- c('codemetar', 'lubridate', 'kwb.pkgstatus', 'stringr', 'withr', 'scales', 'purrr', 'fs', 'ggplot2', 'glue')

sapply(pkg_dependencies, usethis::use_package)

usethis::use_vignette("Package Dependencies")
usethis::use_vignette("Codemetar Analysis")
usethis::use_vignette("Visualisation")
