#' Helper function: Get Github Topics
#' @param full_names vector with full_names to Github repo e.g.
#' c("kwb-r/kwb.utils", "kwb-r/kwb.base"), default: get_github_full_names()
#' @export
#' @importFrom gh gh
#' @importFrom tibble tibble
#' @importFrom dplyr bind_rows
#'
get_github_topics <- function(full_names = get_github_full_names())
{
  repos <- lapply(full_names, function(full_name) {

    topics <- try(silent = TRUE, gh::gh(
      endpoint = "GET /repos/:full_name/topics",
      full_name = full_name,
      .send_headers = c(Accept = "application/vnd.github.mercy-preview+json")
    ))

    na_entry <- tibble::tibble(
      full_name = full_name,
      topics = NA_character_
    )

    if (inherits(topics, "try-error")) {
      return(na_entry)
    }

    topics_vector <- unlist(topics$names)

    if (length(topics_vector) == 0L) {
      return(na_entry)
    }

    tibble::tibble(
      full_name = full_name,
      topics = topics_vector
    )

  })

  dplyr::bind_rows(repos)
}

#' @keywords internal
#' @noRd
#'
get_github_full_names <- function(github_repos = get_github_repos())
{
  vapply(github_repos, "[[", "", "full_name")
}

#' Helper function: Get Github Metadata For Repos
#'
#' @param group organisation (default: "KWB-R")
#' @param github_token Default: pkgmeta:::get_github_token()
#' @param dbg should debug messages be printed? (default: TRUE)
#' @param ... additional arguments passed to gh:::gh_build_request(), see
#' https://developer.github.com/v3/ (e.g. type = "public")
#' @importFrom gh gh
#' @export
get_github_repos <- function (
    group = "KWB-R",
    github_token = get_github_token(),
    dbg = TRUE,
    ...
)
{
  cat_and_run(
    messageText = sprintf(
      "\nFetching Github metadata for repos of organisation '%s' at '%s'",
      group,
      sprintf("https://github.com/%s/", group)
    ),
    dbg = dbg,
    expr = gh::gh(
      endpoint = sprintf("GET /orgs/%s/repos?per_page=100", group),
      .token = github_token,
      ...
    )
  )
}

#' Write Github Metadata to JSON
#'
#' @param github_repos  as retrieved by get_github_repos(), default:
#' get_github_repos()
#' @param file path where to save github.json (default: file.path(getwd(),
#' "github.json"))
#' @param dbg should debug messages be printed? (default: TRUE)
#' @return writes "github.json"
#' @importFrom jsonlite toJSON write_json
#' @importFrom kwb.utils catAndRun
#' @export
write_github_repos_json <- function(
    github_repos = get_github_repos(),
    file = file.path(getwd(), "github.json"),
    dbg = TRUE
)
{
  fetch_sorted <- function(what) {
    sort(vapply(github_repos, "[[", "", what))
  }

  repo_html_url <- fetch_sorted(what = "html_url")
  repo_names <- fetch_sorted(what = "name")

  cat_and_run(
    sprintf(
      "Writting '%s' file for %d repos:\n%s",
      file,
      length(repo_names),
      paste0("- ", repo_names, ": ", repo_html_url, collapse = "\n")
    ),
    expr = jsonlite::write_json(github_repos, file),
    dbg = dbg
  )
}
