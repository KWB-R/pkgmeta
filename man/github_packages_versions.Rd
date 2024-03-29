% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/github_package_versions.R
\name{github_packages_versions}
\alias{github_packages_versions}
\title{Get Github Versions for Multiple Repos}
\usage{
github_packages_versions(repos, github_token = Sys.getenv("GITHUB_PAT"))
}
\arguments{
\item{repos}{vector with full names of Github repos ("owner/repo_name",
e.g. c("kwb-r/kwb.utils", "kwb-r/kwb.ml", "kwb-r/aquanes.report"))}

\item{github_token}{default: Sys.getenv("GITHUB_PAT")}
}
\value{
data frame for all repos with releases
}
\description{
Get Github Versions for Multiple Repos
}
\examples{
\dontrun{
repos <- paste0("kwb-r/", c("aquanes.report", "kwb.ml", "kwb.utils")
pkgs_versions <- pkgmeta::github_packages_versions(repos)
head(pkgs_versions)
}
}
