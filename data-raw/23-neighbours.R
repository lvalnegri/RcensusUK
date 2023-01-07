###############################
# UK CENSUS 2021 * Neighbours #
###############################

Rfuns::load_pkgs('data.table')
yt <- fread('./data-raw/csv/zone_types.csv')

y <- rbindlist(lapply(
        yt$type,
        \(tp){
            message('Processing ', tp)
            message(' - reading boundaries...')
            yb <- qs::qread(paste0('./data-raw/qs/', tp, '.bfc'))
            ybd <- yb |> st_drop_geometry()
            message(' - calculating neighbors...')
            yn <- st_intersects(yb, yb)
            message(' - building the table...')
            rbindlist(lapply( 1:nrow(yn), \(x) data.table( tp, ybd[x,], ybd[yn[[x]],] ) ))
        }
), use.names = FALSE) |> setnames(c('type', 'idA', 'idB'))
save_dts_pkg(y[idA != idB][order(type, idA, idB)], 'neighbours', dbn = 'census_uk')

rm(list = ls())
gc()
