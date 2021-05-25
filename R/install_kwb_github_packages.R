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

install_kwb_github_packages <- function(pkgs_kwb,
                                        dependencies = TRUE,
                                        quiet = TRUE,
                                        ...) {
  pkgs_kwb_github <- sprintf("KWB-R/%s", pkgs_kwb)


  sapply(
    pkgs_kwb_github,
    FUN = function(gh_repo) {
      message(sprintf("Installing R package: %s", gh_repo))
      try(remotes::install_github(repo = gh_repo,
                                  dependencies = dependencies,
                                  quiet = quiet,
                                  ...))
    }
  )
}
