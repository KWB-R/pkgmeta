% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/download_github.R
\name{download_github}
\alias{download_github}
\title{Helper function: download private repos from Github}
\usage{
download_github(
  repo,
  ref = "master",
  dest_dir = tempdir(),
  use_zip = FALSE,
  quiet = FALSE,
  auth_token = getOption("github_token")
)
}
\arguments{
\item{repo}{Github repo (e.g. "kwb-r/kwb.utils")}

\item{ref}{default: "master"}

\item{dest_dir}{dest directory (default: tempdir())}

\item{use_zip}{should files be downloades as .tar.gz (use_zip=FALSE) or as
.zip files (use_zip=TRUE); default: FALSE}

\item{quiet}{print messages (default: TRUE)}

\item{auth_token}{auth_token (needed to download "private" repos), default:
getOption("github_token")}
}
\value{
downloaded repo in dest. folder
}
\description{
Source code: copied from "remotes"
https://github.com/r-lib/remotes/blob/bd970d723facc6ede2ff0f54ce4ae917526a37f8/install-github.R
(required for downloading private repos!)
}
