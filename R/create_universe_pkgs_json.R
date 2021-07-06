#' Create Universe Packages JSON
#' @description Prepares a packages.json file required for R-universe for creating
#' our personal CRAN-like repository on R-universe
#' @inheritParams get_github_packages
#' @return JSON structure as required for packages.json
#' @references \url{https://ropensci.org/blog/2021/06/22/setup-runiverse/#the-packagesjson-registry-file}
#' @export
#' @importFrom kwb.pkgstatus get_github_repos get_non_r_packages
#' @importFrom dplyr select rename
#' @importFrom jsonlite toJSON
#' @examples
#' create_universe_pkgs_json()
#'
#'
create_universe_pkgs_json <- function(group = "KWB-R",
                                      ignore_pkgs = NULL,
                                      non_r_packages = kwb.pkgstatus::get_non_r_packages(),
                                      github_token = Sys.getenv("GITHUB_PAT")) {
    get_github_packages(group = group,
                        ignore_pkgs = ignore_pkgs,
                        non_r_packages = non_r_packages,
                        github_token = github_token) %>%
    dplyr::select(.data$name, .data$url) %>%
    dplyr::rename(package = .data$name) %>%
    jsonlite::toJSON(pretty = TRUE)
}
