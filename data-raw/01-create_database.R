########################################################
# UK CENSUS 2021 * Create database and tables in MySQL #
########################################################

library(Rfuns)

dbn <- 'census_uk'
dd_create_db(dbn)

# META ----------------------

## DOMAINS -------------
x <- "
    id TINYINT(1) UNSIGNED NOT NULL,
    description CHAR(75) NOT NULL,
    PRIMARY KEY (id)
"
dd_create_dbtable('domains', dbn, x)

## TABLES --------------
x <- "
    id SMALLINT UNSIGNED NOT NULL,
    code CHAR(5) NOT NULL,
    description CHAR(75) NOT NULL,
    domain_id TINYINT(1) UNSIGNED NOT NULL,
    min_type CHAR(4) NOT NULL,
    units CHAR(5) NOT NULL,
    ons_url CHAR(75) NOT NULL,
    PRIMARY KEY (id),
    INDEX domain_id (domain_id)
"
dd_create_dbtable('tables', dbn, x)

## VARS ----------------
x <- "
    id MEDIUMINT UNSIGNED NOT NULL,
    ordering SMALLINT UNSIGNED NOT NULL,
    description CHAR(75) NOT NULL,
    table_id TINYINT(1) UNSIGNED NOT NULL,
    ref MEDIUMINT UNSIGNED NOT NULL,
    sref MEDIUMINT UNSIGNED NOT NULL,
    is_ref TINYINT(1) UNSIGNED NOT NULL,
    PRIMARY KEY (id),
    INDEX table_id (table_id),
    INDEX is_ref (is_ref)
"
dd_create_dbtable('vars', dbn, x)


# GEOGRAPHY -----------------

## ZONE_TYPES ----------
x = "
    type CHAR(4) NOT NULL,
    id TINYINT UNSIGNED NOT NULL,
    name CHAR(50) NOT NULL,
    level TINYINT UNSIGNED NOT NULL,
    max_child CHAR(4) NULL,
    min_parent CHAR(4) NULL,
    nE MEDIUMINT UNSIGNED NOT NULL,
    nW MEDIUMINT UNSIGNED NOT NULL,
    nEW MEDIUMINT UNSIGNED NOT NULL,
    is_exact CHAR(1) NOT NULL,
    cbo_filter CHAR(4) NULL,
    is_frozen CHAR(1) NOT NULL,
    last_update CHAR(6) NOT NULL,
    is_active CHAR(1) NOT NULL,
    ons_id CHAR(6) NOT NULL,
    ons_code CHAR(10) NOT NULL,
    ons_name CHAR(10) NULL,
    ons_map_id CHAR(36) NULL,
    PRIMARY KEY (type),
    UNIQUE INDEX id (id),
    INDEX is_exact (is_exact),
    INDEX level (level)
"
dd_create_dbtable('zone_types', dbn, x)

## ZONES ---------------
x <- "
    type CHAR(4) NOT NULL,
    id CHAR(9) NOT NULL,
    name CHAR(75) NOT NULL,
    parent CHAR(9) NULL,
    country CHAR(1) NOT NULL,
    area INT(10) UNSIGNED NULL DEFAULT NULL,
    perimeter MEDIUMINT(8) UNSIGNED NULL DEFAULT NULL,
    x_lon DECIMAL(8,6) NULL DEFAULT NULL COMMENT 'longitude for the Geometric Centroid',
    y_lat DECIMAL(8,6) UNSIGNED NULL DEFAULT NULL COMMENT 'latitude for the Geometric Centroid',
    wx_lon DECIMAL(8,6) NULL DEFAULT NULL COMMENT 'longitude for the Population Weigthed centroid',
    wy_lat DECIMAL(8,6) UNSIGNED NULL DEFAULT NULL COMMENT 'latitude for the Population Weigthed centroid',
    px_lon DECIMAL(8,6) NULL DEFAULT NULL COMMENT 'longitude for the Pole of inaccessibility',
    py_lat DECIMAL(8,6) UNSIGNED NULL DEFAULT NULL COMMENT 'latitude for the Pole of inaccessibility',
    PRIMARY KEY (type, id),
    INDEX parent (parent),
    INDEX country (country)
"
dd_create_dbtable('zones', dbn, x)

## LOCALITIES ----------
x <- "
    LOC CHAR(10) NOT NULL,
    LOCd CHAR(50) NOT NULL,
    LOCo CHAR(50) NOT NULL,
    x_lon DECIMAL(8,6) NOT NULL,
    y_lat DECIMAL(8,6) NOT NULL,
    OA CHAR(9) NOT NULL,
    PRIMARY KEY (LOC),
    INDEX OA (OA)
"
dd_create_dbtable('localities', dbn, x)

## LOOKUPS -------------
x <- "
    OA CHAR(9) NOT NULL COMMENT 'Output Area',
    LSOA CHAR(9) NOT NULL COMMENT 'Lower Layer Super Output Area',
    MSOA CHAR(9) NULL DEFAULT NULL COMMENT 'Middle Layer Super Output Area',
    LTLA CHAR(9) NOT NULL COMMENT 'Lower Tier Local Authority',
    UTLA CHAR(9) NOT NULL COMMENT 'Upper Tier Local Authority',
    RGN CHAR(9) NOT NULL COMMENT 'Region',
    CTRY CHAR(3) NOT NULL COMMENT 'Country',
    PCON CHAR(9) NOT NULL COMMENT 'Westminster Parliamentary Constituency',
    WARD CHAR(9) NOT NULL COMMENT 'Electoral Ward',
    PAR CHAR(9) NULL DEFAULT NULL COMMENT 'Civil Parish and Unparished Area',
    CCG CHAR(9) NOT NULL COMMENT '`Sub ICB Location` for England (LOC) and `Local Health Board` for Wales (LHB)',
    LAD CHAR(9) NOT NULL COMMENT 'Local Authorities and Districts',
    PRIMARY KEY (OA),
    INDEX LSOA (LSOA),
    INDEX MSOA (MSOA),
    INDEX LTLA (LTLA),
    INDEX UTLA (UTLA),
    INDEX RGN (RGN),
    INDEX CTRY (CTRY),
    INDEX PCON (PCON),
    INDEX WARD (WARD),
    INDEX PAR (PAR),
    INDEX CCG (CCG),
    INDEX LAD (LAD)
"
dd_create_dbtable('lookups', dbn, x)

## MISSING ------------------
x <- "
    type CHAR(4) NOT NULL,
    zone_id CHAR(9) NOT NULL,
    OA CHAR(9) NOT NULL,
    parent CHAR(9) NOT NULL,
    sibling CHAR(9) NOT NULL,
    PRIMARY KEY (type, zone_id)
"
dd_create_dbtable('missing', dbn, x)

## NEIGHBOURS ------------------
x <- "
    type CHAR(4) NOT NULL,
    idA CHAR(9) NOT NULL,
    idB CHAR(9) NOT NULL,
    PRIMARY KEY (type, idA, idB)
"
dd_create_dbtable('neighbours', dbn, x)


# DATASETS ------------------

## POPULATION ----------
x <- "
    zone_id CHAR(9) NOT NULL,
    var_id MEDIUMINT(1) UNSIGNED NOT NULL,
    value INT UNSIGNED NOT NULL,
    PRIMARY KEY (zone_id, var_id)
"
dd_create_dbtable('dt_population', dbn, x)


# END --------------------------------
rm(list = ls())
gc()
