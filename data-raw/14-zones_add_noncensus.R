##############################################
# UK CENSUS 2021 * add non-census to `zones` #
##############################################

library(data.table)
load_all()

yk <- fread('./data-raw/csv/lookups.csv')
yz <- fread('./data-raw/csv/zones.csv')
yzt <- fread('./data-raw/csv/zone_types.csv')
yz <- yz[!type %chin% ids$type]

y <- rbindlist(lapply(
        ids$type,
        \(x){
            y <- fread(paste0('./data-raw/csv/', x, '.csv'))
            data.table(x, y[unique(yk[, c(x, yzt[type == x, min_parent]), with = FALSE]), on = x])
        } 
), use.names = FALSE)|> setnames(c('type', 'id', 'name', 'parent'))
y[, country := substr(id, 1, 1)]    

fwrite(rbindlist(list( yz, y )), './data-raw/csv/zones.csv')

rm(list = ls())
gc()
