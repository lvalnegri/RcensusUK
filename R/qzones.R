#' Prepare an output table or boundaries
#' 
#' Returns a table or digital boundaries of one or more Zones, possibly adding the names
#' 
#' @param z the code(s) for the zone(s)
#' @param n if `TRUE` add the name(s) to the output
#' @param t if `TRUE` returns a `data.table`, if n is `TRUE`, or a vector, if `n` is `FALSE`. 
#'          Otherwise, if `t` is `FALSE`, the digital boundaries in `sf` format. 
#'          In the latter case, the hierarchy the codes belong to must be unique.
#' 
#' @author Luca Valnegri, \email{l.valnegri@datamaps.co.uk}
#'
#' @import data.table
#' @import sf
#' 
#' @noRd
ret_zones <- \(z, n = TRUE, t = TRUE){
    yz <- zones[id %in% z]
    if(nrow(yz) == 0) stop('The provided code(s) for the Zone(s) are not in the database.')
    if(t){
        if(n) return(zones[id %chin% z, .(id, name)])
        zones[id %chin% z, id]
    } else {
        if(length(yz) > 1) stop('The hierarchy must be unique when requesting for boundaries.')
        y <- get(yz) |> subset(get(yz) %in% z)
        if(n) return(y |> merge(zones[id %chin% z, .(id, name)] |> setnames(c(yz, 'name'))))
        y
    }
}


#' Query about one or multiple Geographic Zone(s) 
#' 
#' Extract the names of the provided zones or all the Zones included in the same parent Zone
#' 
#' Build a dataset or digital boundaries for one or more Zone(s) or (part of) a Geographic Hierarchy (see the table `zone_types`).
#' 
#' @param zns the ONS code(s) of one or more Zones of the same type, unless asking only for the names (see the column `id` in the `zones` table)
#' @param hrz the type of output:
#'            - `is.null(hrz)`: returns only the name(s) of the `zns` Zone(s), overriding all other options
#'            - `hrz == "N"`: returns the *neighbours* of all the provided `zns` Zones
#'            - `level(hrz) < level(zns)`: returns all the smaller `hrz` Zones included in `zns` 
#'            - `level(hrz) > level(zns)`: returns all the Zones of the same type of `zns` 
#'                                       included in all the bigger `hrz` Zone(s) that contains `zns`
#' @param nms if `TRUE`, includes also a column with the name of the Zone(s)
#' @param tbl if `TRUE` exports a `data.table`; otherwise, the correspondent digital boundaries in `sf` format
#'
#' @return a character vector, a `data.table`, or an `sf` polygons object, depending on the values provided for the arguments
#'
#' @author Luca Valnegri, \email{l.valnegri@datamaps.co.uk}
#'
#' @import data.table
#' 
#' @export
#' 
qzones <- \(zns, hrz = NULL, nms = FALSE, tbl = TRUE){
    if(!is.vector(zns)) stop('The zones ids must be provided as a character vector.')
    yz <- zones[id %in% zns]
    if(nrow(yz) == 0) stop('The provided code(s) for the Zone(s) are not in the database.')
    if(is.null(hrz)) return(ret_zones(zns, !zones[id == 'E00177686', type] == 'OA'))
    yzt <- unique(yz$type)
    if(length(yzt) > 1) 
        stop('The provided zones belong to different types: ', paste(sort(yzt), collapse = ', '))
    if(hrz == 'N'){
        y <- neighbours[idA %in% zns, -c('type')]
        if(!tbl) return(ret_zones(y[, idB], nms, FALSE))
        if(length(zns) == 1) return(ret_zones(y[, idB], nms))
        if(nms) return(
                    cbind(
                        ret_zones(y[, idA], T)[y[, .(id = idA)], on = 'id'], 
                        ret_zones(y[, idB], T)[y[, .(id = idB)], on = 'id']
                ) |> setnames(c('idA', 'nmA', 'idB', 'nmB')) |> as.data.table())
        return(y)
    }
    if(!hrz %in% zone_types$type) stop('The provided type for the output hierarchy is not in the database.')
    if(zone_types[type == hrz, level] > zone_types[type == yzt, level]){
        return(ret_zones(lookups[get(yzt) %in% zns, get(hrz)], nms, tbl))
    } else {
        y <- unique(lookups[get(yzt) %in% zns, get(hrz)])
        ret_zones(unique(lookups[get(hrz) %in% y, get(yzt)]), nms, tbl)
    }
}


#' Query about the codes attached to the name of a Geographic Zone 
#' 
#' Extract all the codes for the Zones that match the given pattern, and an optional hierarchy. 
#' If there is only one Zone, only its code is returned as a vector. 
#' Otherwise, the output is a data.table with matched names and correspondet codes and hierarchy type.
#' 
#' @param x a string representing a pattern for one or more potential Zone name(s) 
#' @param tpe a string indicating a hierarchy type to be filtered out (see the table `zone_types` for more details)
#' @param no_cases logical, override cases in `x` 
#' @param exact logical, search only for the provided string
#'
#' @return a string indicating a code if the result is a single zone, 
#' or a `data.table` with codes, names and geographic hierarchy type, if multiple zones have been found
#'
#' @author Luca Valnegri, \email{l.valnegri@datamaps.co.uk}
#'
#' @import data.table
#' 
#' @export
#' 
qznames <- \(x, tpe = NULL, no_cases = FALSE, exact = FALSE){
    if(exact) x <- paste0('^', x, '$')
    y <- zones[grepl(x, name, ignore.case = no_cases)][order(name)]
    if(!is.null(tpe)){
        if(nrow(zone_types[type == tpe]) == 0){
            warning('The provided type <', tpe, '> is not valid. See the table `zone_types`.')
        } else {
            y <- y[type == tpe]
        }
    }
    if(nrow(y) == 0) stop('No code has been found for the provided string.')
    if(nrow(y) == 1) return(y$id)
    y[, .(type, id, name)]
}
