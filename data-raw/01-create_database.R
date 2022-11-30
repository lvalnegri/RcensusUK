########################################################
# UK CENSUS 2021 * Create database and tables in MySQL #
########################################################

library(Rfuns)

dbn <- 'census_uk'
dd_create_db(dbn)

# ZONE_TYPES ------------
x = "
    type CHAR(4) NOT NULL,
    id TINYINT UNSIGNED NOT NULL,
    ons_id TINYINT UNSIGNED NOT NULL,
    name CHAR(50) NOT NULL,
    level TINYINT UNSIGNED NOT NULL,
    max_child CHAR(4) NULL,
    min_parent CHAR(4) NULL,
    nE MEDIUMINT UNSIGNED NOT NULL,
    nW MEDIUMINT UNSIGNED NOT NULL,
    nEW MEDIUMINT UNSIGNED NOT NULL,
    is_exact TINYINT(1) UNSIGNED NOT NULL,
    cbo_filter CHAR(4) NULL,
    PRIMARY KEY (type),
    UNIQUE INDEX id (id),
    INDEX is_exact (is_exact),
    INDEX level (level)
"
dd_create_dbtable('zone_types', dbn, x)

# ZONES -----------------
x <- "
    type CHAR(4) NOT NULL,
    id CHAR(9) NOT NULL,
    name CHAR(75) NOT NULL,
    parent CHAR(9) NULL,
    country CHAR(1) NOT NULL,
    PRIMARY KEY (code),
    INDEX type (type),
    INDEX parent (parent),
    INDEX country (country)
"
dd_create_dbtable('zones', dbn, x)

# LOOKUPS --------------
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
    INDEX CCG (CCG)
"
dd_create_dbtable('lookups', dbn, x)

# MISSING -----------------
x <- "
    type CHAR(4) NOT NULL,
    zone_id CHAR(9) NOT NULL,
    parent CHAR(9) NOT NULL,
    sibling CHAR(9) NOT NULL,
    PRIMARY KEY (type, code)
"
dd_create_dbtable('missing', dbn, x)

# DOMAINS -----------------
x <- "
    id TINYINT(1) UNSIGNED NOT NULL,
    description CHAR(75) NOT NULL,
    PRIMARY KEY (id)
"
dd_create_dbtable('domains', dbn, x)

# TABLES -----------------
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

# VARS -----------------
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

# DATASET -----------------
x <- "
    zone_id CHAR(9) NOT NULL,
    var_id MEDIUMINT(1) UNSIGNED NOT NULL,
    value INT UNSIGNED NOT NULL,
    PRIMARY KEY (zone_id, var_id)
"
dd_create_dbtable('dataset', dbn, x)

## END --------------------------------
rm(list = ls())
gc()
