##########################################
# UK CENSUS 2021 * Build <dataset> table #
##########################################

Rfuns::load_pkgs('data.table')
in_path <- file.path(ext_path, 'uk', 'census', '2021', 'EW')
yd <- fread('./data-raw/csv/domains.csv')
yt <- unique(fread('./data-raw/csv/tables.csv', select = c('code', 'domain_id', 'min_type')))

# SUMMARIES
message('\n Processing summaries...')
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
fwrite(y[order(var_id)], './data-raw/csv/summaries.csv')

# DATA
for(idx in yd[loaded == 1, id]){
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
