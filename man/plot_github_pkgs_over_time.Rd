% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plot_rpackages.R
\name{plot_github_pkgs_over_time}
\alias{plot_github_pkgs_over_time}
\title{Plot Github Packages Over Time}
\usage{
plot_github_pkgs_over_time(df_pkgs, last_update = Sys.time())
}
\arguments{
\item{df_pkgs}{data frame with pkgs as retrieved by
\code{\link{get_github_packages}}}

\item{last_update}{default: Sys.time()}
}
\value{
ggplot of temporal development of R packages on Github
}
\description{
Plot Github Packages Over Time
}
\examples{
\dontrun{
pkgs <- get_github_packages()
plot_github_pkgs_over_time(pkgs)}

}
