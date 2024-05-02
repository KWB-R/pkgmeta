
#' Get Github Versions for One Repo
#'
#' @param repo full name of Github repo ("owner/repo_name", e.g. "kwb-r/kwb.utils")
#' @param github_token Default: pkgmeta:::get_github_token()
#'
#' @return data frame
#' @export
#' @importFrom gh gh
#' @importFrom stringr str_split_fixed
#' @importFrom kwb.utils selectElements
#' @importFrom purrr map_chr map
#' @examples
#' \dontrun{
#' pkg_versions <- pkgmeta::github_package_versions("kwb-r/kwb.utils")
#' head(pkg_versions)
#'}
github_package_versions <- function(
    repo,
    github_token = get_github_token()
)
{
  releases <- "https://api.github.com/repos/%s/releases" %>%
    sprintf(repo) %>%
    gh::gh(per_page = 100L, .token = github_token)

  owner_repo <- repo %>%
    stringr::str_split_fixed(pattern = "/", n = 2L) %>%
    as.character()

  data.frame(
    owner = owner_repo[1L],
    repo = owner_repo[2L],
    tag = sapply(releases, select_elements, "tag_name"),
    date = as.Date(sapply(releases, select_elements, "published_at")),
    author_id = purrr::map_chr(purrr::map(releases, "author"), "login")
  )
}

#' Get Github Versions for Multiple Repos
#'
#' @param repos vector with full names of Github repos ("owner/repo_name",
#' e.g. c("kwb-r/kwb.utils", "kwb-r/kwb.ml", "kwb-r/aquanes.report"))
#' @param github_token Default: pkgmeta:::get_github_token()
#' @return data frame for all repos with releases
#' @export
#' @importFrom kwb.utils catAndRun
#' @importFrom dplyr bind_rows
#' @examples
#' \dontrun{
#' repos <- paste0("kwb-r/", c("aquanes.report", "kwb.ml", "kwb.utils")
#' pkgs_versions <- pkgmeta::github_packages_versions(repos)
#' head(pkgs_versions)
#' }
github_packages_versions <- function(
    repos,
    github_token = pkgmeta:::get_github_token()
)
{
  versions <- lapply(repos, function(repo) {
    cat_and_run(
      sprintf("Repo: %s", repo),
      expr = try(
        github_package_versions(repo, github_token = github_token),
        silent = TRUE
      )
    )
  })

  has_release <- !sapply(versions, inherits, "try-error")

  dplyr::bind_rows(versions[has_release])
}
