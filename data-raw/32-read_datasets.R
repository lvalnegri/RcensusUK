########################################
# UK CENSUS 2021 * Build <dt_*> tables #
########################################

Rfuns::load_pkgs('data.table')
in_path <- file.path(ext_path, 'uk', 'census', '2021', 'EW')
yd <- fread('./data-raw/csv/domains.csv')
yt <- unique(fread('./data-raw/csv/tables.csv', select = c('code', 'domain_id', 'min_type', 'loaded')))

for(idx in yd[id > 0 & loaded == 1, id]){
    ydn <- yd[id == idx, name]
    message('\n Processing ', ydn)
    message(' - Building dataset:')
    ydt <- rbindlist(lapply(
              yt[domain_id == idx  & loaded == 1, code],
              \(tb){
                  message('   * Table: ', tb)
                  y <- fread(file.path(
                          in_path, 
                          paste0('census2021-', tolower(tb), '-', tolower(yt[code == tb, min_type]), '.csv'))
                  )[, -(1:2)]
                  setnames(y, c('zone_id', 1:(ncol(y) - 1)))
                  y <- melt(y, id.vars = 1, variable.factor = FALSE, variable.name = 'var_id')
                  y[, var_id := as.integer(substring(tb, 3)) * 1000 + as.numeric(var_id)]
                  y[value != 0]
              }
    ))
    message(' - Saving')
    save_dts_pkg(ydt, paste0('dt_', ydn), dbn = 'census_uk', csv2zip = TRUE)
}

rm(list = ls())
gc()
