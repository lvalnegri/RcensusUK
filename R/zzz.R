#' Prefix and suffix to be glued with `ons_id` to retrieve ONS boundaries
#'
#' @noRd
ons_url <- c(
    pfx = 'https://opendata.arcgis.com/api/v3/datasets/',
    sfx = '_0/downloads/data?format=shp&spatialRefId=27700&where=1%3D1'
)

#' Properties of geographical hierarchies not issued with the Census.
#'
#' @noRd
ids <- data.table(
            type = c('PCON', 'WARD', 'PAR', 'CCG'),
            map_id = c('2a914dfe294c48048e836019ad93e750', '1ae248c780474cad8fbd28539b806428', '50ab3787782c44c79c4a71c2f259da13', ''),
            ons = c('PCON', 'WD', 'PARNCP', 'CCG'),
            code = c('PCON21CD', 'WD22CD', 'PARNCP22CD', 'CCG'),
            name = c('PCON21NM', 'WD22NM', 'PARNCP22NM', 'CCGd'),
            lsoa = c(TRUE, FALSE, FALSE, TRUE),
            child = c('LSOA', 'OA', 'OA', 'LSOA'),
            parent = c('RGN', 'LTLA', 'UTLA', 'CTRY')
)

#' Wrapper to retrieve ONS boundaries
#'
#' @noRd
down_ons <- \(id, yo, yn) Rgeo::dwn_shp_zip(paste0(ons_url['pfx'], id, ons_url['sfx']), yo, yn, out_path = './data-raw/shp/')


# .onAttach <- function(libname, pkgname) {
#     packageStartupMessage(
#     )
# }

# .onLoad <- function(libname, pkgname) {
#     oop <- options()
#     opts <- list(
#             pkgname.optname = " option value goes here "
#     )
#     toset <- !(names(opts) %in% names(oop))
#     if(any(toset)) options(opts[toset])
#   
#     invisible()
# }

# .onUnload <- function(libname, pkgname) {
#
# }

