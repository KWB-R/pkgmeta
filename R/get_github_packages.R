#' Get Github R Packages
#' @param group default: "KWB-R"
#' @param ignore_pkgs vector of pkg names that should be ignored to prevent
#' problems with codemeta generation (e.g. "kwb.read" fails due to missing
#' metadata on the license!)
#' @param non_r_packages vector with repos that are not R packages (default:
#' kwb.pkgstatus::get_non_r_packages())
#' @param github_token optionally a Github token in order to access private
#'   repositories. Default: pkgmeta:::get_github_token()
#' @return data frame with R packages on Github
#' @export
#' @importFrom kwb.pkgstatus get_github_repos get_non_r_packages
#' @examples
#' \dontrun{
#' pkgs <- get_github_packages()
#' head(pkgs)
#' }
#'
get_github_packages <- function(
    group = "KWB-R",
    ignore_pkgs = NULL,
    non_r_packages = kwb.pkgstatus::get_non_r_packages(),
    github_token = get_github_token()
)
{
  repos <- kwb.pkgstatus::get_github_repos(group, github_token)

  pkgs <- repos[!repos$name %in% non_r_packages, ]

  if (is.null(ignore_pkgs)) {
    return(pkgs)
  }

  if (any(is_ignored <- pkgs$name %in% ignore_pkgs)) {

    message(sprintf(
      "Ignoring R packages %s as requested!",
      paste(ignore_pkgs, collapse = ", ")
    ))

    pkgs <- pkgs[!is_ignored, ]
  }

  pkgs
}
