#' extract_data
#' 
#' Build a dataset for specified variable and zone or (part of) a geographic hierachy,
#' eventually adding a percentage vs reference data and/or upper level hierarchy
#' 
#' @param x  the id of a variable
#' @param cd the code of a zone
#' @param tp the acronym of a geographic hierarchy
#'
#' @return a data.table
#'
#' @author Luca Valnegri, \email{l.valnegri@datamaps.co.uk}
#'
#' @import data.table
#' @import leaflet
#'
extract_data <- \(tp){
  
    if(length(tp) == 0) stop('Type not recognized!')

    y
}
