################################################
# UK CENSUS 2021 * Build OAs parent boundaries #
################################################

Rfuns::load_pkgs('data.table', 'qs', 'rmapshaper', 'sf')

# qread(file.path(bnduk_path, 's20', 'OA21'), nthreads = 6) |> 
#       setnames('OA21', 'OA') |> 
#       qsave('./data-raw/qs/OA', nthreads = 12)
yb <- qs::qread('./data-raw/qs/OA', nthreads = 6)
yk <- fread('./data-raw/csv/lookups.csv')

for(tp in setdiff(names(yk), 'OA')){
    message('Processing ', tp)
    yb |> 
        merge(yk[, .(OA, get(tp))]) |> 
        setnames('V2', tp) |> 
        ms_dissolve(tp) |> 
        qsave(paste0('./data-raw/qs/', tp), nthreads = 6)
}

rm(list = ls())
gc()
