###########################################
# UK CENSUS 2021 * find missing's parents #
###########################################

library(data.table) 

message('Reading anci;;ary files...')
yk <- fread('./data-raw/csv/lookups.csv')
ym <- fread('./data-raw/csv/missing.csv')
ym[, c('OA', 'sibling', 'parent') := NULL][, `:=`( OA = NA_character_, sibling = NA_character_, parent = NA_character_ )]
yb <- qs::qread(file.path(Rfuns::bnduk_path, 's00', 'OA21gb'), nthreads = 6) |> setnames('OA21', 'OA') |> st_transform(27700)

# PAR
message('Processing <PAR>...')
ybm <- st_read('./data-raw/shp/PARNCP_DEC_2021_EW_BFC.shp') |> subset(PARNCP21CD %in% ym$zone_id)
yct <- st_intersects(ybm, yb)
for(x in 1:length(yct)){
    yx <- yct[[x]]
    yx <- yx[which.max(as.numeric(st_area(st_intersection(yb[yx,], ybm[x,]))))]
    moa <- yb[yx,] |> st_drop_geometry() |> as.character()
    ym[zone_id == ybm[x, 'PARNCP21CD'] |> st_drop_geometry(), `:=`( OA = moa, sibling = yk[OA == moa, PAR], parent = yk[OA == moa, get(ids[type == 'PAR', parent])]) ]
}

# WARD
message('Processing <WARD>...')
ybm <- st_read('./data-raw/shp/WD_DEC_2021_GB_BFC.shp') |> subset(WD21CD %in% ym$zone_id)
yct <- st_intersects(ybm, yb)
for(x in 1:length(yct)){
    yx <- yct[[x]]
    yx <- yx[which.max(as.numeric(st_area(st_intersection(yb[yx,], ybm[x,]))))]
    moa <- yb[yx,] |> st_drop_geometry() |> as.character()
    ym[zone_id == ybm[x, 'WD21CD'] |> st_drop_geometry(), `:=`( OA = moa, sibling = yk[OA == moa, WARD], parent = yk[OA == moa, get(ids[type == 'WARD', parent])]) ]
}

fwrite(ym, './data-raw/csv/missing.csv')

rm(list = ls())
gc()

# length = 1 >>> 215  565  919  981 1016
# x <-  1 # 37125, 37136, 135168, 135173
# leaflet() |> 
#     addTiles() |> 
#     addPolygons(data = ybm[x,] |> st_transform(4326), group = 'PAR', color = 'black', label = ~PARNCP21CD) |> 
#     addPolygons(data = yb[yct[[x]],] |> st_transform(4326), group = 'OA', color = 'red', label = ~OA) |> 
#     addLayersControl(overlayGroups = c('OA', 'PAR'))
