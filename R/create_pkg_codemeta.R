
#' Create codemeta
#'
#' @param pkgs data frame with R packages (default: get_github_packages())
#' @param libpath libpath  (default: Sys.getenv("R_LIBS_USER"))
#' @param dbg should debug messages be printed? (default: TRUE)
#' @return codemetar object for R packages
#' @importFrom codemetar create_codemeta
#' @importFrom glue glue
#' @importFrom utils installed.packages
#' @export
create_pkg_codemeta <- function(
    pkgs = get_github_packages(),
    libpath = Sys.getenv("R_LIBS_USER"),
    dbg = TRUE
)
{
  run <- function(msg, expr) {
    cat_and_run(msg, expr, dbg = dbg, newLine = 3L)
  }

  # Get package names from input data frame
  packages <- select_columns(pkgs, "name")

  run("Creating codemeta object", {

    withr::with_libpaths(libpath, {

      package_db <- utils::installed.packages()

      is_installed <- packages %in% package_db[, "Package"]

      if (any(!is_installed)) {
        n <- sum(!is_installed)
        message(sprintf(
          "%d %s not installed in '%s': %s",
          n,
          ifelse(n > 1L, "packages are", "package is"),
          libpath,
          string_list(sort(packages[!is_installed]))
        ))
      }

      lapply(packages[is_installed], function(package) {
        run(
          sprintf("Writing codemeta for R package %s", package),
          try(codemetar::create_codemeta(file.path(libpath, package)))
        )
      })

    })

  })
}
