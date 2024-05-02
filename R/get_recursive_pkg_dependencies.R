#' Get recursive package dependencies
#'
#' @param pkgs character vector with package names
#' @param library_path character vector with path(s) to R library (default: .libPaths())
#' @param dbg logical if debug should be shown (default: TRUE)
#' @param ... additional arguments passed to packrat:::getPackageDependencies()
#' @return list with recursive package dependencies
#' @importFrom stats setNames
#' @export
#' @examples
#' \dontrun{
#' pkgs <- pkgmeta::get_github_packages()
#' get_recursive_pkg_dependencies(pkgs$name)
#' }
#'
get_recursive_pkg_dependencies <- function(
    pkgs, library_path = .libPaths(),
    dbg = TRUE,
    ...
)
{
  get_pkg_dependencies_impl(
    pkgs,
    recursive = TRUE,
    ...,
    library_path = library_path,
    dbg = dbg
  )
}
