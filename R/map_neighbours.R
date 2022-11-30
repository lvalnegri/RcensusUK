#' map_neighbours
#' 
#' Build a leaflet map with an area with its neighbours
#' 
#' @param x  the ONS code of an area
#' @param tp the correct type of the requested area, in case the code `x` refers to multiple types
#'
#' @return a leaflet map
#'
#' @author Luca Valnegri, \email{l.valnegri@datamaps.co.uk}
#'
#' @import data.table
#' @import leaflet
#'
map_neighbours <- \(x, mt = 1){
    if(is.na(as.numeric(mt))) stop('`mt` must be a positive integer up to ', length(tiles.lst), '.')
    mt <- abs(as.integer(mt))
    if(mt > length(tiles.lst)) stop('`mt` is too high. There are only ', length(tiles.lst), ' available.')
    y <- neighbours[idA == x, .(type, idB)]
    if(nrow(y) == 0) stop('There is no area with code ', x, '!')
    tp <- unique(y$type)
    y <- y$idB
    yb <- get(tp) |> 
              subset(get(tp) %in% c(x, y)) |> 
              merge(locations[, .(code, name)], by.x = tp, by.y = 'code')
    leaflet() |> 
        add_maptile(tiles.lst[[mt]]) |> 
        addPolygons(
            data = yb |> subset(get(tp) == x),
            color = 'red',
            label = ~paste(get(tp), name)
        ) |> 
        addPolygons(
            data = yb |> subset(get(tp) %in% y),
            color = 'black',
            label = ~paste(get(tp), name)
        )
}
