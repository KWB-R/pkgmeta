#' Get GitHub rate limit
#'
#' @param github_token token passed to \link[gh]{gh}.
#'   Default: pkgmeta:::get_github_token()
#' @return overview of rate limit
#' @export
#' @importFrom dplyr bind_rows
#' @importFrom gh gh
#' @importFrom kwb.utils selectElements
#' @examples
#' get_gh_ratelimit()
get_gh_ratelimit <- function(github_token = get_github_token())
{
  "https://api.github.com/rate_limit" %>%
    gh::gh(.token = github_token) %>%
    select_elements("resources") %>%
    dplyr::bind_rows(.id = "id")
}
