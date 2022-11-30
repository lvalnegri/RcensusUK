#' @importFrom data.table data.table
NULL

# META ----------------------

## DOMAINS -------------
#' domains
#'
#' The list of tables with some of their characteristics
#'
#' @format A data.table with the following columns:
#' \describe{
#'   \item{\code{ id }}{ The identifier for the Domain }
#'   \item{\code{ description }}{ The description for the Domain }
#' }
#'
'domains'

## TABLES --------------
#' tables
#'
#' The list of tables with some of their characteristics
#'
#' @format A data.table with the following columns:
#' \describe{
#'   \item{\code{ id }}{ The identifier for the Table }
#'   \item{\code{ code }}{ The ONS code for the Table }
#'   \item{\code{ description }}{ The descritpion for the Table }
#'   \item{\code{ domain_id }}{ The Domain the table is included, a foreign reference to the column `id` in the `domains` table }
#'   \item{\code{ min_type }}{ The minimum type of geographic hierarchy the data are available }
#'   \item{\code{ units }}{ The units in whi data are expressed }
#'   \item{\code{ url }}{ The direct url for the bulk download of data }
#' }
#' 
#' For further details, see the [Nomis website](https://www.nomisweb.co.uk/sources/census_2021)
#'
'tables'

## VARS ----------------
#' vars
#'
#' The list of variables with some of their characteristics
#'
#' @format A data.table with the following columns:
#' \describe{
#'   \item{\code{ id }}{ The code for the variables  }
#'   \item{\code{ ordering }}{ The order to use for reporting purposes  }
#'   \item{\code{ description }}{ The description for the variables }
#'   \item{\code{ table_id }}{ The Domain the table is included, a foreign reference to the column `id` in the `domains` table }
#'   \item{\code{ ref_id }}{ The id for the variable to use as reference (grand total) }
#'   \item{\code{ sref_id }}{ The id for the variable to use as subreference (sub total)   }
#'   \item{\code{ is_ref }}{ A flag to indicate if: 0-no reference variable, 1-reference, 2-subreference }
#' }
#'
#' For further details, see the [Nomis website](https://www.nomisweb.co.uk/sources/census_2021)
#'
'vars'

# DATASETS ------------------

## POPULATION ----------
#' Population and Households
#'
#' @format A data.table including the following Census Tables:
#' \describe{
#'   \item{\code{ TS001 }}{ Number of usual residents }
#'   \item{\code{ TS002 }}{ Legal partnership status }
#'   \item{\code{ TS006 }}{ Population density }
#'   \item{\code{ TS003 }}{ Household composition }
#'   \item{\code{ TS017 }}{ Household size }
#'   \item{\code{ TS010 }}{ Living arrangements }
#'   \item{\code{ TS011 }}{ Households by deprivation dimensions }
#' }
#'
#' For further details, see the [Nomis website](https://www.nomisweb.co.uk/sources/census_2021)
#'
'dt_population'

## SEX AND AGE ---------
#' Sex and Age
#'
#' @format A data.table including the following Census Tables:
#' \describe{
#'   \item{\code{ TS007 }}{ Age by single year }
#'   \item{\code{ TS007 }}{ Age by five years' classes }
#'   \item{\code{ TS008 }}{ Sex }
#'   \item{\code{ TS009 }}{ Sex by single year of age }
#'   \item{\code{ TS009 }}{ Sex by five years' classes of age }
#' }
#'
#' For further details, see the [Nomis website](https://www.nomisweb.co.uk/sources/census_2021)
#'
'dt_sexage'

##  MIGRATION ----------
#' Migration
#'
#' @format A data.table including the following Census Tables:
#' \describe{
#'   \item{\code{ TS004 }}{ Country of birth }
#'   \item{\code{ TS012 }}{ Country of birth (detailed) }
#'   \item{\code{ TS005 }}{ Passports held }
#'   \item{\code{ TS013 }}{ Passports held (detailed) }
#'   \item{\code{ TS015 }}{ Year of arrival in UK }
#'   \item{\code{ TS018 }}{ Age of arrival in the UK }
#'   \item{\code{ TS016 }}{ Length of residence }
#'   \item{\code{ TS019 }}{ Migrant Indicator }
#'   \item{\code{ TS020 }}{ Number of non-UK short-term residents by sex }
#'   \item{\code{ TS041 }}{ Number of Households }
#' }
#'
#' For further details, see the [Nomis website](https://www.nomisweb.co.uk/sources/census_2021)
#'
'dt_migration'

## ETHNICITY -----------
#' Ethnicities and Identities
#'
#' @format A data.table including the following Census Tables:
#' \describe{
#'   \item{\code{ TS021 }}{ Ethnic group }
#'   \item{\code{ TS022 }}{ Ethnic group (detailed) }
#'   \item{\code{ TS023 }}{ Multiple ethnic group }
#'   \item{\code{ TS027 }}{ National identity - UK }
#'   \item{\code{ TS028 }}{ National identity (detailed) }
#' }
#'
#' For further details, see the [Nomis website](https://www.nomisweb.co.uk/sources/census_2021)
#'
'dt_ethnicity'

## LANGUAGE ------------
#' Languages and UK Proficiency
#'
#' @format A data.table including the following Census Tables:
#' \describe{
#'   \item{\code{ TS024 }}{ Main language (detailed) }
#'   \item{\code{ TS025 }}{ Household language }
#'   \item{\code{ TS029 }}{ Proficiency in English }
#'   \item{\code{ TS026 }}{ Multiple main languages in households }
#' }
#'
#' For further details, see the [Nomis website](https://www.nomisweb.co.uk/sources/census_2021)
#'
'dt_language'

## RELIGION ------------
#' Religions
#'
#' @format A data.table including the following Census Tables:
#' \describe{
#'   \item{\code{ TS030 }}{ Religion }
#'   \item{\code{ TS031 }}{ Religion (detailed) }
#'   \item{\code{ TS075 }}{ Multi Religion households }
#' }
#'
#' For further details, see the [Nomis website](https://www.nomisweb.co.uk/sources/census_2021)
#'
'dt_religion'

## VETERANS ------------
#' UK Armed Forces Veterans
#'
#' @format A data.table including the following Census Tables:
#' \describe{
#'   \item{\code{ TS071 }}{ Previously served in the UK armed forces }
#'   \item{\code{ TS072 }}{ Number of people in household who have previously served in UK armed forces }
#'   \item{\code{ TS073 }}{ Population who have previously served in UK armed forces in communal establishments and in households }
#'   \item{\code{ TS074 }}{ Household Reference Person indicator of previous service in UK armed forces }
#' }
#'
#' For further details, see the [Nomis website](https://www.nomisweb.co.uk/sources/census_2021)
#'
'dt_veterans'


# GEOGRAPHY -----------------

## ZONE TYPES ------
#' Zone Types
#'
#' A list of all the Geographies included in the package(apart from the *Output Areas*, listed in the `lookups` table)
#'
#' @format A data.table with the following columns:
#' \describe{
#'   \item{\code{type}}{ An acronym for the Geography, used as its `id` throughout }
#'   \item{\code{id}}{ A numeric identifier for the Geography, used mostly for ordering }
#'   \item{\code{ons_id}}{ The id of the Geography used by ONS }
#'   \item{\code{name}}{ The Name for the Geography }
#'   \item{\code{level}}{ The level of details of the Geography in terms of hierarchy }
#'   \item{\code{max_child}}{ The `type` of Geography that nest exactly into the current Geography }
#'   \item{\code{min_parent}}{ The `type` of Geography that all the Zones of the current Geography nest exactly into }
#'   \item{\code{nE}}{ The total number of Zones in England }
#'   \item{\code{nW}}{ The total number of Zones in Wales }
#'   \item{\code{nEW}}{ The total number of Zones in England and Wales }
#'   \item{\code{is_exact}}{  }
#'   \item{\code{cbo_filter}}{  }
#' }
#'
#' For further details, see \url{https://geoportal.statistics.gov.uk/search?collection=Dataset&sort=name&tags=all(PRD_RGC)} and
#' \url{https://www.arcgis.com/sharing/rest/content/items/0d5d0ad97af04e18bc584e4fc3bc62de/data}
#'
'zone_types'

## ZONES -----------
#' zones
#'
#' A list of all the areas included in the `lookups` table, apart from the *Output Areas*, together with their names and some geographic characteristics.
#'
#' @format A data.table with the following columns:
#' \describe{
#'   \item{\code{type}}{ The geographic hierarchy the Area belongs to, as referenced in the `zone_types` table }
#'   \item{\code{id}}{ The `ONS` identifier for the Area }
#'   \item{\code{name}}{ The name for the Area  }
#'   \item{\code{parent}}{ The code of the zone in which the current zone is contained as immediate level in its most direct hierarchy}
#'   \item{\code{country}}{ The Country the Area belongs to (either `E`ngland or `W`ales)}
#'   \item{\code{ordering}}{ The preferred order in reporting results }
#' }
#'
#' For further details, see the \code{Names and Codes} section within \url{https://geoportal.statistics.gov.uk/}
#'
'zones'

## LOOKUPS -------------
#' lookups
#'
#' This dataset contains both a complete list of the *Output Areas*, the smallest statistical geographic area in both England and Wales,
#' and a mapping between them and all the other Geographies contained in the package, listed in the table `zone_types`.
#'
#' @format A data.table with the following columns:
#' \describe{
#'   \item{\code{OA}}{Output Area. Total units: . Base Layer. Direct Parent: LSOA }
#'   \item{\code{LSOA}}{Lower Layer Super Output Area. Total units: . Direct Parent: MSOA }
#'   \item{\code{MSOA}}{Middle Layer Super Output Area. Total units: 9,370. Direct Parent: LTLA }
#'   \item{\code{LTLA}}{Lower Tier Local Authority. Total units: 363. Direct Parent: UTLA }
#'   \item{\code{UTLA}}{Upper Tier Local Authority. Total units: 93. Last updated: May-21. Built From LAD. Direct Parent: RGN }
#'   \item{\code{RGN}}{Region. Total units: 10. Direct Parent: CTRY }
#'   \item{\code{CTRY}}{Country. Total units: 2. Direct Parent: NAT }
#'   \item{\code{PCON}}{Westminster Parliamentary Constituency. Total units: 650. Direct Parent: RGN }
#'   \item{\code{WARD}}{Electoral Ward. Total units: 8,875. Direct Parent: LTLA }
#'   \item{\code{PAR}}{Civil Parish or Unparished; Total units: 12,415. Direct Parent: UTLA }
#'   \item{\code{CCG}}{Clinical Commissioning Group. Total units: 106. Direct Parent: CTRY }
#' }
#'
#' For further details, see the `Lookups` section within the [ONS Open Geography portal](https://geoportal.statistics.gov.uk/)
#' 
'lookups'

## MISSING ----------
#' missing
#'
#' This dataset list the lookups for those `` and `` zones missing from the `lookups` table, 
#' because of them being smaller than the *Output Areas* they fall into 
#' but with smaller area of a similar zone competing for the same Output Area 
#' (which is the one comparing in `lookups`).
#'
#' @format A data.table with the following columns:
#' \describe{
#'   \item{\code{ type }}{ The type of the Area, as referenced in the `zone_types` table (either `PAR` or `WARD`) }
#'   \item{\code{ zone_id }}{ The identifier for the Area }
#'   \item{\code{ parent }}{ The code for the parent zone the Area should belong to }
#'   \item{\code{ sibling }}{ The code for the Area that appears in the `lookups`table having the same parent zone}
#' }
#'
'missing'

## NEIGHBOURS ----------
#' neighbours
#'
#' This dataset contains the *1st order neighbours* for all *Output Areas* and all the areas listed in the `zones` table.
#'
#' @format A data.table with the following columns:
#' \describe{
#'   \item{\code{ type }}{ The type of the zone as referenced in the \code{zone_types} table }
#'   \item{\code{ idA  }}{ The identifier for a zone }
#'   \item{\code{ idB  }}{ The (first) order neighbours of the zone with code `idA`}
#' }
#'
'neighbours'

#' @import sf
NULL

# BOUNDARIES ----------------

## OA ------------------
#' OA
#'
#' Digital Vector Boundaries in `sf` format and *WGS84* CRS (*epsg* 4326) for all 188,880 *Output Areas* in England and Wales, **Census 2021**.
#'
#' @format A `sf` dataframe with only one `OA` column for the corresponding *ONS* codes.
#'
#' For further details see \url{https://geoportal.statistics.gov.uk/search?collection=Dataset&sort=-modified&tags=all(BDY_OA)}.
#'
'OA'

## LSOA ----------------
#' LSOA
#'
#' Digital Vector Boundaries in `sf` format and *WGS84* CRS (*epsg* 4326) for all 35,672 *Lower Layer Super Output Areas* in England and Wales, **Census 2021**.
#'
#' Built by dissolving the `OA` boundaries using the `lookups` table.
#' 
#' @format A `sf` dataframe with only one `LSOA` column for the corresponding *ONS* codes.
#'
#' For further details see \url{https://geoportal.statistics.gov.uk/search?collection=Dataset&sort=-modified&tags=all(BDY_LSOA)}.
#'
'LSOA'

## MSOA ----------------
#' MSOA
#'
#' Digital Vector Boundaries in `sf` format and *WGS84* CRS (*epsg* 4326) for all 7,264 *Medium Layer Super Output Areas* in England and Wales, **Census 2021**.
#'
#' Built by dissolving the `LSOA` boundaries using the `lookups` table.
#' 
#' @format A `sf` dataframe with only one `MSOA` column for the corresponding *ONS* codes.
#'
#' For further details see \url{https://geoportal.statistics.gov.uk/search?collection=Dataset&sort=-modified&tags=all(BDY_MSOA)}.
#'
'MSOA'

## LTLA ----------------
#' LTLA
#'
#' Digital Vector Boundaries in `sf` format and *WGS84* CRS (*epsg* 4326) for all 331 *Lower Tier Local Authorities* in England and Wales.
#'
#' Built by dissolving the `MSOA` boundaries using the `lookups` table.
#' 
#' @format A `sf` dataframe with only one `LTLA` column for the corresponding *ONS* codes.
#'
#' For further details see \url{https://geoportal.statistics.gov.uk/search?collection=Dataset&sort=-modified&tags=all(BDY_LTLA)}.
#'
'LTLA'

## UTLA ----------------
#' UTLA
#'
#' Digital Vector Boundaries in `sf` format and *WGS84* CRS (*epsg* 4326) for all 174 *Upper Tier Local Authorities* in England and Wales.
#'
#' Built by dissolving the `LTLA` boundaries using the `lookups` table.
#' 
#' @format A `sf` dataframe with only one `UTLA` column for the corresponding *ONS* codes.
#'
#' For further details see \url{https://geoportal.statistics.gov.uk/search?collection=Dataset&sort=-modified&tags=all(BDY_UTLA)}.
#'
'UTLA'

## RGN -----------------
#' RGN
#'
#' Digital Vector Boundaries in `sf` format and *WGS84* CRS (*epsg* 4326) for all 9 *Regions* in England, plus Wales.
#'
#' Built by dissolving the `UTLA` boundaries using the `lookups` table.
#' 
#' @format A `sf` dataframe with only one `RGN` column for the corresponding *ONS* codes.
#'
#' For further details see \url{https://geoportal.statistics.gov.uk/search?collection=Dataset&sort=-modified&tags=all(BDY_RGN)}.
#'
'RGN'

## CTRY ----------------
#' CTRY
#'
#' Digital Vector Boundaries in `sf` format and *WGS84* CRS (*epsg* 4326) for England, plus Wales.
#'
#' Built by dissolving the `UTLA` boundaries using the `lookups` table.
#' 
#' @format A `sf` dataframe with only one `RGN` column for the corresponding *ONS* codes.
#'
#' For further details see \url{https://geoportal.statistics.gov.uk/search?collection=Dataset&sort=-modified&tags=all(BDY_RGN)}.
#'
'CTRY'

## PCON ----------------
#' PCON
#'
#' Digital Vector Boundaries in `sf` format and *WGS84* CRS (*epsg* 4326) for all 573 *Westminster Parliamentary Constituency* in England and Wales.
#'
#' Built by dissolving the `LSOA` boundaries using the `lookups` table.
#' 
#' @format A `sf` dataframe with only one `PCON` column for the corresponding *ONS* codes.
#'
#' For further details see \url{https://geoportal.statistics.gov.uk/search?collection=Dataset&sort=-modified&tags=all(BDY_PCON)}.
#'
'PCON'

## WARD ----------------
#' WARD
#'
#' Digital Vector Boundaries in `sf` format and *WGS84* CRS (*epsg* 4326) for all 7,878 *Electoral Ward* in England and Wales.
#'
#' Built by dissolving the `OA` boundaries using the `lookups` table.
#' 
#' @format A `sf` dataframe with only one `WARD` column for the corresponding *ONS* codes.
#'
#' For further details see \url{https://geoportal.statistics.gov.uk/search?collection=Dataset&sort=-modified&tags=all(BDY_WARD)}.
#'
'WARD'

## PAR -----------------
#' PAR
#'
#' Digital Vector Boundaries in `sf` format and *WGS84* CRS (*epsg* 4326) for all 11,562 *Civil Parishes and Unparished Communities* in England and Wales.
#'
#' Built by dissolving the `OA` boundaries using the `lookups` table.
#' 
#' @format A `sf` dataframe with only one `PAR` column for the corresponding *ONS* codes.
#'
#' For further details see \url{https://geoportal.statistics.gov.uk/search?collection=Dataset&sort=-modified&tags=all(BDY_PAR)}.
#'
'PAR'

## CCG -----------------
#' CCG
#'
#' Digital Vector Boundaries in `sf` format and *WGS84* CRS (*epsg* 4326) for all 113 *Clinical Commissioning Groups* in England and Wales
#' (106 *Sub-ICB Location* in England and 7 *Local Health Boards* in Wales).
#'
#' Built by dissolving the `LSOA` boundaries using the `lookups` table.
#' 
#' @format A `sf` dataframe with only one `CCG` column for the corresponding *ONS* codes.
#'
#' For further details see \url{https://geoportal.statistics.gov.uk/search?collection=Dataset&sort=-modified&tags=all(BDY_CCG)}.
#'
'CCG'

# BOUNDARIES ONS NOT EXACT -------

## PCON ----------------
#' PCONo
#'
#' Digital Vector Boundaries in `sf` format and *WGS84* CRS (*epsg* 4326) for all 573 *Westminster Parliamentary Constituency* in England and Wales.
#' 
#' This is the result of the conversion of the original ONS boundaries in *shapefile* format 
#' with a *OSGB36* CRS (*epsg* 27700), simplified at a *20%* rate.
#' 
#' @format A `sf` dataframe with only one `PCON` column for the corresponding *ONS* codes.
#'
#' For further details see \url{https://geoportal.statistics.gov.uk/search?collection=Dataset&sort=-modified&tags=all(BDY_PCON)}.
#'
'PCONo'

## WARD ----------------
#' WARDo
#'
#' Digital Vector Boundaries in `sf` format and *WGS84* CRS (*epsg* 4326) for all 7,878 *Electoral Ward* in England and Wales.
#'
#' This is the result of the conversion of the original ONS boundaries in *shapefile* format 
#' with a *OSGB36* CRS (*epsg* 27700), simplified at a *20%* rate.
#' 
#' @format A `sf` dataframe with only one `WARD` column for the corresponding *ONS* codes.
#'
#' For further details see \url{https://geoportal.statistics.gov.uk/search?collection=Dataset&sort=-modified&tags=all(BDY_WARD)}.
#'
'WARDo'

## PAR -----------------
#' PARo
#'
#' Digital Vector Boundaries in `sf` format and *WGS84* CRS (*epsg* 4326) for all 11,562 *Civil Parishes and Unparished Communities* in England and Wales.
#'
#' This is the result of the conversion of the original ONS boundaries in *shapefile* format 
#' with a *OSGB36* CRS (*epsg* 27700), simplified at a *20%* rate.
#' 
#' @format A `sf` dataframe with only one `PAR` column for the corresponding *ONS* codes.
#'
#' For further details see \url{https://geoportal.statistics.gov.uk/search?collection=Dataset&sort=-modified&tags=all(BDY_PAR)}.
#'
'PARo'

## CCG -----------------
#' CCGo
#'
#' Digital Vector Boundaries in `sf` format and *WGS84* CRS (*epsg* 4326) for all 113 *Clinical Commissioning Groups* in England and Wales
#' (106 *Sub-ICB Location* in England and 7 *Local Health Boards* in Wales).
#'
#' This is the result of the conversion of the original ONS boundaries in *shapefile* format 
#' with a *OSGB36* CRS (*epsg* 27700), simplified at a *20%* rate.
#' 
#' @format A `sf` dataframe with only one `CCG` column for the corresponding *ONS* codes.
#'
#' For further details see \url{https://geoportal.statistics.gov.uk/search?collection=Dataset&sort=-modified&tags=all(BDY_CCG)}.
#'
'CCGo'
