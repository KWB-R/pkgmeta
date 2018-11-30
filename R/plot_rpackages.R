#' Plot Github Packages Over Time
#'
#' @param df_pkgs data frame with pkgs as retrieved with get_github_packages()
#' @param last_update default: Sys.time()
#' @return ggplot of temporal development of R packages on Github
#' @export
#' @importFrom lubridate as_datetime
#' @importFrom forcats fct_reorder
#' @importFrom glue glue
#' @import ggplot2
#' @importFrom dplyr mutate
#' @importFrom magrittr %>%
#' @examples
#'\dontrun{
#' pkgs <- get_github_packages()
#' plot_github_pkgs_over_time(pkgs)}
#'
plot_github_pkgs_over_time <- function(df_pkgs,
                                       last_update = Sys.time()) {

fakin_date_start <- lubridate::as_datetime("2017-05-01")

df_pkgs %>%
  dplyr::mutate(created_at = lubridate::as_datetime(.data$created_at),
                pushed_at = lubridate::as_datetime(.data$pushed_at)) %>%
  ggplot2::ggplot(ggplot2::aes(x = .data$created_at,
                 y = forcats::fct_reorder(.data$name, .data$created_at))) +
  ggplot2::geom_vline(xintercept = fakin_date_start,
                      size = 2, alpha = 0.5, col = "grey") +
  ggplot2::geom_segment(ggplot2::aes(yend = .data$name, xend = .data$pushed_at),
               size = 1.3,
               arrow = ggplot2::arrow(length = ggplot2::unit(0.1, "inches"))) +
  ggplot2::theme_bw() +
  ggplot2::labs(title = "Temporal development of KWB-R packages on Github",
                subtitle = glue::glue("Last update: {last_update}"),
                y = "Repository Name",
                x = "Date",
                caption = glue::glue("Start of the arrow is the first release on Github, while the end of the arrow
represents the lasted 'push' activity to the repository. The vertical grey line
stands for the start date ({fakin_date_start}) of the FAKIN project at KWB which
serves as a booster of this publishing process (last update: {last_update}"))
}


