####################################
# UK CENSUS 2021 * Build summaries #
####################################

Rfuns::load_pkgs('data.table')
in_path <- file.path(ext_path, 'uk', 'census', '2021', 'EW')
yt <- unique(fread('./data-raw/csv/tables.csv', select = c('code', 'domain_id', 'min_type')))
yt <- yt[domain_id > 0]

fwrite(
    rbindlist(lapply(
        unique(yt$code), 
          \(tb){
              message(tb)
              y <- fread(file.path(in_path, paste0('census2021-', tolower(tb), '-', tolower(yt[code == tb, min_type]), '.csv')))[, -(1:3)]
              y <- data.table(
                      table_code = tb, 
                      var_name = gsub('; measures: Value', '', names(y)), 
                      ons_name = names(y), 
                      y[, .(total = sapply(.SD, sum)), .SDcols = names(y)]
              )
              y[, `:=`( table_scode = as.integer(substring(y$table_code, 3)) * 1000, prog_id = 1:.N )][, `:=`( var_id = table_scode + prog_id, set_null = 0 )]
          }
      )) -> y1,
    './data-raw/csv/summary_vars.csv'
)

y <- rbindlist(lapply(
  unique(yt$code), 
  \(tb){
    message(tb)
    y <- fread(file.path(in_path, paste0('census2021-', tolower(tb), '-', tolower(yt[code == tb, min_type]), '.csv')))[, -(1:2)]
    setnames(y, 1, 'X')
    y[, X := substr(X, 1, 1)]
    y <- data.table( table_code = tb, ons_name = names(y[,-1]), y[, sapply(.SD, sum), X, .SDcols = names(y[,-1])] )
  }
)) |> dcast(table_code+ons_name~X, value.var = 'V1', fun = sum)
y[, T := rowSums(y[, names(y)[3:ncol(y)], with = FALSE])]
y <- y1[, .(ons_name, table_code, var_id)][y, on = c('ons_name', 'table_code')] |> setcolorder(c('table_code', 'var_id'))
save_dts_pkg(y[order(var_id)], 'summaries', dbn = 'census_uk')

rm(list = ls())
gc()
