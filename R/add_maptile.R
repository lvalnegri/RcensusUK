#' add_maptile
#' 
#' Add a background layer to a `leaflet` map
#'
#' @param m a `leaflet` object
#' @param x text or url description of the required maptile (see the list `tiles.lst`)
#' @param grp an optional group name for the layer
#'
#' @return A `leaflet` object
#'
#' @author Luca Valnegri, \email{l.valnegri@datamaps.co.uk}
#'
#' @importFrom leaflet addProviderTiles addTiles
#' 
#' @export
#'
add_maptile <- function(m, x, grp = NULL){
    switch(stringr::str_extract(x, 'google|memomaps|cycl|Karte'),
        'google' = m |> addTiles(
                            urlTemplate = x, 
                            attribution = 'Map data &copy; <a href="https://maps.google.com/">Google Maps</a>', 
                            options = tileOptions(subdomains = c('mt0', 'mt1', 'mt2', 'mt3'), useCache = TRUE, crossOrigin = TRUE),
                            group = grp
                ),
        'memomaps' = m |> addTiles(
                        urlTemplate = x, 
                        attribution = 'Map <a href="https://memomaps.de/">memomaps.de</a> <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, map data &copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>',
                        options = tileOptions(useCache = TRUE, crossOrigin = TRUE),
                        group = grp    
                ),
        'cycl' = m |> addTiles(
                        urlTemplate = x, # 'https://{s}.tile-cyclosm.openstreetmap.fr/cyclosm/{z}/{x}/{y}.png', 
                        attribution = '<a href="https://github.com/cyclosm/cyclosm-cartocss-style/releases" title="CyclOSM - Open Bicycle render">CyclOSM</a> | Map data: &copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>',
                        options = tileOptions(useCache = TRUE, crossOrigin = TRUE),
                        group = grp
                ),
        `NA` = m |> addProviderTiles(x, group = grp, options = providerTileOptions(useCache = TRUE, crossOrigin = TRUE))
    )
}
