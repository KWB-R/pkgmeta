#' Travis Package Install Script
#' @description Needs to be Run before rendering vignettes
#' @param pkgs datadframe with R packages as retrieved by
#' get_github_packages()
#' @return installs kwb-r packages
#' @export
travis_pkg_install_script <- function(pkgs = pkgmeta::get_github_packages()) {
  for (pkg in pkgs$name) {
    remotes::install_github(
      repo = sprintf("kwb-r/%s", pkg),
      dependencies = TRUE,
      upgrade = "always"
    )
  }
}
