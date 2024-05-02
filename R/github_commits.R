
#' Get Github Commits for One Repo
#'
#' @param repo full name of Github repo ("owner/repo_name", e.g. "kwb-r/kwb.utils")
#' @param github_token Default: pkgmeta:::get_github_token()
#'
#' @return data frame
#' @export
#' @importFrom gh gh
#' @importFrom kwb.utils selectElements
#' @importFrom lubridate as_datetime
#' @importFrom dplyr bind_rows arrange desc
#' @examples
#' \dontrun{
#' pkg_commits <- pkgmeta::get_github_commits("kwb-r/kwb.utils")
#' head(pkg_commits )
#'}
get_github_commits <- function(
    repo,
    github_token = get_github_token()
)
{
  get_commits <- function(repo, per_page = 100L) {

    n_results <- per_page
    page <- 1L
    commits_list <- list()

    while(n_results == per_page) {

      message(sprintf("Getting commits for repo %s (page = %d)", repo, page))

      commits_list[[page]] <- gh::gh(
        endpoint = sprintf(
          "GET /repos/%s/commits?page=%d&per_page=%d",
          repo,
          page,
          per_page
        ),
        .token = github_token
      )

      n_results <- length(commits_list[[page]])
      page <- page + 1L
    }

    do.call(what = c, args = commits_list)
  }

  commits <- get_commits(repo)

  commits_list <- lapply(seq_along(commits), function(commit_id) {

    sel_commit <- commits[[commit_id]]

    data.frame(
      repo = repo,
      sha = sel_commit$sha,
      author_login = ifelse(
        is.null(sel_commit$author$login),
        NA_character_,
        sel_commit$author$login
      ),
      author_name = sel_commit$commit$committer$name,
      author_email = sel_commit$commit$committer$email,
      datetime = lubridate::as_datetime(sel_commit$commit$author$date),
      message = sel_commit$commit$message
    )

  })

  dplyr::bind_rows(commits_list) %>%
    dplyr::arrange(dplyr::desc(.data$datetime))
}

#' Get Github Commits for Multiple Repos
#'
#' @param repos vector with full names of Github repos ("owner/repo_name",
#' e.g. c("kwb-r/kwb.utils", "kwb-r/kwb.ml", "kwb-r/aquanes.report"))
#' @param github_token Default: pkgmeta:::get_github_token()
#' @return data frame for all repos with releases
#' @export
#' @importFrom kwb.utils catAndRun multiSubstitute
#' @importFrom dplyr bind_rows if_else mutate
#' @importFrom tidyr separate
#' @examples
#' \dontrun{
#' #token <- Sys.getenv("GITHUB_PAT")
#' #repos <- kwb.pkgstatus::get_github_repos(github_token = token)
#' #repos <- repos$full_name
#' repos <- paste0("kwb-r/", c("aquanes.report", "kwb.ml", "kwb.utils"))
#' pkgs_commits <- pkgmeta::get_github_commits_repos(repos)
#' head(pkgs_commits)
#' }
get_github_commits_repos <- function(
    repos,
    github_token = get_github_token()
)
{
  pkg_commit_list <- lapply(repos, function(repo) {
    cat_and_run(
      sprintf("Repo: %s", repo),
      try(get_github_commits(repo, github_token = github_token))
    )
  })

  has_commit <- which(!sapply(pkg_commit_list, inherits, "try-error"))

  dplyr::bind_rows(pkg_commit_list[has_commit ]) %>%
    tidyr::separate("repo", c("owner", "repo"), sep = "/") %>%
    dplyr::mutate(
      author_login = dplyr::if_else(
        is.na(.data$author_login),
        .data$author_name,
        .data$author_login
      )
    ) %>%
    dplyr::mutate(
      author_login = multi_substitute(.data$author_login, list(
        "Andreas Matzinger" = "amatzi",
        "Hauke Sonnenberg" = "hsonne",
        "Mathias Riechel" = "mriech",
        "Roberto Tatis-Muvdi|RobertoTatisMuvdi" = "robetatis",
        "Michael Stapf" = "mstapf1",
        "Mathias Riechel" = "mriech",
        "Michael Rustler" = "mrustl",
        "praktikant20" = "klaaskenda",
        "Fabian Mor.*n Zirfas|ff6347" = "fabianmoronzirfas",
        "kwb.pkgbuild::use_autopkgdown\\(\\)|SarvaPulla|sarva|Sarva|jirikadlec2|Jeremy Fowler|rfun|jsadler2|rizts|testuser" = "external"
      ))
    ) %>%
    dplyr::filter(.data$author_login != "external")
}
