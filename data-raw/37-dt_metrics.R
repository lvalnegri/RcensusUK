###############################################
# UK CENSUS 2021 * Build <dt_metrics> table #
###############################################

Rfuns::load_pkgs('data.table')
load_all()
ym <- fread('./data-raw/csv/metrics.csv')
yz <- fread('./data-raw/csv/zone_types.csv')
yk <- fread('./data-raw/csv/lookups.csv')

for(m in 1:nrow(ym)){
    eval(parse(text = gsub('x2', x2, gsub('x1', x1, ops))))    
}

# save
fwrite(y, './data-raw/csv/dt_metrics.csv')
zip(paste0('./data-raw/csv/dt_metrics.csv.zip'), paste0('./data-raw/csv/dt_metrics.csv'))

# clear and exit
rm(list = ls())
gc()
