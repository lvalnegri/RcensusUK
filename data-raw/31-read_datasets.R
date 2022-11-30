##########################################
# UK CENSUS 2021 * Build <dataset> table #
##########################################

Rfuns::load_pkgs('data.table')
in_path <- file.path(ext_path, 'uk', 'census', '2021', 'EW')
yd <- fread('./data-raw/csv/domains.csv')
yt <- unique(fread('./data-raw/csv/tables.csv', select = c('code', 'domain_id', 'min_type')))

# SUMMARY
fwrite(
    rbindlist(lapply(
      unique(yt$code), 
        \(tb){
            message(tb)
            y <- fread(file.path(in_path, paste0('census2021-', tolower(tb), '-', tolower(yt[code == tb, min_type]), '.csv')))[, -(1:3)]
            y <- data.table(table_code = tb, var_name = names(y), ons_name = names(y), y[, .(total = sapply(.SD, sum)), .SDcols = names(y)])
            y[, `:=`( table_scode = as.integer(substring(y$table_code, 3)) * 1000, prog_id = 1:.N )][, `:=`( var_id = table_scode + prog_id, set_null = 0 )]
        }
    )),
    './data-raw/csv/summary_tables.csv'
)

# DATA
for(idx in yd$id){
    ydn <- yd[id == idx, name]
    message('\n Processing ', ydn)
    ydt <- rbindlist(lapply(
              yt[domain_id == idx, code],
              \(tb){
                  message(' - Table: ', tb)
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
    fwrite(ydt, paste0('./data-raw/csv/dt_', ydn, '.csv'))
    zip(paste0('./data-raw/csv/dt_', ydn, '.csv.zip'), paste0('./data-raw/csv/dt_', ydn, '.csv'))
}

rm(list = ls())
gc()
