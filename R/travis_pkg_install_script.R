#' Travis Package Install Script
#' @description Needs to be Run before rendering vignettes
#' @param pkgs dataframe with R packages as retrieved by
#' get_github_packages()
#' @return installs kwb-r packages
#' @export
travis_pkg_install_script <- function(pkgs = pkgmeta::get_github_packages()) {
  sapply(
    pkgs$full_name,
    FUN = function(pkg) {
      try(remotes::install_github(
        repo = pkg,
        dependencies = TRUE,
        upgrade = "always"
      ))
    }
  )
}
