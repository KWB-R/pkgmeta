#' Plot Commits GitHub
#'
#' @param repos_commits tibble as retrieved by
#'   \code{\link{get_github_commits_repos}}
#' @return ggplot of temporal development of commits for KWB-R on Github
#' @export
#' @importFrom dplyr count rename left_join
#' @importFrom forcats fct_reorder
#' @importFrom glue glue
#' @import ggplot2
#' @importFrom dplyr mutate
#' @importFrom magrittr %>%
#' @examples
#' \dontrun{
#' repos <- kwb.pkgstatus::get_github_repos(github_token = Sys.getenv("GITHUB_PAT")
#' repos_commits <- pkgmeta::github_commits_repos(repos$full_name)
#' pkgmeta::plot_commits_github(repos_commits)
#' }
#'
plot_commits_github <- function(repos_commits)
{
  n_commits <- repos_commits %>%
    dplyr::count(.data$author_login) %>%
    dplyr::rename(n_commits = .data$n)

  repos_commits %>%
    dplyr::left_join(n_commits, by = "author_login") %>%
    dplyr::mutate(
      user = sprintf("%s (n = %d)", .data$author_login, .data$n_commits)
    ) %>%
    ggplot2::ggplot(ggplot2::aes(
      x = as.Date(.data$datetime) ,
      y = forcats::fct_reorder(.data$repo, .data$datetime),
      col = .data$user,
      label = .data$message
    )) +
    ggplot2::geom_point() +
    # ggplot2::geom_line() +
    ggplot2::theme_bw() +
    ggplot2::labs(
      title = "Use of Version Control System 'Git' on KWB-R 'GitHub'",
      #  subtitle = glue::glue("Last update: {last_update}"),
      y = "Repo",
      x = "Date"
    )
}
