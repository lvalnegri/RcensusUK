############################################
# UK CENSUS 2021 * Build CCG EW boundaries #
############################################

Rfuns::load_pkgs('data.table', 'qs', 'sf')
url_pfx <- 'https://opendata.arcgis.com/api/v3/datasets/'
url_sfx <- '_0/downloads/data?format=shp&spatialRefId=27700&where=1%3D1'

y <- rbind(
        Rgeo::dwn_shp_zip(
            paste0(url_pfx, '30f52c9ce2e04907af2b67ad65b64c3b', url_sfx),  # Last Update: Apr-22
            c('LOC22CD', 'LOC22NM'),
            c('CCG', 'CCGd')
        ),
        Rgeo::dwn_shp_zip(
            paste0(url_pfx, '0901ffca1ae54f3da58bb16e4d61355a', url_sfx),  # Last Update: Jul-22
            c('LHB22CD', 'LHB22NM'),
            c('CCG', 'CCGd')
        )
)
st_write(y, './data-raw/shp/CCG.shp')        
fwrite(as.data.table(y |> st_drop_geometry()), paste0('./data-raw/csv/CCG.csv'))
qsave(y, paste0('./data-raw/qs/CCG.ori'), nthreads = 12) 

rm(list = ls())
gc()
