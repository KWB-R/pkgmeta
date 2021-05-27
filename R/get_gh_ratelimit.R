#' Get GitHub rate limit
#'
#' @param github_token token passed to \link[gh]{gh} (default:
#' Sys.getenv("GITHUB_PAT")
#' @return overview of rate limit
#' @export
#' @importFrom gh gh
#' @importFrom  dplyr bind_rows
#' @examples
#' get_gh_ratelimit()
get_gh_ratelimit <- function(github_token = Sys.getenv("GITHUB_PAT")) {

  res <- gh::gh(endpoint = "https://api.github.com/rate_limit",
         .token = github_token)

  dplyr::bind_rows(res$resources,.id = "id")
}
