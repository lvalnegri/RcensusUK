###############################
# UK CENSUS 2021 * LOCALITIES #
###############################

Rfuns::load_pkgs('data.table', 'sf')

tmpf <- tempfile()
tmpd <- tempdir()
download.file('https://www.arcgis.com/sharing/rest/content/items/8f8b561f256b40c3a6df71e400bb54f0/data', tmpf, quiet = TRUE)
fn <- grep('csv$', unzip(tmpf, list = TRUE)$Name, value = TRUE)
unzip(tmpf, fn, exdir = tmpd)
y <- fread(
        file.path(tmpd, fn), 
        select = c('place21cd', 'place21nm', 'placesort', 'descnm', 'lat', 'long'),
        col.names = c('LOC', 'LOCd', 'LOCo', 'tpe', 'y_lat', 'x_lon'),
        encoding = 'Latin-1'
) |> setcolorder(c('LOC', 'LOCd', 'LOCo', 'x_lon'))
unlink(tmpf)
unlink(tmpd)
y <- y[tpe == 'LOC'][, tpe := NULL]
yd <- y[LOC %in% y[,.N,LOC][N>1, LOC]] 
ynd <- yd[tolower(gsub("'| |-|\\.|/", '', LOCd)) == LOCo][, .SD[1], LOC]
y <- rbindlist(list( y[!LOC %chin% yd$LOC], ynd )) # still a few dups in coords but different ids

yb <- qread('./data-raw/qs/OA.bfc', nthreads = 6)
yo <- y |> 
        st_as_sf(coords = c('x_lon', 'y_lat'), crs = 4326) |> 
        st_transform(27700)|> 
        st_join(yb, join = st_within) |> 
        subset(!is.na(OA), select = c(LOC, OA)) |>
        st_drop_geometry() |> 
        as.data.table()
y <- y[yo, on = 'LOC'][order(LOCo)]

save_dts_pkg(y, 'localities', dbn = 'census_uk')

rm(list = ls())
gc()
