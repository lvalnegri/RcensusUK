#######################################################
# UK CENSUS 2021 * check misalignments in hierarchies #
#######################################################
 
y <- fread('./data-raw/csv/lookups.csv')
check_msg <- \(x) y[, .N, .(OA, LSOA)][, .N, OA][N > 1]
# building from
y[, .N, .(OA, LSOA)][, .N, OA][N > 1]
y[, .N, .(LSOA, MSOA)][, .N, LSOA][N > 1]
y[, .N, .(MSOA, LTLA)][, .N, MSOA][N > 1]
y[, .N, .(LTLA, UTLA)][, .N, LTLA][N > 1]
y[, .N, .(UTLA, RGN)][, .N, UTLA][N > 1]
y[, .N, .(RGN, CTRY)][, .N, RGN][N > 1]
y[, .N, .(LSOA, CCG)][, .N, LSOA][N > 1]
y[, .N, .(LSOA, PCON)][, .N, LSOA][N > 1]
# moving up
y[, .N, .(PCON, RGN)][, .N, PCON][N > 1]
y[, .N, .(WARD, LTLA)][, .N, WARD][N > 1]
y[, .N, .(PAR, LTLA)][, .N, PAR][N > 1]
y[, .N, .(CCG, CTRY)][, .N, CCG][N > 1]

y[MSOA %in% unique(y[WARD == 'E05014284', MSOA])][order(LSOA, WARD)]
y[LSOA == 'E01027798', WARD := 'E05014328']

save_dts_pkg(y,'lookups', dbn = 'census_uk')

rm(list = ls())
gc()
