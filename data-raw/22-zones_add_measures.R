##########################################
# UK CENSUS 2021 * Add Measures to Zones #
##########################################

Rfuns::load_pkgs('data.table', 'sf')
load_all()

# calculate OAs for facebook population grid. Needs to be run only once to build the lookups
# fbx <- fst::read_fst(file.path(datauk_path, 'fb_gridpop', 'total'), columns = c('x_lon', 'y_lat', 'pop'), as.data.table = TRUE) |>
#             st_as_sf(coords = c('x_lon', 'y_lat'), crs = 4326) |>
#             st_transform(27700) |>
#             st_make_valid() |>
#             st_join(yb, join = st_within)
# fbx <- data.table( 
#             fbx |> st_drop_geometry(), 
#             fbx |> st_transform(4326) |> st_coordinates() |> st_drop_geometry() 
#         ) |> setnames(c('pop', 'OA', 'x_lon', 'y_lat'))
# fbx <- fbx[!is.na(OA)]
# setorder(fbx, 'OA')
# qs::qsave(fbx, './data-raw/qs/gridpop')

yk <- fread('./data-raw/csv/lookups.csv')
yt <- fread('./data-raw/csv/zone_types.csv', select = 'type')
fbx <- qs::qread('./data-raw/qs/gridpop')

y <- rbindlist(
        lapply(
            yt$type,
            \(x){
                message('Processing ', x)
                yb <- qs::qread(paste0('./data-raw/qs/', x, '.bfc'))
                ym <- data.table(
                        x,
                        yb |> st_drop_geometry(),
                        yb |> st_area() |> as.numeric(),
                        yb |> lwgeom::st_perimeter() |> as.numeric(),
                        yb |> st_centroid() |> st_transform(4326) |> st_coordinates() |> as.data.table() |> setnames(c('x_lon', 'y_lat')),
                        rbindlist( polylabelr::poi(yb) ) |> st_as_sf(coords = c('x', 'y'), crs = 27700) |> 
                            st_transform(4326) |> 
                            st_coordinates() |> 
                            st_drop_geometry() |> 
                            as.data.table()
                )
                yw <- yk[, .(OA, get(x))][fbx, on = 'OA'][, OA := NULL]
                yw <- yw[, .( weighted.mean(x_lon, pop), weighted.mean(y_lat, pop) ), V2] |> setnames(c(x, 'wx_lon', 'wy_lat'))
                yw[ym, on = x]
            }
        ), use.names = FALSE
)
setnames(y, c('id', 'wx_lon', 'wy_lat', 'type', 'area', 'perimeter', 'x_lon', 'y_lat', 'px_lon', 'py_lat'))
setcolorder(y, c('type', 'id', 'area', 'perimeter', 'x_lon', 'y_lat'))
yz <- fread('./data-raw/csv/zones.csv')
yz <- yz[y, on = c('type', 'id')]
setorderv(yz, c(c('type', 'id')))
save_dts_pkg(yz, 'zones', dbn = 'census_uk')

rm(list = ls())
gc()
