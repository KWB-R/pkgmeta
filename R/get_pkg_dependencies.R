# get_pkg_dependencies ---------------------------------------------------------

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
  get_pkg_dependencies_impl(
    pkgs,
    recursive = FALSE,
    ...,
    library_path = library_path,
    dbg = dbg
  )
}

# get_recursive_pkg_dependencies -----------------------------------------------

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
    pkgs,
    library_path = .libPaths(),
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

# get_pkg_dependencies_impl ----------------------------------------------------
get_pkg_dependencies_impl <- function(
    pkgs,
    recursive,
    ...,
    library_path = .libPaths(),
    dbg = TRUE
)
{
  fun_name <- ifelse(
    recursive,
    "recursivePackageDependencies",
    "getPackageDependencies"
  )

  dependency_function <- utils::getFromNamespace(fun_name, "packrat")

  package_db <- installed.packages(lib.loc = library_path)
  pkgs_installed <- pkgs[pkgs %in% rownames(package_db)]

  pkgs_installed %>%
    lapply(function(pkg) {
      kwb.utils::catAndRun(
        sprintf(
          "Getting %s dependencies for '%s'",
          ifelse(recursive, "recursive", "non-recursive"),
          pkg
        ),
        dependency_function(pkg, lib.loc = library_path, ...),
        dbg = dbg
      )
    }) %>%
    stats::setNames(pkgs_installed)
}
