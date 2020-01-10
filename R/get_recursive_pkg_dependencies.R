#' Get recursive package dependencies
#'
#' @param pkgs character vector with package names
#' @param library_path character vector with path(s) to R library (default: .libPaths())
#' @param dbg logical if debug should be shown (default: TRUE)
#'
#' @return list with recursive package dependencies
#' @export
#' @examples
#' \dontrun{
#' pkgs <- pkgmeta::get_github_packages()
#' get_recursive_pkg_dependencies(pkgs$name)
#' }
#'
get_recursive_pkg_dependencies <- function(pkgs, library_path = .libPaths(),
                                           dbg = TRUE) {


  pkgs_installed <- pkgs[pkgs %in% rownames(installed.packages(lib.loc = library_path))]

  setNames(lapply(pkgs_installed, function(pkg) {
    kwb.utils::catAndRun(sprintf("Getting recursive dependencies for '%s'", pkg),
                         expr = {
                           packrat:::recursivePackageDependencies(pkg,
                                                                  lib.loc = library_path)},
                         dbg = dbg)}),
    nm = pkgs_installed)

}
