################################################################
# Copy datasets from PUBLIC REPO (or else) to PACKAGE DATA DIR #
################################################################
# Rfuns::save_dts_pkg(fread(paste0('./data-raw/csv/', fn, '.csv')), fn, file.path(), dbn = '', csv_in_pkg = FALSE)

ssave <- \(x){
    message(' - ', x)
    assign(x, fread(paste0('./data-raw/csv/', x, '.csv')))
    save(list = x, file = file.path('data', paste0(x, '.rda')), version = 3, compress = 'gzip')
}

# meta
message('\nProcessing "meta" tables:')
for(fn in c('domains', 'tables', 'vars', 'vars_refs', 'main_refs', 'summaries', 'metrics')) ssave(fn)

# geography
message('\nCopying the "postcodes" table...')
y <- fst::read_fst(file.path(Rfuns::geouk_path, 'postcodes'), columns = c('PCU', 'OA21'), as.data.table = TRUE)
y <- y[!is.na(OA21)]
setnames(y, c('postcode', 'OA'))
fwrite(y, './data-raw/csv/postcodes.csv')
message('\nAdding `OA` to the "lookups" table...')
yk <- fread('./data-raw/csv/lookups.csv')
yz <- fread('./data-raw/csv/zones.csv')
yz <- yz[type != 'OA']
yz <- rbindlist(list(yz, yk[, .(type = 'OA', id = OA, name = OA, parent = LSOA, country = substr(OA, 1, 1))]))
fwrite(yz, './data-raw/csv/zones.csv')
message('\nProcessing "geography" tables:')
for(fn in c('zone_types', 'zones', 'lookups', 'neighbours', 'missing', 'postcodes')) ssave(fn)


# datasets
message('\nProcessing datasets:')
for(fn in gsub('.csv$', '', list.files('./data-raw/csv/', 'dt_.*csv$'))) ssave(fn)

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

# clear and exit
rm(list = ls())
gc()
