#' Clean a postcode unit
#' 
#' Returns a correct standard 7-chars form for a UK postcode unit
#' 
#' @param x a string possibly representing a UK postcode unit
#' 
#' @return a 7-chars string
#' 
#' @author Luca Valnegri, \email{l.valnegri@datamaps.co.uk}
#'
#' @noRd
clean_pcu <- \(x){
  errc <- FALSE
  myw <- \(z) { message('Error! ', z); errc <<- TRUE }
  x <- toupper(gsub('[[:punct:]| ]', '', x))
  if(!grepl('[[:digit:]][[:alpha:]][[:alpha:]]$', x)) myw('The resulting inward code is not in correct form.')
  if(grepl('^[0-9]', x))  myw('A postcode unit can not start with a number.')
  if(nchar(x) < 5) myw('The provided string is too short for a correct postcode unit.')
  if(nchar(x) > 7) myw('The provided string is too long for a correct postcode unit.')
  if(errc) return(invisible(NULL))
  if(nchar(x) == 5) x <- paste0(substr(x, 1, 2), '  ', substring(x, 3))
  if(nchar(x) == 6) x <- paste0(substr(x, 1, 3), ' ', substring(x, 4))
  x
}

#' Query about a Postcode Unit 
#' 
#' Extract the Output Area that contains a Postcode Unit, or all the Zones included in a parent Zone
#' 
#' Build a dataset or digital boundaries for one or more Zone(s) or (part of) a Geographic Hierarchy (see the table `zone_types`).
#' 
#' @param pcu a string possibly representing a UK postcode unit
#' @param ... The remaining options for the `qzones` function
#'
#' @return a character vector, a `data.table` or an `sf` polygons object, depending on the values provided for the arguments in `...`
#'
#' @author Luca Valnegri, \email{l.valnegri@datamaps.co.uk}
#'
#' @import data.table
#'
qpcu <- \(pcu, ...){
    pcu <- clean_pcu(pcu[1])
    if(is.null(pcu)) return(invisible())
    # if(is.na(...)) return(qzones(postcodes[postcode %chin% pcu, OA]))
    qzones(postcodes[postcode %chin% pcu, OA], ...)
}
