
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
  cat_and_run <- function(msg, expr) {
    kwb.utils::catAndRun(msg, expr, dbg = dbg)
  }

  packages <- kwb.utils::selectColumns(pkgs, "name")

  cat_and_run("Creating codemeta object", {

    withr::with_libpaths(libpath, {

      package_db <- utils::installed.packages()

      lapply(packages, function(package) {

        if (!package %in% package_db[, "Package"]) {
          message(sprintf(
            "Package '%s' is not installed in %s",
            package, libpath
          ))
          return()
        }

        cat_and_run(
          sprintf("Writing codemeta for R package %s\n", package),
          codemetar::create_codemeta(package)
        )

      })

    })

  })
}
