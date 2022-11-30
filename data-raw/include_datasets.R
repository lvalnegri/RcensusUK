################################################################
# Copy datasets from PUBLIC REPO (or else) to PACKAGE DATA DIR #
################################################################
# Rfuns::save_dts_pkg(fread(paste0('./data-raw/csv/', fn, '.csv')), fn, file.path(), dbn = '', csv_in_pkg = FALSE)

message('\nProcessing ancillary tables:')
for(fn in c('domains', 'tables', 'vars', 'zone_types', 'zones', 'lookups', 'neighbours', 'missing')){
    message(' - ', fn)
    assign(fn, fread(paste0('./data-raw/csv/', fn, '.csv')))
    save(list = fn, file = file.path('data', paste0(fn, '.rda')), version = 3, compress = 'gzip')
}

message('\nProcessing datasets:')
for(fn in list.files('./data-raw/csv/', 'dt_.*csv$')){
    fn <- gsub('.csv$', '', fn)
    message(' - ', fn)
    assign(fn, fread(paste0('./data-raw/csv/', fn, '.csv')))
    save(list = fn, file = file.path('data', paste0(fn, '.rda')), version = 3, compress = 'gzip')
}

# boundaries
message('\nProcessing built boundaries:')
for(fn in fread(paste0('./data-raw/csv/zone_types.csv'))[, type]){
    message(' - ', fn)
    assign(fn, qs::qread(paste0('./data-raw/qs/', fn), nthreads = 6))
    save(list = fn, file = file.path('data', paste0(fn, '.rda')), version = 3, compress = 'gzip')
}

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

rm(list = ls())
gc()
