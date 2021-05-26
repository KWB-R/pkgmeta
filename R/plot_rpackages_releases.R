#' Plot Github Package Releases Over Time
#'
#' @param pkgs_releases data frame with pkgs as retrieved by
#' \link{\code{github_packages_versions}}
#' @param last_update default: Sys.time()
#' @return ggplot of temporal development of R package releases on Github
#' @export
#' @importFrom lubridate as_datetime
#' @importFrom forcats fct_reorder
#' @importFrom glue glue
#' @import ggplot2
#' @importFrom dplyr mutate
#' @importFrom magrittr %>%
#' @examples
#' \dontrun{
#' pkgs <- get_github_packages()
#' pkgs_releases <- github_packages_versions(repos = pkgs$full_name)
#' plot_github_pkgs_releases(pkgs_releases)
#' }
#'
plot_github_pkgs_releases <- function(pkgs_releases,
                                      last_update = Sys.time()) {
  # fakin_date_start <- lubridate::as_date("2017-05-01")

  pkgs_releases %>%
    ggplot2::ggplot(ggplot2::aes(
      x = .data$date,
      y = forcats::fct_reorder(.data$repo, .data$date),
      col = .data$author_id
    )) +
    ggplot2::geom_point() +
    ggplot2::geom_line() +
    ggplot2::theme_bw() +
    ggplot2::labs(
      title = "KWB-R Package Releases on Github",
      subtitle = glue::glue("Last update: {last_update}"),
      y = "Repository Name",
      x = "Date"
    )
}
