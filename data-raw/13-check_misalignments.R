#######################################################
# UK CENSUS 2021 * check misalignments in hierarchies #
#######################################################
 
yk <- fread('./data-raw/csv/lookups.csv')
check_msg <- \(x) yk[, .N, .(OA, LSOA)][, .N, OA][N > 1]
# building from
yk[, .N, .(OA, LSOA)][, .N, OA][N > 1]
yk[, .N, .(LSOA, MSOA)][, .N, LSOA][N > 1]
yk[, .N, .(MSOA, LTLA)][, .N, MSOA][N > 1]
yk[, .N, .(LTLA, UTLA)][, .N, LTLA][N > 1]
yk[, .N, .(UTLA, RGN)][, .N, UTLA][N > 1]
yk[, .N, .(RGN, CTRY)][, .N, RGN][N > 1]
yk[, .N, .(LSOA, CCG)][, .N, LSOA][N > 1]
yk[, .N, .(LSOA, PCON)][, .N, LSOA][N > 1]
# moving up
yk[, .N, .(PCON, RGN)][, .N, PCON][N > 1]
yk[, .N, .(WARD, LTLA)][, .N, WARD][N > 1]
yk[, .N, .(PAR, LTLA)][, .N, PAR][N > 1]
yk[, .N, .(CCG, CTRY)][, .N, CCG][N > 1]

yb <- list(
  'OA'   = qs::qread('./data-raw/qs/OA', nthreads = 6),
  'LSOA' = qs::qread('./data-raw/qs/LSOA', nthreads = 6),
  'MSOA' = qs::qread('./data-raw/qs/MSOA', nthreads = 6),
  'LTLA' = qs::qread('./data-raw/qs/LTLA', nthreads = 6),
  'UTLA' = qs::qread('./data-raw/qs/UTLA', nthreads = 6)
)

# LTLA > UTLA [DONE]
mg <- c('E00074527', 'E06000024') # LTLA > UTLA: E06000025 
mg <- c('W00004674', 'W06000011') # LTLA > UTLA: W06000012
leaflet() |> 
    add_maptile(tiles.lst[[1]]) |> 
    addPolygons(data = yb$UTLA |> subset(UTLA == yk[OA == mg[1], UTLA]), group = 'UTLA wrong', color = 'black', fillOpacity = 0, label = ~paste('UTLA wrong: ', UTLA) ) |> 
    addPolygons(data = yb$UTLA |> subset(UTLA == mg[2]), group = 'UTLA correct', color = 'black', fillOpacity = 0, label = ~paste('UTLA correct: ', UTLA) ) |> 
    addPolygons(data = yb$LTLA |> subset(LTLA == yk[OA == mg[1], LTLA]), group = 'LTLA', color = 'blue', fillOpacity = 0, label = ~paste('LTLA: ', LTLA) ) |> 
    addPolygons(data = yb$MSOA |> subset(MSOA == yk[OA == mg[1], MSOA]), group = 'MSOA', color = 'green', fillOpacity = 0, label = ~paste('MSOA: ', MSOA) ) |> 
    addPolygons(data = yb$LSOA |> subset(LSOA == yk[OA == mg[1], LSOA]), group = 'LSOA', color = 'gold', fillOpacity = 0, label = ~paste('LSOA: ', LSOA) ) |> 
    addPolygons(data = yb$OA |> subset(OA == mg[1]), group = 'OA', color = 'red', label = ~paste('OA: ', OA) ) |> 
    addLayersControl(overlayGroups = c('OA', 'LSOA', 'MSOA', 'LTLA', 'UTLA wrong', 'UTLA correct'))  

yk[OA == 'E00074527', UTLA := 'E06000024']
yk[OA == 'W00004674', UTLA := 'W06000011']
fwrite(yk, './data-raw/csv/lookups.csv')

rm(list = ls())
gc()
