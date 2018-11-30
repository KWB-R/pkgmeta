#' Get Github R Packages
#' @param group default: "KWB-R"
#' @param github_token optionally a Github token in order to access private
#' repositories (default: getOption("github_token"))
#' @return data frame with R packages on Github
#' @export
#' @importFrom kwb.pkgstatus get_github_repos get_non_r_packages
#' @examples
#' \dontrun{
#' pkgs <- get_github_packages()
#' head(pkgs)}
#'
get_github_packages <- function(group = "KWB-R", github_token = getOption("github_token")) {
  repos <- kwb.pkgstatus::get_github_repos(group, github_token)

  pkgs <- repos[!repos$name %in% kwb.pkgstatus::get_non_r_packages(),]
  return(pkgs)
}

