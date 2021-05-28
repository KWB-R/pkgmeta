
#' Get Github Versions for One Repo
#'
#' @param repo full name of Github repo ("owner/repo_name", e.g. "kwb-r/kwb.utils")
#' @param github_token default: Sys.getenv("GITHUB_PAT")
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
github_package_versions <- function(repo, github_token = Sys.getenv("GITHUB_PAT"))
{
  releases_url <- function(repo) sprintf(
    "https://api.github.com/repos/%s/releases", repo
  )

  releases <- gh::gh(endpoint = releases_url(repo),
                     per_page = 100,
                     .token = github_token)

  owner_repo <- as.character(stringr::str_split_fixed(repo, pattern = "/", n = 2))

  data.frame(
    owner = owner_repo[1],
    repo = owner_repo[2],
    tag = sapply(releases, kwb.utils::selectElements, "tag_name"),
    date = as.Date(sapply(releases, kwb.utils::selectElements, "published_at")),
    author_id = purrr::map_chr(purrr::map(releases, "author"), "login")
  )
}

#' Get Github Versions for Multiple Repos
#'
#' @param repos vector with full names of Github repos ("owner/repo_name",
#' e.g. c("kwb-r/kwb.utils", "kwb-r/kwb.ml", "kwb-r/aquanes.report"))
#' @param github_token default: Sys.getenv("GITHUB_PAT")
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
github_packages_versions <- function(repos, github_token = Sys.getenv("GITHUB_PAT"))
{
  pkg_version_list <- lapply(repos, function(repo) {
    kwb.utils::catAndRun(sprintf("Repo: %s", repo), expr = try(
      github_package_versions(repo, github_token = github_token)
    ))
  })

  has_release <- which(!sapply(seq_len(length(pkg_version_list)), function(i) {
    attr(pkg_version_list[[i]], "class") == "try-error"
  }))

  dplyr::bind_rows(pkg_version_list[has_release])
}
