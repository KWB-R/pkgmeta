opencpu <- pkgmeta::github_packages_versions("opencpu/opencpu-server") %>%
  dplyr::mutate(version = stringr::str_remove(tag, pattern = "v\\.?")) %>%
  dplyr::filter(stringr::str_detect(version, pattern = "-",negate = TRUE)) %>%
  dplyr::arrange(date)
shiny <- kwb.package:::archivedCranVersions("shiny") %>%
  dplyr::mutate(author_id = "rstudio",
                repo = "shiny",
                owner = "rstudio",
                tag = sprintf("v%s", .data$version))

valid_releases <- sapply(stringr::str_split(shiny$version, pattern = "\\."), length) == 3
releases_shiny <- shiny[valid_releases, ] %>%
  dplyr::arrange(date) %>%
  get_r_releases()
releases_opencpu <- pkgmeta::get_r_releases(opencpu)

plot_r_releases(r_releases = releases_opencpu, title = "OpenCPU Server")
plot_r_releases(r_releases = releases_shiny, title = "R Package 'shiny'")

