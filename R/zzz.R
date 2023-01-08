#' Prefix and suffix to be glued with `ons_id` to retrieve ONS boundaries
#'
#' @noRd
ons_url <- c(
    pfx = 'https://opendata.arcgis.com/api/v3/datasets/',
    sfx = '_0/downloads/data?format=shp&spatialRefId=27700&where=1%3D1'
)

#' Wrapper to retrieve ONS boundaries
#'
#' @noRd
down_ons <- \(id, yo, yn) Rgeo::dwn_shp_zip(paste0(ons_url['pfx'], id, ons_url['sfx']), yo, yn, out_path = './data-raw/shp/')
