#' Get Github R Packages
#' @param group default: "KWB-R"
#' @param ignore_pkgs vector of pkg names that should be ignored to prevent
#' problems with codemeta generation (e.g. "kwb.read" fails due to missing
#' metadata on the license!)
#' @param non_r_packages vector with repos that are not R packages (default:
#' kwb.pkgstatus::get_non_r_packages())
#' @param github_token optionally a Github token in order to access private
#' repositories (default: Sys.getenv("GITHUB_PAT"))
#' @return data frame with R packages on Github
#' @export
#' @importFrom kwb.pkgstatus get_github_repos get_non_r_packages
#' @examples
#' \dontrun{
#' pkgs <- get_github_packages()
#' head(pkgs)
#' }
#'
get_github_packages <- function(group = "KWB-R",
                                ignore_pkgs = NULL,
                                non_r_packages = kwb.pkgstatus::get_non_r_packages(),
                                github_token = Sys.getenv("GITHUB_PAT")) {
  repos <- kwb.pkgstatus::get_github_repos(group, github_token)

  pkgs <- repos[!repos$name %in% non_r_packages, ]

  if (!is.null(ignore_pkgs)) {
    ignore_condition <- pkgs$name %in% ignore_pkgs
    if (any(ignore_condition)) {
      message(sprintf(
        "Ignoring R packages %s as requested!",
        paste(ignore_pkgs, collapse = ", ")
      ))
      pkgs <- pkgs[!ignore_condition, ]
    }
  }
  return(pkgs)
}
