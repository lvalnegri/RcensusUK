#' tiles.lst
#' 
#' List of background tiles for `leaflet` maps
#'
#' @references [Leaflet-providers preview](https://leaflet-extras.github.io/leaflet-providers/preview/). 
#' 
#' To work correctly, needs to be paired with `add_maptile`.
#'
#' @export
#' 
tiles.lst <- list(
    # 01 - 10
    'Google Maps Standard' = 'https://{s}.google.com/vt/lyrs=m&x={x}&y={y}&z={z}&hl=it',
    'Google Maps Satellite' = 'https://{s}.google.com/vt/lyrs=s&x={x}&y={y}&z={z}&hl=it',
    'Google Maps Terreno' = 'https://{s}.google.com/vt/lyrs=p&x={x}&y={y}&z={z}&hl=it',
    'Google Maps Alternativo' = 'https://{s}.google.com/vt/lyrs=r&x={x}&y={y}&z={z}&hl=it',
    'Google Maps Solo Strade' = 'https://{s}.google.com/vt/lyrs=h&x={x}&y={y}&z={z}&hl=it',
    'OSM Mapnik' = 'OpenStreetMap.Mapnik',
    'OSM HOT' = 'OpenStreetMap.HOT',
    'OSM Topo' = 'OpenTopoMap',
    'OSM Cycle' = 'https://{s}.tile-cyclosm.openstreetmap.fr/cyclosm/{z}/{x}/{y}.png',
    'Stamen Toner' = 'Stamen.Toner',
    # 11 - 20
    'Stamen Toner Lite' = 'Stamen.TonerLite',
    'Stamen Toner Background' = 'Stamen.TonerBackground',
    'Stamen Terrain' = 'Stamen.Terrain',
    'Stamen Watercolor' = 'Stamen.Watercolor',
    'Esri Street' = 'Esri.WorldStreetMap',
    'Esri Topo' = 'Esri.WorldTopoMap',
    'Esri Imagery' = 'Esri.WorldImagery',
    'CartoDB Voyager' = 'CartoDB.Voyager',
    'CartoDB Positron' = 'CartoDB.Positron',
    'CartoDB Dark Matter' = 'CartoDB.DarkMatter',
    # 21 - ...
    'OPNVKarte' = 'https://tileserver.memomaps.de/tilegen/{z}/{x}/{y}.png',
    'Mtb' = 'MtbMap'
)
