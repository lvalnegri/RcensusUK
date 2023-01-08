################################################################
# Copy datasets from PUBLIC REPO (or else) to PACKAGE DATA DIR #
################################################################

# meta
message('\nProcessing "meta" tables:')
for(x in c('domains', 'tables', 'vars', 'vars_refs', 'main_refs', 'metrics')) 
    Rfuns::save_dts_pkg(fread(paste0('./data-raw/csv/', x, '.csv')), x, dbn = 'census_uk')

# geography
message('\nCopying the "postcodes" table...')
Rfuns::save_dts_pkg(RpostcodesUK::postcodes[, .(PCU, OA)], 'postcodes', dbn = 'census_uk')

message('\nProcessing "geography" tables:')
Rfuns::save_dts_pkg(fread('./data-raw/csv/zone_types.csv'), 'zone_types', dbn = 'census_uk')

# boundaries ons for non-exact
message('\nProcessing ONS boundaries:')
for(fn in ids$type){
    message(' - ', fn)
    y <- qs::qread(paste0('./data-raw/qs/', fn, '.ori'), nthreads = 6) |>
              subset(substr(get(fn), 1, 1) %in% c('E', 'W'), select = 1) |> 
              sf::st_transform(4326) |> 
              rmapshaper::ms_simplify(0.2)
    fno <- paste0(fn, 'o')
    assign(fno, y)
    save(list = fno, file = file.path('data', paste0(fno, '.rda')), version = 3, compress = 'gzip')
}

# clear and exit
rm(list = ls())
gc()
