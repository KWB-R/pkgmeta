#' Get Github R Packages
#' @param group default: "KWB-R"
#' @param github_token optionally a Github token in order to access private
#' repositories (default: NULL)
#' @return data frame with R packages on Github
#' @export
#' @importFrom kwb.pkgstatus get_github_repos get_non_r_packages
#' @examples
#' pkgs <- get_github_packages()
#' head(pkgs)
#'
get_github_packages <- function(group = "KWB-R", github_token = getOption("github_token")) {
  repos <- kwb.pkgstatus::get_github_repos(group, github_token)

  pkgs <- repos[!repos$name %in% c(kwb.pkgstatus::get_non_r_packages(), "pkgmeta"),]
  return(pkgs)
}

