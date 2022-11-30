#' Properties of geographical hierarchies not issued with the Census.
#'
#' @noRd
ids <- data.table(
            type = c('PCON', 'WARD', 'PAR', 'CCG'),
            map_id = c('19841da5f8f6403e9fdcfb35c16e11e9', '72949ed55a424896934147d45f7771ea', 'd83cf58a661e4705b372b83e54bfc648', ''),
            ons = c('PCON', 'WD', 'PARNCP', 'CCG'),
            code = c('PCON20CD', 'WD21CD', 'PARNCP21CD', 'CCG'),
            name = c('PCON20NM', 'WD21NM', 'PARNCP21NM', 'CCGd'),
            lsoa = c(TRUE, FALSE, FALSE, TRUE),
            child = c('LSOA', 'OA', 'OA', 'LSOA'),
            parent = c('RGN', 'LTLA', 'UTLA', 'CTRY')
)

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

