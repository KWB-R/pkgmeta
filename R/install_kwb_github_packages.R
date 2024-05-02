#' Install KWB Github Packages
#'
#' @param pkgs_kwb vector with R packages to be installed
#' @param dependencies dependencies (default: TRUE)
#' @param quiet (default: TRUE)
#' @param ... additional arguments passed to \link[remotes]{install_github}
#'
#' @return install R packages
#' @export
#' @importFrom remotes install_github

install_kwb_github_packages <- function(
    pkgs_kwb,
    dependencies = TRUE,
    quiet = TRUE,
    ...
)
{
  sapply(paste0("KWB-R/", pkgs_kwb), function(repo) {
    message("Installing R package: ", repo)
    try(remotes::install_github(
      repo = repo,
      dependencies = dependencies,
      quiet = quiet,
      ...
    ))
  })

}
