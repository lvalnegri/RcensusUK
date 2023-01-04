###############################################
# UK CENSUS 2021 * Build <dt_geography> table #
###############################################

# 1 > area
yo <- qs::qread('./data-raw/qs/OA') |> st_transform(27700)
y <- data.table(var_id = 1, yo |> st_drop_geometry() |> setNames('zone_id'), value = yo |> sf::st_area() |> as.numeric() / 1e6)

# others ???


# save
fwrite(y, './data-raw/csv/dt_geography.csv')
zip(paste0('./data-raw/csv/dt_geography.csv.zip'), paste0('./data-raw/csv/dt_geography.csv'))

# clear and exit
rm(list = ls())
gc()
