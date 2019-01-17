
#' Create codemeta
#'
#' @param pkgs data frame with R packages (default: get_github_packages())
#' @param libpath libpath  (default: "/home/travis/R/Library")
#' @param dbg should debug messages be printed? (default: TRUE)
#' @return codemetar object for R packages
#' @importFrom codemetar create_codemeta
#' @importFrom glue glue
#' @importFrom utils installed.packages
#' @export
create_pkg_codemeta <- function(pkgs = get_github_packages(),
                                libpath = "/home/travis/R/Library",
                                dbg = TRUE) {
  kwb.utils::catAndRun("Creating codemeta object",
    expr = {
      withr::with_libpaths(
        new = libpath,
        code = {
          lapply(
            pkgs$name,
            function(x) {
              if (x %in% utils::installed.packages()[, "Package"]) {
                print(glue::glue("Writing codemeta for R package {x}"))
                codemetar::create_codemeta(pkg = x)
              }
              else {
                message(sprintf("Package '%s' is not installed in
  %s", x, libpath))
              }
            }
          )
        }
      )
    },
    dbg = dbg
  )
}
