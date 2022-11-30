#######################################################################################################
# UK CENSUS 2021 * Maps for non-exact types (PAR, WARD, PCON) and their missing Areas (PAR-WARD) and  #
#######################################################################################################

for(x in c('PCON', 'WARD', 'PAR', 'CCG')){
    message('Processing non-exact for ', x)
    htmlwidgets::saveWidget(RcensusUK::map_nonexact(x), paste0('./data-raw/maps/', x))
}

for(x in c('WARD', 'PAR')){
    message('Processing missing for', x)
    htmlwidgets::saveWidget(RcensusUK::map_missing(x), paste0('./data-raw/maps/', x))
}
