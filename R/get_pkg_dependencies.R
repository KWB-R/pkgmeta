#' Get package dependencies
#'
#' @param pkgs character vector with package names
#' @param library_path character vector with path(s) to R library (default: .libPaths())
#' @param dbg logical if debug should be shown (default: TRUE)
#' @param ... additional arguments passed to packrat:::getPackageDependencies()
#' @return list with package dependencies
#' @importFrom stats setNames
#' @export
#' @examples
#' \dontrun{
#' pkgs <- pkgmeta::get_github_packages()
#' get_pkg_dependencies(pkgs$name)
#' }
#'
get_pkg_dependencies <- function(
    pkgs,
    library_path = .libPaths(),
    dbg = TRUE,
    ...
)
{
  package_db <- installed.packages(lib.loc = library_path)
  pkgs_installed <- pkgs[pkgs %in% rownames(package_db)]

  pkgs_installed %>%
    lapply(function(pkg) {
      kwb.utils::catAndRun(
        sprintf("Getting recursive dependencies for '%s'", pkg),
        packrat:::getPackageDependencies(pkg, lib.loc = library_path, ...),
        dbg = dbg
      )
    }) %>%
    stats::setNames(pkgs_installed)
}
