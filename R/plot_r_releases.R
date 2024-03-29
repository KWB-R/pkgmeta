
#' Get R Releases
#' @param releases R releases as retrieved by \link[rversions]{r_versions},
#' (default: rversions::r_versions(dots = TRUE))
#' @return data frame with R releases
#' @export
#' @importFrom rversions r_versions
#' @importFrom dplyr lag
#' @examples
#' releases <- get_r_releases()
#' head(releases)
get_r_releases <- function(releases = rversions::r_versions(dots = TRUE)) {
  releases %>%
  tidyr::separate(col = "version",
                  into = c("major", "minor", "patch"),
                  sep = "\\.",
                  remove = FALSE) %>%
  dplyr::mutate(patch = dplyr::if_else(is.na(.data$patch), 0L, as.integer(.data$patch)),
                major = as.integer(.data$major),
                minor = as.integer(.data$minor),
                diff.major = .data$major - dplyr::lag(.data$major, n = 1L),
                diff.minor = .data$minor - dplyr::lag(.data$minor, n = 1L),
                diff.patch = .data$patch - dplyr::lag(.data$patch, n = 1L),
                release_type = dplyr::if_else(.data$diff.major > 0,
                                         "Major",
                                         dplyr::if_else(.data$diff.minor > 0,
                                                        "Minor",
                                                        dplyr::if_else(.data$diff.patch > 0,
                                                                       "Patch",
                                                                       "Initial")))) %>%
  dplyr::mutate(release_type = dplyr::if_else(is.na(.data$release_type),
                                              "Initial",
                                              .data$release_type),
                label = sprintf("v%s (%s): %s",
                                .data$version,
                                .data$date,
                                .data$release_type))

}

#' Plot R Releases
#'
#' @param r_releases as retrieved by \link{get_r_releases}, (default: get_r_releases())
#' @param title title (default: "R Releases")
#' @return plotly with R releases
#' @importFrom ggplot2 aes aes_string geom_point theme_bw ggplot
#' @importFrom plotly ggplotly
#' @export
#' @examples
#' \dontrun{
#' plot_r_releases()
#' }
plot_r_releases <- function(r_releases = get_r_releases(),
                            title = "R Releases") {

g <- r_releases %>%
ggplot2::ggplot(ggplot2::aes_string(x = "date",
                                    y = "major",
                                    col = "release_type",
                                    label = "label")) +
ggplot2::geom_point(ggplot2::aes(alpha = 0.5)) +
ggplot2::theme_bw() +
ggplot2::scale_y_discrete() +
ggplot2::labs(title = title,
              x = "Date",
              y = "Major Release Version",
              color = "Type",
              alpha = "")

plotly::ggplotly(g, tooltip = "label")
}
