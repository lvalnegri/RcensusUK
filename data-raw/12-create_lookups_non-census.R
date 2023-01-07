#########################################################################
# UK CENSUS 2021 * create LAD/PCON/WARD/PAR/CCG lookups from boundaries #
#########################################################################

Rfuns::load_pkgs('data.table', 'qs', 'sf')
load_all()

ctry <- c('E', 'W')
yb <- qread('./data-raw/qs/OA.bfc', nthreads = 6)
yk <- fread('./data-raw/csv/lookups.csv')
ykn <- names(yk)

url_pfx <- 'https://opendata.arcgis.com/api/v3/datasets/'
url_sfx <- '_0/downloads/data?format=shp&spatialRefId=27700&where=1%3D1'
  
for(idx in 1:nrow(ids)){
  
    idn <- ids[idx, type]
    message('Processing ', idn)

    message(' * Reading ONS shapefiles...')
    if(idn == 'CCG'){
        y <- qread(paste0('./data-raw/qs/CCG.ori'), nthreads = 6) 
    } else {
        y <- Rgeo::dwn_shp_zip(
                paste0(url_pfx, ids[idx, map_id], url_sfx), 
                c(ids[idx, code], ids[idx, name]),
                c(idn, paste0(idn, 'd')),
                out_path = './data-raw/shp/'
        )
        if(!is.null(ctry)) y  <- y |> subset(substr(get(idn), 1, 1) %in% ctry)
        fwrite(as.data.table(y |> st_drop_geometry()), paste0('./data-raw/csv/', idn, '.csv'))
        qsave(y, paste0('./data-raw/qs/', idn, '.ori'), nthreads = 12) 
    }
    
    message(' * Calculating OAs in exact coverage...')
    yc <- as.numeric(sf::st_covered_by(yb, y))
    yc <- data.table( yb |> st_drop_geometry(),  y[yc, idn] |> st_drop_geometry() )
  
    message(' * Calculating intersections from remaining OAs (', formatC(yc[is.na(get(idn)), .N], big.mark = ','), ')...')
    ycn <- yc[, .I[is.na(get(idn))]]
    yct <- st_intersects(yb[ycn,], y)
    yctx <- which(lapply(yct, length) == 1)
    yc[ycn[yctx], 2 := y[unlist(yct[yctx]),] |> st_drop_geometry() |> subset(select = idn)]
    yctx <- which(lapply(yct, length) > 1)
  
    message(' * Working out multiple intersections (', formatC(length(yctx), big.mark = ','), ')...')
    for(x in yctx){
        msg_chk <- which(yctx == x) / length(yctx)
        if(msg_chk * 10) message('   - currently at ', floor(msg_chk * 100), '%')
        yx <- unlist(yct[x])
        yx <- yx[which.max(as.numeric(st_area(st_intersection(yb[ycn[x],], y[yx,]))))]
        yc[ycn[x], 2 := y[yx,] |> st_drop_geometry() |> subset(select = idn)]
    }

    if(ids[idx, lsoa]){
        message(' * fixing LSOA overlapping...')
        setnames(yc, idn, 'X')
        yc <- fread('./data-raw/csv/lookups.csv', select = c('OA', 'LSOA'))[yc, on = 'OA']
        yco <- unique(yc[, .(LSOA, X)])[, .N, LSOA][N > 1, as.character(LSOA)]
        for(x in yco) yc[LSOA == x, X := head(yc[LSOA == x, .N, X][order(-N)][, X], 1)] 
        yc[, LSOA := NULL]
        setnames(yc, 'X', idn)
    }

    message(' * saving lookups...')
    yk[, (idn) := NULL]
    yk <- yc[yk, on = 'OA'] |> setcolorder(ykn)
    fwrite(yk, './data-raw/csv/lookups.csv')
}

message('\nFinding "missing" zones for PAR and WARD')
ym <- rbindlist(lapply(
        c('WARD', 'PAR'),
        \(x){
            xi <- ids[type == x]
            data.table(
                x,
                st_read(list.files('./data-raw/shp/', paste0(xi$ons, '.*\\.shp$'), full.names = TRUE), quiet = TRUE) |> 
                    subset(
                        !get(xi$code) %in% unique(yk[[x]]) & substr(get(xi$code), 1, 1) %in% c('E', 'W'), 
                        select = xi$code
                    ) |> 
                    st_drop_geometry()
            )
        }
), use.names = FALSE) |> setnames(c('type', 'zone_id')),

message('Adding data to missing zones...')
for(x in c('WARD', 'PAR')){
    message(' - Processing ', x)
    ti <- ids[type == x]
    ybm <- st_read(file.path('./data-raw/shp/', list.files('./data-raw/shp/', paste0(ti$ons, '.*shp$')))) |> subset(get(ti$code) %in% ym$zone_id)
    yct <- st_intersects(ybm, yb)
    for(x in 1:length(yct)){
        yx <- yct[[x]]
        yx <- yx[which.max(as.numeric(st_area(st_intersection(yb[yx,], ybm[x,]))))]
        moa <- yb[yx,] |> st_drop_geometry() |> as.character()
        ym[zone_id == ybm[x, ti$code] |> st_drop_geometry(), `:=`( OA = moa, sibling = yk[OA == moa, get(ti$type)], parent = yk[OA == moa, get(ids[type == ti$type, parent])]) ]
    }
}
save_dts_pkg(ym, 'missing', dbn = 'census_uk')

rm(list = ls())
gc()
