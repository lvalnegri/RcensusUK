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
            yb <- qs::qread(paste0('./data-raw/qs/', tp)) |> st_transform(27700) |> st_make_valid()
            ybd <- yb |> st_drop_geometry()
            message(' - calculating neighbors...')
            yn = st_intersects(yb, yb)
            message(' - building the table...')
            rbindlist(lapply( 1:nrow(yn), \(x) data.table( tp, ybd[x,], ybd[yn[[x]],] ) ))
        }
)) |> setnames(c('type', 'idA', 'idB'))
y <- y[idA != idB]
fwrite(y, './data-raw/csv/neighbours.csv')

rm(list = ls())
gc()
