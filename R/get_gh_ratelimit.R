#' Get GitHub rate limit
#'
#' @param github_token token passed to \link[gh]{gh} (default:
#' Sys.getenv("GITHUB_PAT")
#' @return overview of rate limit
#' @export
#' @importFrom dplyr bind_rows
#' @importFrom gh gh
#' @importFrom kwb.utils selectElements
#' @examples
#' get_gh_ratelimit()
get_gh_ratelimit <- function(github_token = Sys.getenv("GITHUB_PAT"))
{
  "https://api.github.com/rate_limit" %>%
    gh::gh(.token = github_token) %>%
    kwb.utils::selectElements("resources") %>%
    dplyr::bind_rows(.id = "id")
}
