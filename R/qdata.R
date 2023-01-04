#' Extract Census data
#' 
#' Build a dataset for a specified Variable and either one Zone or (part of) a Geographic Hierarchy
#' (see the table `zone_types`), eventually adding a percentage vs a *reference* variable and/or upper level hierarchy
#' 
#' @param idv the id of a Variable (see the column `id` in the `vars` table)
#' @param zns the ONS code(s) of one or multiple *similar* Zone(s) (see the column `id` in the `zones` table).
#'            To check for the Zone code given its name use the function `qznames`.
#' @param tpz the acronym of a geographic hierarchy (see the column `type` in the `zone_types` table)
#' @param smz if `TRUE` and multiple Zones are requested, returns the aggregation instead of each Zones values
#' @param spz the ONS code of a Zone of an upper level geographic hierarchy to filter out results
#'            (use the `` function or 
#'             directly see the `lookups` table from left to right using the `level` column in the `zone_types` table)
#' @param pct if `TRUE`
#' @param rfv the *id* of a reference Variable (see the column `var_id` in the `vars_refs` table) 
#'            to create rates and/or indices
#' @param verbose if `TRUE` print all messages and warnings.
#'
#' @return a data.table
#'
#' @author Luca Valnegri, \email{l.valnegri@datamaps.co.uk}
#'
#' @import data.table
#'
qdata <- \(idv, zns = NULL, tpz = NULL, smz = FALSE, spz = NULL, pct = FALSE, rfv = NULL, verbose = FALSE){
    if(!idv %in% vars$id) 
        stop('
             The `idv` value is not a recognized id for a Variable! 
             See the column `id` in the `vars` table.
        ')
    if(is.null(zns) & is.null(tpz)){
        if(!tpz %in% zone_types$id)
            stop('
                The `idv` value is not a recognized id for a Variable! 
                See the column `id` in the `vars` table.
            ')
        if(verbose) warning('Using `tpz <- "LTLA"` as none of `cdz` or `tpz` have been provided')
            tpz <- 'LTLA'
        }
    if(is.null(zns)){
        if(!idv %in% vars$id) stop('The Variable id is not recognized!')
    } else {
        if(!idv %in% vars$id) stop('The Variable id is not recognized!')
      
    }

    y
}

# check if the var code exists
# check if the var and zone are compatible: level(var) <= level(zns)
# check: when id %in% metrics you can not sum or pct, but you can index vs sup
