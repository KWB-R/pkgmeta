
#secrets_csv <-"secrets.csv"
#secrets <- read.csv(secrets_csv, stringsAsFactors = FALSE)
pkgs <- get_github_packages()
# saveRDS(pkgs,file = "rpackages.RData")

pkgs <- readRDS("rpackages.RData")

installed_packages <- rownames(installed.packages())

pkglib <- "pkg-lib"
fs::dir_create(pkglib)


withr::with_libpaths(new = pkglib, remotes::install_github("UptakeOpenSource/pkgnet@d1e974de299d46e71b082e027a71b8b254edc9b2",
                                                           upgrade = "always"))
withr::with_libpaths(new = pkglib, install.packages("codemetar", repos = "https://cloud.r-project.org/"))
withr::with_libpaths(new = pkglib, install.packages("purrr", repos = "https://cloud.r-project.org/"))
###############################################################################
# 1) Get raw data
###############################################################################

# 1.1) Install KWB packages (with dependencies in on library)
# -> required for "pkgnet" reports


for(pkg in pkgs$name) {

withr::with_libpaths(new = pkglib,
                     code = remotes::install_github(repo = sprintf("kwb-r/%s",
                                                                      pkg),
                                                    dependencies = TRUE,
                                                    upgrade = "always",
                     auth_token =  secrets$github_token))
}


# 1.2) Download KWB packages as "source" (required for pkgnet "covr" and "codemetar")

pkgsource_dir <- "pkg-source"
pkgsource_zip_dir <- file.path(pkgsource_dir, "zip")
pkgsource_unzip_dir <- file.path(pkgsource_dir, "unzip")
fs::dir_create(path = c(pkgsource_zip_dir, pkgsource_unzip_dir))

for(pkg in pkgs$name) {
  download_github(repo = sprintf("kwb-r/%s", pkg),
                  dest_dir = pkgsource_zip_dir,
                  use_zip = TRUE,
                  auth_token = secrets$github_token)
}
zipfiles <- list.files(pkgsource_zip_dir,full.names = TRUE)

invisible(lapply(zipfiles, function(x) {
  message(glue::glue("Unzipping {x} to {pkgsource_unzip_dir}"))
  unzip(x, exdir = pkgsource_unzip_dir)}))
  #
  # pkgsource_url <- sprintf("https://github.com/KWB-R/%s/archive/master.zip",
  #                          pkg)
  # pkgs$name
  # path_zipfile <- file.path(pkgsource_zip_dir, paste0(pkg, ".zip"))
  # download.file(url = pkgsource_url, destfile = path_zipfile)
  # #source_file_md5 <- openssl::md5(source_file)

  # target_dir <- file.path(pkgsource_unzip_dir, pkg)
  #
  # unzip(zipfile = path_zipfile, exdir = target_dir)


# pkgsource_zipfiles <- list.files(path = pkgsource_zip_dir,
#                                  full.names = TRUE,
#                                  pattern = ".zip")
#
# sapply(pkgsource_zipfiles, function(x) {
#   openssl::md5(unzip(x, list=TRUE))}
#   )



pkgnet_dir <- "docs/pkgnet"
fs::dir_create(pkgnet_dir)

withr::with_libpaths(new = pkglib,
                     code = for(x in pkgs$name) {
   print(sprintf("Write report for R package: %s", x))
   pkg_src_unzipped <- dir(pkgsource_unzip_dir, pattern = x)
   if(length(pkg_src_unzipped) > 1) {
      stop(glue::glue("Multiple unzipped pkg sources found in {pkgsource_unzip_dir}:
                      {paste(pkg_src_unzipped, collapse = ', ')}.
                      Please delete the oldest one(s) manually"))
     #pkg_path <- file.path(pkgsource_unzip_dir, pkg_src_unzipped),
     #sapply(pkg_path, function(x) {max(fs::dir_info(pkg_path[x])$modification_time)})
    } else if(length(pkg_src_unzipped) == 0)  {
      stop(glue::glue("No unzipped pkg sources found in {pkgsource_unzip_dir}"))
    } else {
      try(pkgnet::CreatePackageReport(
         pkg_name = x,
         pkg_path = file.path(pkgsource_unzip_dir, pkg_src_unzipped),
         report_path = file.path(pkgnet_dir, paste0(x, ".html"))
        ))
  }})

# withr::with_libpaths(new = pkglib,
#                      devtools::install_github("ropensci/codemetar", build_vignettes = TRUE))

pkgs_codemetar <- withr::with_libpaths(new = pkglib,
              code =lapply(pkgs$name,codemetar::create_codemeta))

# codemetar:::write_json(pkgs_codemetar,"docs/pkgs_codemetar.json",
#                        useBytes = TRUE,
#                        pretty = TRUE,
#                        auto_unbox = TRUE)

jsonlite:::write_json(pkgs_codemetar,"docs/codemetar.json",
                       useBytes = TRUE,
                       pretty = TRUE,
                       auto_unbox = TRUE)

library(jsonld)
library(jsonlite)
library(magrittr)
library(codemetar)
library(purrr)
library(dplyr)
library(printr)
library(tibble)

frame <- system.file("schema/frame_schema.json", package="codemetar")

corpus <-
  jsonld::jsonld_frame("codemetar.json", frame) %>%
  jsonlite::fromJSON(simplifyVector = FALSE) %>%
  getElement("@graph")

## deal with nulls explicitly by starting with map
pkgs <- purrr::map(corpus, "name") %>%
  purrr::compact() %>%
  as.character()

# keep only those with package identifiers (names)
keep <- purrr::map_lgl(corpus, ~ length(.x$identifier) > 0)
corpus <- corpus[keep]

## now we can just do
all_pkgs <- purrr::map_chr(corpus, "name")
head(all_pkgs)

## 3 unique maintainers
purrr::map_chr(corpus, c("maintainer", "familyName")) %>%
  unique() %>%
  length()


## Mostly Hauke
purrr::map_chr(corpus, c("maintainer", "familyName")) %>%
  tibble::as_tibble() %>%
  dplyr::group_by(value) %>%
  dplyr::tally(sort=TRUE)

## number of co-authors ...
purrr::map_int(corpus, function(r) length(r$author)) %>%
  tibble::as_tibble() %>%
  dplyr::group_by(value) %>%
  dplyr::tally(sort=TRUE)

## Contributors isn't used as much...
purrr::map_int(corpus, function(r) length(r$contributor)) %>%
  tibble::as_tibble() %>%
  dplyr::group_by(value) %>%
  dplyr::tally(sort=TRUE)

purrr::map_int(corpus, function(r) length(r$softwareRequirements))  %>%
  tibble::as_tibble() %>%
  dplyr::group_by(value) %>%
  dplyr::tally(sort=TRUE)

corpus %>%
  map_df(function(x){
    ## single, unboxed dep
    if("name" %in% names(x$softwareRequirements))
      dep <- x$identifier
    else if("name" %in% names(x$softwareRequirements[[1]]))
      dep <- map_chr(x$softwareRequirements, "name")
    else { ## No requirementsß
      dep <- NA
    }

    tibble(identifier = x$identifier, dep = dep)
  }) %>%
  dplyr::mutate(identifier = gsub("/", "", identifier),
                dep = gsub("/", "", dep)) %>%
  dplyr::filter(!is.na(dep)) -> dep_df


#which dependencies are used most frequently?
dep_df %>%
  dplyr::group_by(dep) %>%
  dplyr::tally(sort = TRUE)

#Alternate approach using a frame instead of purrr functions for subsetting the
#Note that this gets all Depends and suggests (really all SoftwareApplication
#types mentioned)
dep_frame <- '{
  "@context": "https://raw.githubusercontent.com/codemeta/codemeta/master/codemeta.jsonld",
"@explicit": "true",
"name": {}
}'
jsonld_frame("docs/codemetar.json", dep_frame) %>%
  fromJSON() %>%
  getElement("@graph") %>%
  filter(type == "SoftwareApplication") %>%
  group_by(name) %>%
  tally(sort = TRUE)
