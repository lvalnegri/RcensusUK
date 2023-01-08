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
#'   \item{\code{ name }}{ A short name for the Domain, reference for the `dt_` datasets }
#'   \item{\code{ description }}{ A possibly longer description for the Domain }
#'   \item{\code{ ordering }}{ The order for presentation }
#'   \item{\code{ loaded }}{ Indicates if the domain has some data actually loaded into the package }
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
#'   \item{\code{ code }}{ The ONS code for the Table. It is *not* a unique identifier for the `dt_*` datasets, as some tables have been splitted. }
#'   \item{\code{ description }}{ A (short) description for the Table (see the field `definition` for more explanation) }
#'   \item{\code{ domain_id }}{ The Domain the table is included into (a foreign key to the column `id` in the `domains` table}
#'   \item{\code{ min_type }}{ The minimum type of geographic hierarchy the data are available (see the column `type` in the `zone_types` table) }
#'   \item{\code{ main_ref }}{ The main reference variable  for all data in the Table (notice that it refers to data in another table)}
#'   \item{\code{ loaded }}{ Indicates if the Table has some data actually loaded into the package }
#'   \item{\code{ ons_url }}{ The direct url for the bulk download of data }
#'   \item{\code{ comp_11 }}{ When not `NA`, indicates a direct comparison with data in the previous 2011 Census }
#'   \item{\code{ definition }}{ A long description for the Table }
#' }
#' 
#' For further details, see the [Nomis website](https://www.nomisweb.co.uk/sources/census_2021)
#'
'tables'

## VARIABLES -----------
#' vars
#'
#' The list of variables with some of their characteristics
#'
#' @format A data.table with the following columns:
#' \describe{
#'   \item{\code{ id }}{ The code for the variables, built from ONS codes and file format }
#'   \item{\code{ prog_id }}{ The *internal* code for the variables, mostly used for ordering }
#'   \item{\code{ description }}{ The description for the variables }
#'   \item{\code{ table_code }}{ The code of the table the variable is included into, a foreign reference to the column `code` in the `tables` dataset }
#'   \item{\code{ level }}{ The depth of reference for the data. All variables with a level of `0` are also grouped together in the `main_refs` table. }
#'   \item{\code{ loaded }}{ Indicates if the values of the variable have actually been loaded into the package }
#' }
#'
#' For further details, see the [Nomis website](https://www.nomisweb.co.uk/sources/census_2021)
#'
'vars'

## VARS REFERENCES -----
#' vars_refs
#'
#' The reference codes for each variable and level of depth (that could also be used as indent for reporting)
#'
#' @format A data.table with the following columns:
#' \describe{
#'   \item{\code{ var_id }}{ The code for the variables }
#'   \item{\code{ level }}{ The depth of reference, with `C` being the *cross* reference }
#'   \item{\code{ ref_id }}{ The code of the reference variable }
#' }
#'
'vars_refs'

## REFERENCES ----------
#' Main References
#' 
#' A convenience table to group all and only the main *reference* Variables, with the substituted codes and the differences in units.
#' 
#' @format A data.table in *long* format with the following columns
#' \describe{
#'   \item{\code{ sub_id }}{ The id for the reference variable in a table }
#'   \item{\code{ main_id }}{ The actual id for the variable in the dataset to refer to  }
#'   \item{\code{ name }}{ A name for the variable, usually shorter than the official one }
#'   \item{\code{ total }}{ The reference Total. There could be different *similar* totals among the various tables, the percentage won't exactly sum to 100.) }
#'   \item{\code{ diff }}{  The difference between the true total of the reference variable in a table and its substitution }
#' }
#' 
'main_refs'

## METRICS -----
#' metrics
#'
#' A listing of binary operations on how to build basic metrics. 
#' Once actioned using the `build_metrics` function, the values are stored for every possible level of geographic hierarchy in the `dt_metrics` table.
#'
#' @format A data.table with the following columns:
#' \describe{
#'   \item{\code{ id }}{ The id for the metric }
#'   \item{\code{ name }}{ The name for the metric }
#'   \item{\code{ var1_id }}{ The id for the *first* variable }
#'   \item{\code{ type1 }}{ The *type* of the *first* variable: `V`ariable or `M`etric }
#'   \item{\code{ var2_id }}{ The id for the *second* variable }
#'   \item{\code{ type2 }}{ The *type* of the *second* variable: `V`ariable or `M`etric }
#'   \item{\code{ ops }}{ The operation to be applied }
#' }
#'
'metrics'

# DATASETS ------------------

## SUMMARIES ----------
#' Summaries
#' 
#' The Totals for all Variables at *Countries* and *Nation* levels.
#' The table also includes the original ONS names for the variables as stated in the deployed files.
#' 
#' @format A data.table with the following columns
#' \describe{
#'   \item{\code{ table_code }}{ The code for the variables, foreign key to the `code` column in the `tables` table }
#'   \item{\code{ var_id }}{ The internal identifier for the Variable, foreign key to the `id` column in the `vars` table }
#'   \item{\code{ ons_name }}{ The name for the Variable as included in the original ONS files }
#'   \item{\code{ E }}{ The total value for the Variable at *England* level }
#'   \item{\code{ W }}{ The total value for the Variable at *Wales* level }
#'   \item{\code{ T }}{ The total value for the Variable at *Nation* (England and Wales) level }
#' }
#' 
'summaries'

## GEOGRAPHY -----------
#' Geographic Properties
#' 
#' Some characteristics about Zones, such as Area, Perimeter, Centroid, ...
#' 
#' This table is *not* part of the ONS Census releases.
#' 
#' @format A data.table in *long* format with the following columns
#' \describe{
#'   \item{\code{ zone_id }}{ The `ONS` identifier for the Zone, foreign key to the `id` column in the `zones` table }
#'   \item{\code{ var_id }}{ The internal identifier for the Variable, foreign key to the `id` column in the `vars` table }
#'   \item{\code{ value }}{ The value for the Variable in the Zone}
#' }
#' 
'dt_geography'

## POPULATION ----------
#' Population and Households
#' 
#' Resident Population and Households, Legal Partnership Status, Living Arrangements,
#' Households by Composition, Size, and Deprivation Dimensions
#' 
#' @format A data.table in *long* format with the following columns
#' \describe{
#'   \item{\code{ zone_id }}{ The `ONS` identifier for the Zone, foreign key to the `id` column in the `zones` table }
#'   \item{\code{ var_id }}{ The internal identifier for the Variable, foreign key to the `id` column in the `vars` table }
#'   \item{\code{ value }}{ The value for the Variable in the Zone}
#' }
#' 
#' Data include the following Census Tables:
#' @format A data.table 
#' \describe{
#'   \item{\code{ TS001 }}{ Number of usual Residents }
#'   \item{\code{ TS002 }}{ Legal Partnership Status }
#'   \item{\code{ TS003 }}{ Household Composition }
#'   \item{\code{ TS017 }}{ Household Size }
#'   \item{\code{ TS010 }}{ Living Arrangements }
#'   \item{\code{ TS011 }}{ Households by Deprivation Dimensions }
#' }
#'
#' For further details, see the [Nomis website](https://www.nomisweb.co.uk/sources/census_2021)
#'
'dt_population'

## SEX AND AGE ---------
#' Sex and Age
#'
#' Resident Population segmented by Sex, Age, and Sex by Age (with Age by single year and five years' classes) 
#' 
#' @format A data.table in *long* format with the following columns
#' \describe{
#'   \item{\code{ zone_id }}{ The `ONS` identifier for the Zone, foreign key to the `id` column in the `zones` table }
#'   \item{\code{ var_id }}{ The internal identifier for the Variable, foreign key to the `id` column in the `vars` table }
#'   \item{\code{ value }}{ The value for the Variable in the Zone}
#' }
#' 
#' @format The dataset includes the following Census Tables:
#' \describe{
#'   \item{\code{ TS007 }}{ Age by single year }
#'   \item{\code{ TS007 }}{ Age by five years' classes }
#'   \item{\code{ TS008 }}{ Sex }
#'   \item{\code{ TS009 }}{ Sex by single year of Age }
#'   \item{\code{ TS009 }}{ Sex by five years' classes of Age }
#' }
#'
#' For further details, see the [Nomis website](https://www.nomisweb.co.uk/sources/census_2021)
#'
'dt_sexage'

##  MIGRATION ----------
#' Migration
#'
#' Resident Population by Country of Birth, Passports held, Year and Age of Arrival in the UK, Length of Residence
#' 
#' @format A data.table in *long* format with the following columns
#' \describe{
#'   \item{\code{ zone_id }}{ The `ONS` identifier for the Zone, foreign key to the `id` column in the `zones` table }
#'   \item{\code{ var_id }}{ The internal identifier for the Variable, foreign key to the `id` column in the `vars` table }
#'   \item{\code{ value }}{ The value for the Variable in the Zone}
#' }
#' 
#' @format The dataset includes the following Census Tables:
#' \describe{
#'   \item{\code{ TS004 }}{ Country of Birth }
#'   \item{\code{ TS012 }}{ Country of Birth (detailed) }
#'   \item{\code{ TS005 }}{ Passports held }
#'   \item{\code{ TS013 }}{ Passports held (detailed) }
#'   \item{\code{ TS015 }}{ Year of arrival in UK }
#'   \item{\code{ TS018 }}{ Age of arrival in the UK }
#'   \item{\code{ TS016 }}{ Length of Residence }
#' }
#'
#' For further details, see the [Nomis website](https://www.nomisweb.co.uk/sources/census_2021)
#'
'dt_migration'

## ETHNICITY -----------
#' Ethnicities and Identities
#'
#' Resident Population by Ethnic Group(s) and National Identity
#' 
#' @format A data.table in *long* format with the following columns
#' \describe{
#'   \item{\code{ zone_id }}{ The `ONS` identifier for the Zone, foreign key to the `id` column in the `zones` table }
#'   \item{\code{ var_id }}{ The internal identifier for the Variable, foreign key to the `id` column in the `vars` table }
#'   \item{\code{ value }}{ The value for the Variable in the Zone}
#' }
#' 
#' @format The dataset includes the following Census Tables:
#' \describe{
#'   \item{\code{ TS021 }}{ Ethnic Group }
#'   \item{\code{ TS022 }}{ Ethnic Group (detailed) }
#'   \item{\code{ TS023 }}{ Multiple Ethnic Group }
#'   \item{\code{ TS027 }}{ National Identity - UK }
#'   \item{\code{ TS028 }}{ National Identity (detailed) }
#' }
#'
#' For further details, see the [Nomis website](https://www.nomisweb.co.uk/sources/census_2021)
#'
'dt_ethnicity'

## LANGUAGE ------------
#' Languages and UK Proficiency
#'
#' Resident Population and Households by main Language(s) spoken and Proficiency in English.
#' 
#' @format A data.table in *long* format with the following columns
#' \describe{
#'   \item{\code{ zone_id }}{ The `ONS` identifier for the Zone, foreign key to the `id` column in the `zones` table }
#'   \item{\code{ var_id }}{ The internal identifier for the Variable, foreign key to the `id` column in the `vars` table }
#'   \item{\code{ value }}{ The value for the Variable in the Zone}
#' }
#' 
#' @format The dataset includes the following Census Tables:
#' \describe{
#'   \item{\code{ TS024 }}{ Main Language (detailed) }
#'   \item{\code{ TS025 }}{ Household Language }
#'   \item{\code{ TS029 }}{ Proficiency in English }
#'   \item{\code{ TS026 }}{ Multiple main Languages in households }
#' }
#'
#' For further details, see the [Nomis website](https://www.nomisweb.co.uk/sources/census_2021)
#'
'dt_language'

## RELIGION ------------
#' Religions
#'
#' Resident Population and Households by professed Religion. 
#' 
#' @format A data.table in *long* format with the following columns
#' \describe{
#'   \item{\code{ zone_id }}{ The `ONS` identifier for the Zone, foreign key to the `id` column in the `zones` table }
#'   \item{\code{ var_id }}{ The internal identifier for the Variable, foreign key to the `id` column in the `vars` table }
#'   \item{\code{ value }}{ The value for the Variable in the Zone}
#' }
#' 
#' @format The dataset includes the following Census Tables:
#' \describe{
#'   \item{\code{ TS030 }}{ Religion }
#'   \item{\code{ TS031 }}{ Religion (detailed) }
#'   \item{\code{ TS075 }}{ Multi Religion households }
#' }
#'
#' For further details, see the [Nomis website](https://www.nomisweb.co.uk/sources/census_2021)
#'
'dt_religion'

## WORK ----------------
#' Work and Commuting
#'
#' Resident Population by Economic Activity Status, Occupation, Industry, National Statistics Socio-economic Classification (NS-SeC),
#' Hours worked, Unemployment history, Method of Travel to Work and Distance travelled.
#' 
#' @format A data.table in *long* format with the following columns:
#' \describe{
#'   \item{\code{ zone_id }}{ The `ONS` identifier for the Zone, foreign key to the `id` column in the `zones` table }
#'   \item{\code{ var_id }}{ The internal identifier for the Variable, foreign key to the `id` column in the `vars` table }
#'   \item{\code{ value }}{ The value for the Variable in the Zone}
#' }
#' 
#' @format The dataset includes the following Census Tables:
#' \describe{
#'   \item{\code{ TS066 }}{ Economic Activity Status }
#'   \item{\code{ TS063 }}{ Occupation }
#'   \item{\code{ TS064 }}{ Occupation - minor groups }
#'   \item{\code{ TS062 }}{ NS-SeC }
#'   \item{\code{ TS060 }}{ Industry }
#'   \item{\code{ TS059 }}{ Hours worked }
#'   \item{\code{ TS065 }}{ Unemployment history }
#'   \item{\code{ TS058 }}{ Distance travelled to Work }
#'   \item{\code{ TS061 }}{ Method of Travel to Work }
#' }
#'
#' For further details, see the [Nomis website](https://www.nomisweb.co.uk/sources/census_2021)
#'
'dt_work'

## HOUSING -------------
#' Housing
#' 
#' Households by Accommodation type, Tenure of Household, Number of Rooms and Bedrooms (total count and Occupancy Rating),
#' Type of Central Heating, Number of Cars or Vans.
#' Resident Population by Second address type, and living in Communal establishment management, segmented by Type, Sex and 10 years Age Classes.
#' 
#' @format A data.table in *long* format with the following columns:
#' \describe{
#'   \item{\code{ zone_id }}{ The `ONS` identifier for the Zone, foreign key to the `id` column in the `zones` table }
#'   \item{\code{ var_id }}{ The internal identifier for the Variable, foreign key to the `id` column in the `vars` table }
#'   \item{\code{ value }}{ The value for the Variable in the Zone}
#' }
#' 
#' @format The dataset includes the following Census Tables:
#' \describe{
#'   \item{\code{ TS044 }}{ Accommodation Type }
#'   \item{\code{ TS054 }}{ Tenure }
#'   \item{\code{ TS051 }}{ Number of Rooms }
#'   \item{\code{ TS053 }}{ Occupancy Rating for Rooms }
#'   \item{\code{ TS050 }}{ Number of Bedrooms }
#'   \item{\code{ TS052 }}{ Occupancy Rating for Bedrooms }
#'   \item{\code{ TS046 }}{ Central Heating }
#'   \item{\code{ TS045 }}{ Car or Van availability }
#' }
#'
#' For further details, see the [Nomis website](https://www.nomisweb.co.uk/sources/census_2021)
#'
'dt_housing'

## EDUCATION -----------
#' Education
#'
#' Waiting for data. Expected by 10th Jan 2023.
#' 
#' @format A data.table in *long* format with the following columns:
#' \describe{
#'   \item{\code{ zone_id }}{ The `ONS` identifier for the Zone, foreign key to the `id` column in the `zones` table }
#'   \item{\code{ var_id }}{ The internal identifier for the Variable, foreign key to the `id` column in the `vars` table }
#'   \item{\code{ value }}{ The value for the Variable in the Zone}
#' }
#' 
#' @format The dataset includes the following Census Tables:
#' \describe{
#' }
#'
#' For further details, see the [Nomis website](https://www.nomisweb.co.uk/sources/census_2021)
#'
'dt_education'

## HEALTH --------------
#' Health
#'
#' Waiting for data. Expected by 19th Jan 2023.
#' 
#' @format A data.table in *long* format with the following columns:
#' \describe{
#'   \item{\code{ zone_id }}{ The `ONS` identifier for the Zone, foreign key to the `id` column in the `zones` table }
#'   \item{\code{ var_id }}{ The internal identifier for the Variable, foreign key to the `id` column in the `vars` table }
#'   \item{\code{ value }}{ The value for the Variable in the Zone}
#' }
#' 
#' @format The dataset includes the following Census Tables:
#' \describe{
#' }
#'
#' For further details, see the [Nomis website](https://www.nomisweb.co.uk/sources/census_2021)
#'
'dt_health'

## GENDER --------------
#' Gender
#'
#' Resident Population by Sexual Orientation and Gender Identity
#' 
#' @format A data.table in *long* format with the following columns:
#' \describe{
#'   \item{\code{ zone_id }}{ The `ONS` identifier for the Zone, foreign key to the `id` column in the `zones` table }
#'   \item{\code{ var_id }}{ The internal identifier for the Variable, foreign key to the `id` column in the `vars` table }
#'   \item{\code{ value }}{ The value for the Variable in the Zone}
#' }
#' 
#' @format The dataset includes the following Census Tables:
#' \describe{
#'   \item{\code{ TS077 }}{ Sexual orientation }
#'   \item{\code{ TS079 }}{ Sexual orientation (detailed) }
#'   \item{\code{ TS078 }}{ Gender identity }
#'   \item{\code{ TS070 }}{ Gender identity (detailed) }
#' }
#'
#' For further details, see the [Nomis website](https://www.nomisweb.co.uk/sources/census_2021)
#'
'dt_gender'

## METRICS ------------
#' dt_metrics
#' 
#' Dataset containing the values of the *metrics* built using the variables and the operations listed in the `metrics` table. 
#' By design, and differently from the other `dt_*` tables (besides the fact that it's *not* part of the ONS Census releases), 
#' the values are given for *all* the geographies as you cannot aggregate values from lower to higher levels of the geographic hierarchy.
#' 
#' @format A data.table in *long* format with the following columns:
#' \describe{
#'   \item{\code{ zone_id }}{ The `ONS` identifier for the Zone, foreign key to the `id` column in the `zones` table }
#'   \item{\code{ var_id }}{ The internal identifier for the Metric, foreign key to the `id` column in the `metrics` table }
#'   \item{\code{ value }}{ The value for the Metric in the Zone}
#' }
#' 
'dt_metrics'


# GEOGRAPHY -----------------

## ZONE TYPES ----------
#' Zone Types
#'
#' A list of all the Geographies included in the package(apart from the *Output Areas*, listed in the `lookups` table)
#'
#' @format A data.table with the following columns:
#' \describe{
#'   \item{\code{type}}{ An acronym for the Geography, used as its `id` throughout }
#'   \item{\code{id}}{ A numeric identifier for the Geography, used mostly for ordering }
#'   \item{\code{name}}{ The Name for the Geography }
#'   \item{\code{level}}{ The level of details of the Geography in terms of hierarchy }
#'   \item{\code{max_child}}{ The `type` of Geography that nest exactly into the current Geography }
#'   \item{\code{min_parent}}{ The `type` of Geography that all the Zones of the current Geography nest exactly into }
#'   \item{\code{nE}}{ The total number of Zones in England }
#'   \item{\code{nW}}{ The total number of Zones in Wales }
#'   \item{\code{nEW}}{ The total number of Zones in England and Wales }
#'   \item{\code{missing}}{ The number of features missing from the packages because of overlapping zones (only for `PAR` and `WARD`) }
#'   \item{\code{is_exact}}{ Indicates if the geography nests exactly into its parent, or the hierarchy is mostly due to spatial approximations }
#'   \item{\code{cbo_filter}}{ The preferred geography to use as interactive filter in apps }
#'   \item{\code{is_frozen}}{ Indicates if the geography is not bound to be changed (in the near future) }
#'   \item{\code{last_update}}{  }
#'   \item{\code{is_census}}{ Indicates if the geography is part of the Census hierarchy }
#'   \item{\code{ons_id}}{ The id of the Geography used by ONS }
#'   \item{\code{ons_code}}{ The column name used by ONS for the ids of the Zones }
#'   \item{\code{ons_name}}{ The column name used by ONS for the names of the Zones }
#'   \item{\code{ons_map_id}}{ The id for the url to download the Full Detailed Boundaries from the ONS Geoportal }
#' }
#'
#' For further details, see \url{https://geoportal.statistics.gov.uk/search?collection=Dataset&sort=name&tags=all(PRD_RGC)} and
#' \url{https://www.arcgis.com/sharing/rest/content/items/0d5d0ad97af04e18bc584e4fc3bc62de/data}
#'
'zone_types'

## ZONES ---------------
#' Zones
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
#'   \item{\code{perimeter}}{ The perimeter }
#'   \item{\code{area}}{ The area }
#'   \item{\code{x_lon}}{ The longitude coordinate of the geometric centroid }
#'   \item{\code{y_lat}}{ The latitude coordinate of the geometric centroid }
#'   \item{\code{px_lon}}{ The longitude coordinate of the pole of inaccessibility }
#'   \item{\code{py_lat}}{ The latitude coordinate of the pole of inaccessibility }
#'   \item{\code{wx_lon}}{ The longitude coordinate of the population weighted centroid }
#'   \item{\code{wy_lat}}{ The latitude coordinate of the population weighted centroid }
#'   \item{\code{bb_xmin}}{ The minimum longitude coordinate of the bounding box surrounding the polygon representing the location }
#'   \item{\code{bb_ymin}}{ The minimum latitude coordinate of the bounding box surrounding the polygon representing the location }
#'   \item{\code{bb_xmax}}{ The maximum longitude coordinate of the bounding box surrounding the the polygon representing the location }
#'   \item{\code{bb_ymax}}{ The maximum latitude coordinate of the bounding box surrounding the the polygon representing the location }
#' }
#'
#' For further details, see the \code{Names and Codes} section within \url{https://geoportal.statistics.gov.uk/}
#'
'zones'

## LOOKUPS -------------
#' Lookups
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

## MISSING -------------
#' Missing Zones
#'
#' This dataset list the lookups for those `PAR` and `WARD` zones missing from the `lookups` table, 
#' because of them being smaller than the *Output Areas* they fall into 
#' but with smaller area of a similar zone competing for the same Output Area 
#' (which is the one comparing in `lookups`).
#'
#' @format A data.table with the following columns:
#' \describe{
#'   \item{\code{ type }}{ The type of the Area, as referenced in the `zone_types` table (either `PAR` or `WARD`) }
#'   \item{\code{ zone_id }}{ The ONS identifier for the Zone }
#'   \item{\code{ OA }}{ The ONS identifier for the Output Area the Zone is included into }
#'   \item{\code{ sibling }}{ The code for the Area that appears in the `lookups` table having the same parent zone}
#'   \item{\code{ parent }}{ The code for the parent zone the Area should belong to }
#' }
#'
'missing'

## NEIGHBOURS ----------
#' Neighbours
#'
#' This dataset contains the *1st order neighbours* for all the Zones listed in the `zones` table. 
#' There are no repetitions in `idB` for `idA`, as obviously any Zone is a neighbour of itself.
#'
#' @format A data.table with the following columns:
#' \describe{
#'   \item{\code{ type }}{ The type of the Zone as referenced in the `zone_types` table }
#'   \item{\code{ idA  }}{ The ONS identifier for a Zone }
#'   \item{\code{ idB  }}{ The ONS identifier for the first order neighbours of the Zone with code `idA`}
#' }
#'
'neighbours'

## POSTCODES -----------
#' postcodes
#'
#' A lookup table between Postcode *Units* (`PCU`) and *Output Areas*.
#' 
#' The table contains all UK *strictly* geographical postcodes, both *live* and *terminated*, as of NOV-22 (2,619,057). 
#' 
#' This table is part of my [RpostcodesUK $R$ package](https://github.com/lvalnegri/RpostcodesUK). 
#' It's been included here only for search purposes, and it's not part of any ONS Census releases.
#' 
#' @format A data.table with the following columns:
#' \describe{
#'   \item{\code{ PCU }}{ A Postcode Unit, expressed in 7-chars form (see the `clean_pcu` function)}
#'   \item{\code{ OA }}{ The ONS code for an Output Areas }
#' }
#'
#' For further official details on UK postcodes, see the *ONS Postcodes* tagged pages of the 
#' [ONS Open Geography portal](https://geoportal.statistics.gov.uk/search?collection=Dataset&q=postcodes&sort=-created&tags=onspd). 
#' 
'postcodes'

## LOCALITIES ----------
#' localities
#'
#' The list of all known Locality in England and Wales, and the corresponding *Output Areas* they're in.
#' 
#' The table contains *all* UK geographical postcodes, both *live* and *terminated* (2,334,674, as of NOV-22). 
#' 
#' Last Updated: Dec-21
#' 
#' @format A data.table with the following columns:
#' \describe{
#'   \item{\code{ LOC }}{ The unique ONS code for the Location }
#'   \item{\code{ LOCd }}{ The description for the Location }
#'   \item{\code{ LOCo }}{ A description suitable for ordering }
#'   \item{\code{ x_lon}}{ The longitude coordinate of the Location }
#'   \item{\code{ y_lat}}{ The latitude coordinate of the Location }
#'   \item{\code{ OA }}{ The ONS code for the Output Areas that includes the Location}
#' }
#'
#' For further details, see the *Index of Place Names in Great Britain* page of the 
#' [ONS Open Geography portal](https://geoportal.statistics.gov.uk/datasets/index-of-place-names-in-great-britain-december-2022/about). 
#' 
'localities'

#' @import sf
NULL

# BOUNDARIES ----------------

## OA ------------------
#' OA
#'
#' Digital Vector Boundaries in `sf` format and *WGS84* CRS (*EPSG* 4326) for all 188,880 *Output Areas* in England and Wales, **Census 2021**.
#'
#' @format A `sf` dataframe with only one `OA` column for the corresponding *ONS* codes.
#'
#' For further details see \url{https://geoportal.statistics.gov.uk/search?collection=Dataset&sort=-modified&tags=all(BDY_OA)}.
#'
'OA'

## LSOA ----------------
#' LSOA
#'
#' Digital Vector Boundaries in `sf` format and *WGS84* CRS (*EPSG* 4326) for all 35,672 *Lower Layer Super Output Areas* in England and Wales, **Census 2021**.
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
#' Digital Vector Boundaries in `sf` format and *WGS84* CRS (*EPSG* 4326) for all 7,264 *Medium Layer Super Output Areas* in England and Wales, **Census 2021**.
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
#' Digital Vector Boundaries in `sf` format and *WGS84* CRS (*EPSG* 4326) for all 331 *Lower Tier Local Authorities* in England and Wales.
#'
#' Built by dissolving the `MSOA` boundaries using the `lookups` table.
#' 
#' Last Updated: Dec-22
#' 
#' @format A `sf` dataframe with only one `LTLA` column for the corresponding *ONS* codes.
#'
#' For further details see \url{https://geoportal.statistics.gov.uk/search?collection=Dataset&sort=-modified&tags=all(BDY_LTLA)}.
#'
'LTLA'

## UTLA ----------------
#' UTLA
#'
#' Digital Vector Boundaries in `sf` format and *WGS84* CRS (*EPSG* 4326) for all 174 *Upper Tier Local Authorities* in England and Wales.
#'
#' Built by dissolving the `LTLA` boundaries using the `lookups` table.
#' 
#' Last Updated: Dec-22
#' 
#' @format A `sf` dataframe with only one `UTLA` column for the corresponding *ONS* codes.
#'
#' For further details see \url{https://geoportal.statistics.gov.uk/search?collection=Dataset&sort=-modified&tags=all(BDY_UTLA)}.
#'
'UTLA'

## RGN -----------------
#' RGN
#'
#' Digital Vector Boundaries in `sf` format and *WGS84* CRS (*EPSG* 4326) for all 9 *Regions* in England, plus Wales.
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
#' Digital Vector Boundaries in `sf` format and *WGS84* CRS (*EPSG* 4326) for England, plus Wales.
#'
#' Built by dissolving the `RGN` boundaries using the `lookups` table.
#' 
#' @format A `sf` dataframe with only one `CTRY` column for the corresponding *ONS* codes.
#'
#' For further details see \url{https://geoportal.statistics.gov.uk/search?collection=Dataset&sort=-modified&tags=all(BDY_CTRY)}.
#'
'CTRY'

## PCON ----------------
#' PCON
#'
#' Digital Vector Boundaries in `sf` format and *WGS84* CRS (*EPSG* 4326) for all 573 *Westminster Parliamentary Constituency* in England and Wales.
#'
#' Built by dissolving the `LSOA` boundaries using the `lookups` table.
#' 
#' Last Updated: Dec-21
#' 
#' @format A `sf` dataframe with only one `PCON` column for the corresponding *ONS* codes.
#'
#' For further details see \url{https://geoportal.statistics.gov.uk/search?collection=Dataset&sort=-modified&tags=all(BDY_PCON)}.
#'
'PCON'

## WARD ----------------
#' WARD
#'
#' Digital Vector Boundaries in `sf` format and *WGS84* CRS (*EPSG* 4326) for all 7,878 *Electoral Ward* in England and Wales.
#'
#' Built by dissolving the `OA` boundaries using the `lookups` table.
#' 
#' Last Updated: Dec-22
#' 
#' @format A `sf` dataframe with only one `WARD` column for the corresponding *ONS* codes.
#'
#' For further details see \url{https://geoportal.statistics.gov.uk/search?collection=Dataset&sort=-modified&tags=all(BDY_WARD)}.
#'
'WARD'

## PAR -----------------
#' PAR
#'
#' Digital Vector Boundaries in `sf` format and *WGS84* CRS (*EPSG* 4326) for all 11,562 *Civil Parishes and Unparished Communities* in England and Wales.
#'
#' Built by dissolving the `OA` boundaries using the `lookups` table.
#' 
#' Last Updated: Dec-22
#' 
#' @format A `sf` dataframe with only one `PAR` column for the corresponding *ONS* codes.
#'
#' For further details see \url{https://geoportal.statistics.gov.uk/search?collection=Dataset&sort=-modified&tags=all(BDY_PAR)}.
#'
'PAR'

## CCG -----------------
#' CCG
#'
#' Digital Vector Boundaries in `sf` format and *WGS84* CRS (*EPSG* 4326) for all 113 *Clinical Commissioning Groups* in England and Wales
#' (106 *Sub-ICB Location* in England and 7 *Local Health Boards* in Wales).
#'
#' Built by dissolving the `LSOA` boundaries using the `lookups` table.
#' 
#' Last Updated: Jul-22 for England, Apr-22 for Wales.
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
#' Digital Vector Boundaries in `sf` format and *WGS84* CRS (*EPSG* 4326) for all 573 *Westminster Parliamentary Constituency* in England and Wales.
#' 
#' This is the result of the conversion of the original ONS boundaries in *shapefile* format 
#' with a *OSGB36* CRS (*EPSG* 27700), simplified at a *20%* rate.
#' 
#' Last Updated: Dec-20
#' 
#' @format A `sf` dataframe with only one `PCON` column for the corresponding *ONS* codes.
#'
#' For further details see \url{https://geoportal.statistics.gov.uk/search?collection=Dataset&sort=-modified&tags=all(BDY_PCON)}.
#'
'PCONo'

## WARD ----------------
#' WARDo
#'
#' Digital Vector Boundaries in `sf` format and *WGS84* CRS (*EPSG* 4326) for all 7,878 *Electoral Ward* in England and Wales.
#'
#' This is the result of the conversion of the original ONS boundaries in *shapefile* format 
#' with a *OSGB36* CRS (*EPSG* 27700), simplified at a *20%* rate.
#' 
#' Last Updated: Dec-21
#' 
#' @format A `sf` dataframe with only one `WARD` column for the corresponding *ONS* codes.
#'
#' For further details see \url{https://geoportal.statistics.gov.uk/search?collection=Dataset&sort=-modified&tags=all(BDY_WARD)}.
#'
'WARDo'

## PAR -----------------
#' PARo
#'
#' Digital Vector Boundaries in `sf` format and *WGS84* CRS (*EPSG* 4326) for all 11,562 *Civil Parishes and Unparished Communities* in England and Wales.
#'
#' This is the result of the conversion of the original ONS boundaries in *shapefile* format 
#' with a *OSGB36* CRS (*EPSG* 27700), simplified at a *20%* rate.
#' 
#' Last Updated: Dec-22
#' 
#' @format A `sf` dataframe with only one `PAR` column for the corresponding *ONS* codes.
#'
#' For further details see \url{https://geoportal.statistics.gov.uk/search?collection=Dataset&sort=-modified&tags=all(BDY_PAR)}.
#'
'PARo'

## CCG -----------------
#' CCGo
#'
#' Digital Vector Boundaries in `sf` format and *WGS84* CRS (*EPSG* 4326) for all 113 *Clinical Commissioning Groups* in England and Wales
#' (106 *Sub-ICB Location* in England and 7 *Local Health Boards* in Wales).
#'
#' This is the result of the conversion of the original ONS boundaries in *shapefile* format 
#' with a *OSGB36* CRS (*EPSG* 27700), simplified at a *20%* rate.
#' 
#' Last Updated: Apr-22
#' 
#' @format A `sf` dataframe with only one `CCG` column for the corresponding *ONS* codes.
#'
#' For further details see \url{https://geoportal.statistics.gov.uk/search?collection=Dataset&sort=-modified&tags=all(BDY_CCG)}.
#'
'CCGo'
