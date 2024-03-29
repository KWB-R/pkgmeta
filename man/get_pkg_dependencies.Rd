% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_pkg_dependencies.R
\name{get_pkg_dependencies}
\alias{get_pkg_dependencies}
\title{Get package dependencies}
\usage{
get_pkg_dependencies(pkgs, library_path = .libPaths(), dbg = TRUE, ...)
}
\arguments{
\item{pkgs}{character vector with package names}

\item{library_path}{character vector with path(s) to R library (default: .libPaths())}

\item{dbg}{logical if debug should be shown (default: TRUE)}

\item{...}{additional arguments passed to packrat:::getPackageDependencies()}
}
\value{
list with package dependencies
}
\description{
Get package dependencies
}
\examples{
\dontrun{
pkgs <- pkgmeta::get_github_packages()
get_pkg_dependencies(pkgs$name)
}

}
