#' map_nonexact
#' 
#' Build a leaflet map for one of the four hierarchies that has no exact lin
#' 
#' @param tp the acronym of the area: one in `PCON`, `WARD`, `PAR`, `CCG`
#'
#' @return a leaflet map
#'
#' @author Luca Valnegri, \email{l.valnegri@datamaps.co.uk}
#'
#' @import data.table
#' @import leaflet
#'
map_nonexact <- \(tp){
  
    if(length(tp) == 0) stop('Type not recognized!')
  
    idx <- which(ids$type == tp)
    tp <- ids[idx, type]
    tc <- ids[idx, code]
    
    ybo <- st_read(list.files('./data-raw/shp/', paste0('^', ids[type == tp, ons], '.*\\.shp$'), full.names = TRUE), quiet = TRUE) |> 
              subset(substr(yb[[tp]], 1, 1),) |> 
              st_transform(4326) |> 
              ms_simplify(0.2)

    if(verbose) message(' - Reading other boundaries...')
    yb <- qread(paste0('./data-raw/qs/', tp))
    ybc <- qread(paste0('./data-raw/qs/', ids[idx, child]))
    ybp <- qread(paste0('./data-raw/qs/', ids[idx, parent]))
    
    if(verbose) message(' - Building map...')
    lblc <- paste('max child:', ids[idx, child])
    lblp <- paste('min parent:', ids[idx, parent])
    lblb <- paste(ids[idx, type], 'by OA')
    lblo <- paste(ids[idx, type], 'from ONS')
    y <- leaflet() |> 
          add_maptile(tiles.lst[[1]]) |> 
          addPolygons(
              data = yb,
              group = lblb,
              color = 'red',
              weight = 2,
              fillOpacity = 0
          ) |> 
          addPolygons(
              data = ybo,
              group = lblo,
              color = 'black',
              weight = 2,
              fillOpacity = 0
          ) |> 
          addPolygons(
              data = ybc,
              group = lblc,
              color = 'black',
              weight = 2,
              fillOpacity = 0
          ) |> 
          addPolygons(
              data = ybp,
              group = lblp,
              color = 'black',
              weight = 2,
              fillOpacity = 0
          )
    grps <- c(lblc, lblp, lblo, lblb)
    if(ids[idx, parent] != 'RGN'){
        ybr <- qread('./data-raw/qs/RGN')
        grps <- c('Regions', grps)
        addPolygons(
            data = ybr,
            group = 'Regions',
            color = 'black',
            weight = 2,
            dashArray = '3',
            fillOpacity = 0
        )
    }
    y <- y |> 
          addLayersControl(overlayGroups = grps) |> 
          hideGroup(c(lblc, lblp, 'Regions'))

    y
}
