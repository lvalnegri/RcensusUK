####################################################
# UK CENSUS 2021 * download Census hierarchy stuff #
####################################################

library(data.table)
load_all()

# OA boundaries
y <- Rgeo::dwn_shp_zip(paste0(ons_url['pfx'], '23b797b082504e77a6bdf781e8da9766', ons_url['sfx']), 'OA21CD', 'OA', out_path = './data-raw/shp/')
qs::qsave(y, './data-raw/qs/OA.bfc')
y <- Rgeo::dwn_shp_zip(paste0(ons_url['pfx'], '6c6743e1e4b444f6afcab9d9588f5d8f', ons_url['sfx']), 'OA21CD', 'OA', out_path = './data-raw/shp/')
qs::qsave(y, './data-raw/qs/OA.bgc')
y <- y |> rmapshaper::ms_simplify(0.5, keep_shapes = TRUE, sys = TRUE, sys_mem = 32) |> sf::st_transform(4326) |> sf::st_make_valid()
qs::qsave(y, './data-raw/qs/OA')

# LSOA & MSOA boundaries
y <- Rgeo::dwn_shp_zip(paste0(ons_url['pfx'], 'bd30d8dcb84a4c32a763fc2d916a52bb', ons_url['sfx']), 'LSOA21CD', 'LSOA', out_path = './data-raw/shp/')
y <- Rgeo::dwn_shp_zip(paste0(ons_url['pfx'], 'e45be904852d428d963abb33ed6ddbea', ons_url['sfx']), 'MSOA21CD', 'MSOA', out_path = './data-raw/shp/')

yo <- fread('https://www.arcgis.com/sharing/rest/content/items/792f7ab3a99d403ca02cc9ca1cf8af02/data')
yu <- fread('https://opendata.arcgis.com/api/v3/datasets/7207b51700f7472e88460f3a2e1eb5f9_0/downloads/data?format=csv&spatialRefId=4326&where=1%3D1')

# lookups & locations
lkp <- yo[, .(OA = oa21cd, LSOA = lsoa21cd, MSOA = msoa21cd)][yu[, .(OA = OA21CD, LTLA = LTLA22CD, UTLA = UTLA22CD, RGN = RGN22CD, CTRY = CTRY22CD)], on = 'OA']
lca <- rbindlist(list(
    yo[, .(type = 'OA', id = oa21cd, name = oa21cd)][lkp[, .(OA, parent = LSOA, country = substr(OA, 1, 1))], on = c(id = 'OA')],
    unique(yo[, .('LSOA', id = lsoa21cd, lsoa21nm)])[unique(lkp[, .(LSOA, MSOA, substr(LSOA, 1, 1))]), on = c(id = 'LSOA')],
    unique(yo[, .('MSOA', id = msoa21cd, msoa21nm)])[unique(lkp[, .(MSOA, LTLA, substr(MSOA, 1, 1))]), on = c(id = 'MSOA')],
    unique(yu[, .('LTLA', id = LTLA22CD, LTLA22NM)])[unique(lkp[, .(LTLA, UTLA, substr(LTLA, 1, 1))]), on = c(id = 'LTLA')],
    unique(yu[, .('UTLA', id = UTLA22CD, UTLA22NM)])[unique(lkp[, .(UTLA, RGN, substr(UTLA, 1, 1))]), on = c(id = 'UTLA')],
    unique(yu[, .('RGN', id = RGN22CD, RGN22NM)])[unique(lkp[, .(RGN, CTRY, substr(RGN, 1, 1))]), on = c(id = 'RGN')],
    unique(yu[, .('CTRY', id = CTRY22CD, CTRY22NM, 'K04000001', substr(CTRY22CD, 1, 1))])
), use.names = FALSE)
lkp[substr(UTLA, 2, 2) != '1', UTLA := paste0(substr(UTLA, 1, 3), '1', substring(UTLA, 5))]
lkp[RGN == 'W92000004', RGN := 'W92000000']
lkp[, c('PCON', 'WARD', 'PAR', 'CCG') := NA_character_]
lca[type == 'UTLA' & substr(id, 2, 2) != '1', id := paste0(substr(id, 1, 3), '1', substring(id, 5))]
lca[type == 'UTLA' & parent == 'W92000004', parent := 'W92000000']
lca[type == 'LTLA' & substr(parent, 2, 2) != '1', parent := paste0(substr(parent, 1, 3), '1', substring(parent, 5))]
fwrite(lkp, './data-raw/csv/lookups.csv')
fwrite(lca, './data-raw/csv/zones.csv')

rm(list = ls())
gc()
