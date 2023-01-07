############################################
# UK CENSUS 2021 * Build parent boundaries #
############################################

Rfuns::load_pkgs('data.table', 'qs', 'sf')

st_dissolve <- \(y, x)
    y |> merge(yk[, .(OA, get(x))]) |> dplyr::group_by(V2) |> dplyr::summarize() |> st_as_sf() |> st_make_valid() |> setnames('V2', x)

ybf <- qs::qread('./data-raw/qs/OA.bfc', nthreads = 6)                     # full details
ybs <- qs::qread('./data-raw/qs/OA', nthreads = 6) |> st_transform(27700)  # simplified
yk <- fread('./data-raw/csv/lookups.csv')
yn <- setdiff(names(yk), 'OA')                                             # all zones
# yn <- yn[(which(yn == 'CTRY') + 1):length(yn)]                             # non-census zones

for(tp in yn){
    message('Processing ', tp)
    message(' - full ')
    qsave(st_dissolve(ybf, tp), paste0('./data-raw/qs/', tp, '.bfc'), nthreads = 6)
    message(' - simplified')
    y <- st_dissolve(ybs, tp) |> st_transform(4326)
    qsave(y, paste0('./data-raw/qs/', tp), nthreads = 6)
    assign(tp, y)
    save(list = tp, file = file.path('data', paste0(tp, '.rda')), version = 3, compress = 'gzip')
}

rm(list = ls())
gc()
