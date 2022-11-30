#####################################################################
# UK CENSUS 2021 * create PCON/WARD/PAR/CCG lookups from boundaries #
#####################################################################

Rfuns::load_pkgs('data.table', 'qs', 'sf')
load_all()

yb <- qread(file.path(bnduk_path, 's00', 'OA21gb'), nthreads = 6) |> setnames('OA21', 'OA')
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

message('\nSave "missing" zones for PAR and WARD')
fwrite(
    rbindlist(list(
        data.table(
            'WARD',
            st_read(list.files('./data-raw/shp/', 'WD.*\\.shp$', full.names = TRUE), quiet = TRUE) |> 
                subset(!WD21CD %in% unique(yk$WARD) & substr(WD21CD, 1, 1) %in% c('E', 'W'), select = c('WD21CD')) |> 
                st_drop_geometry()
        ),
        data.table(
            'PAR',
            st_read(list.files('./data-raw/shp/', 'PARNCP.*\\.shp$', full.names = TRUE), quiet = TRUE) |> 
                subset(!PARNCP21CD %in% unique(yk$PAR) & substr(PARNCP21CD, 1, 1) %in% c('E', 'W'), select = c('PARNCP21CD')) |> 
                st_drop_geometry()
        )
    ), use.names = FALSE) |> setnames(c('type', 'zone_id')),
    './data-raw/csv/missing.csv'
)


rm(list = ls())
gc()
