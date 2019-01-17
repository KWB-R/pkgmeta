#' Helper function: download private repos from Github
#'
#' @description Source code: copied from "remotes"
#' https://github.com/r-lib/remotes/blob/bd970d723facc6ede2ff0f54ce4ae917526a37f8/install-github.R
#' (required for downloading private repos!)
#' @param repo Github repo (e.g. "kwb-r/kwb.utils")
#' @param ref default: "master"
#' @param dest_dir dest directory (default: tempdir())
#' @param use_zip should files be downloades as .tar.gz (use_zip=FALSE) or as
#' .zip files (use_zip=TRUE); default: FALSE
#' @param quiet print messages (default: TRUE)
#' @param auth_token auth_token (needed to download "private" repos), default:
#' getOption("github_token")
#' @return downloaded repo in dest. folder
#' @export
#' @import remotes
#' @importFrom stringr str_split
#'
download_github <- function(repo,
                            ref = "master",
                            dest_dir = tempdir(),
                            use_zip = FALSE,
                            quiet = FALSE,
                            auth_token = getOption("github_token")) {
  repo_sep <- as.vector(stringr::str_split(repo, pattern = "/|@", n = 3, simplify = TRUE))

  reference <- if (repo_sep[3] == "") {
    ref
  } else {
    repo_sep[3]
  }

  x <- list(
    username = repo_sep[1],
    repo = repo_sep[2],
    ref = reference,
    host = "api.github.com",
    auth_token = auth_token
  )

  # if(use_zip) {
  #
  #   file_ext <- ".zip"
  #   src_dir <- "/zipball/"
  # } else {
  #   file_ext <- ".tar.gz"
  #   src_dir <- "/tarball/"
  # }

  file_ext <- ifelse(use_zip, ".zip", ".tar.gz")
  src_dir <- ifelse(use_zip, "/zipball/", "/tarball/")


  dest <- file.path(dest_dir, paste0(x$repo, file_ext))

  if (!quiet) {
    message(
      "Downloading GitHub repo ", x$username, "/", x$repo, "@", x$ref,
      " to: ", dest
    )
  }


  src_root <- remotes:::build_url(x$host, "repos", x$username, x$repo)
  src <- paste0(src_root, src_dir, utils::URLencode(x$ref, reserved = TRUE))
  remotes:::download(dest, src, auth_token = x$auth_token)
}
