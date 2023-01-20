# RcensusUK

Data and functionalities for querying and mapping related to the UK Census 2021.

As of Jan-23, data at *small area* level are available only for England and Wales. 

The package at the moment only contains organized data and boundaries.


## Datasets

The following are the *domains* in which data are partitioned into, at some finer degree than the ones set out by the [ONS](https://www.nomisweb.co.uk/sources/census_2021_bulk), with the name of the associated `data.table` in the package, and the list of corresponding ONS tables. 

If not detailed otherwise, all data included in each table is available (only) for the smallest possible `OA` *Output Area* level (while working to include functions to query data, see below how to get data for upper levels).

For detailed information about all the included variables, see the data.table `vars`, while in the `summaries` data.table you can find the Nation's and Countries' totals. 

### Population `dt_population`
- *TS001* Number of usual residents
- *TS002* Legal Partnership Status
- *TS006* Population density
- *TS003* Household composition
- *TS017* Household size
- *TS010* Living arrangements [`MSOA`]
- *TS011* Households by deprivation dimensions

### Sex and Age `dt_sexage`
- *TS007* Age [`MSOA`]
- *TS008* Sex
- *TS009* Sex by Age [`LTLA`]

### Migration `dt_migration`
- *TS004* Country of birth
- *TS012* Country of birth (detailed) [`LTLA`]
- *TS005* Passports held
- *TS013* Passports held (detailed) [`MSOA`]
- *TS015* Year of arrival in UK
- *TS018* Age of arrival in the UK
- *TS016* Length of residence
- *TS019* Migrant Indicator
- *TS020* Number of non-UK short-term residents by sex
- *TS041* Number of Households

### Ethnicity `dt_ethnicity`
- *TS021* Ethnic group
- *TS022* Ethnic group (detailed) [`MSOA`]
- *TS023* Multiple ethnic group
- *TS027* National identity - UK
- *TS028* National identity (detailed) [`MSOA`]

### Language `dt_language`
- *TS024* Main language (detailed) [`LTLA`]
- *TS025* Household language
- *TS029* Proficiency in English
- *TS026* Multiple main languages in households

### Religion `dt_religion`
- *TS030* Religion
- *TS031* Religion (detailed) [`MSOA`]
- *TS075* Multi Religion households

### Work `dt_work`
- *TS066* Economic Activity Status
- *TS063* Occupation
- *TS064* Occupation - minor groups [`MSOA`]
- *TS062* NS-SeC
- *TS060* Industry [`MSOA`]
- *TS059* Hours worked
- *TS065* Unemployment History
- *TS058* Distance travelled to Work
- *TS061* Method of Travel to Work

### Housing `dt_housing`
- *TS044* Accommodation type
- *TS054* Tenure
- *TS051* Number of rooms
- *TS053* Occupancy rating for rooms
- *TS050* Number of bedrooms
- *TS052* Occupancy rating for bedrooms
- *TS046* Central heating
- *TS045* Car or van availability

### Gender and Identity `dt_gender`
- *TS077* Sexual orientation [`MSOA`]
- *TS079* Sexual orientation (detailed) [`LTLA`]
- *TS078* Gender identity [`MSOA`]
- *TS070* Gender identity (detailed) [`LTLA`]

### Education `dt_education`
- *TS067* Highest level of qualification
- *TS068* Schoolchildren and full-time students

### Health and Care `dt_health`
- *TS037* General health
- *TS038* Disability 
- *TS039* Provision of unpaid care
- *TS040* Number of disabled people in household"


## Geography

As detailed above, the data are provided only for the lower level available from the ONS, commonly this is the lowest small area `OA`. Using the table `lookups` for the matches, and the table `zone_types` for the correct parent and child, it is easy to obtain by simple sum the correct figures for all the Zones in upper levels.

The package also contains the following self-describing tables, mainly for search purposes in applications:
- `postcodes`, which includes the lookups between the 2.620 millions *postcodes units* (`PCU`) in the UK. For more details see the [ONS Postcode Directory](https://geoportal.statistics.gov.uk/search?collection=Dataset&sort=-created&tags=all(PRD_ONSPD)) on the [ONS Geography Portal](https://geoportal.statistics.gov.uk/), or my other package [RpostcodesUK](https://github.com/lvalnegri/RpostcodesUK)
- `localities`, a list of all *Places* in England and Wales. For more details see the [Index of Place Names](https://geoportal.statistics.gov.uk/datasets/index-of-place-names-in-great-britain-december-2022/about) on the [ONS Geography Portal](https://geoportal.statistics.gov.uk/). 

Finally, the table `neighbours` contains all the adjacent Zones for each Zone in each hierarchy, as an aid for some simple spatial analysis.

## Boundaries

Included in the package are quite a few boundaries and corresponding Names and Lookups tables, that we can divide in two main hierarchies:

### Census Boundaries

The Census Hierrachy consists of the following items, each perfectly nesting into each other:
- [`OA` Output Areas ](https://geoportal.statistics.gov.uk/search?collection=Dataset&sort=name&tags=all(BDY_OA%2CDEC_2021)) (`n = 178,605 + 10,275 = 188,880`)
- [`LSOA` Lower-Layer Super Output Areas](https://geoportal.statistics.gov.uk/search?collection=Dataset&sort=name&tags=all(BDY_OA%2CDEC_2021)) 
  (`n = 33,755 + 1,917 = 35,672`)
- [`MSOA` Middle-Layer Super Output Areas](https://geoportal.statistics.gov.uk/search?collection=Dataset&sort=name&tags=all(BDY_OA%2CDEC_2021))
   (`n = 6,856 + 408 = 7,264`)
- `LTLA` Lower-Tier Local Authorities (`n = 309 + 22 = 331`)
- `UTLA` Upper-Tier Local Authorities (`n = 152 + 22 = 174`)
- `RGN` Regions (`n = 9 + 1 = 10`)
- `CTRY` Countries (`n = 2`)

The process requires first to download the original OA boundaries from the ONS as [Full Clipped EW (BFC)](https://geoportal.statistics.gov.uk/maps/output-areas-dec-2021-boundaries-full-clipped-ew-bfc) and [Generalised Clipped EW (BGC)](https://geoportal.statistics.gov.uk/maps/output-areas-dec-2021-boundaries-generalised-clipped-ew-bgc), then the former format is kept as is for geographical operations, while the latter is simplified at 20%, and included in the package in a transformed *WGS84* reference system ([EPSG:4326](https://epsg.io/4326)).

The other boundaries are obtained by using the lookup tables [OA to LSOA and MSOA](https://geoportal.statistics.gov.uk/datasets/output-area-to-lower-layer-super-output-area-to-middle-layer-super-output-area-to-local-authority-district-december-2021-lookup-in-england-and-wales-v2-1) and [OA to LTLA to UTLA to RGN to CTRY](https://geoportal.statistics.gov.uk/datasets/output-area-to-upper-tier-local-authorities-december-2021-lookup-in-england-and-wales-1) to dissolve the above simplified version of *Output Areas.


### Non-Census Boundaries
These are hierarchies not directly related to ONS Census products, but anyway important for some purposes. The spatial operation used to build the lookups against the Output Areas, is *max area in polygon*, where the OA boundary is overlayered to the hierarchy and each OA is associated with the Zone who covers most of the area (this is considered to be a safer process than the more classic *point in polygon* operation, as in the latter the centroid of the zone for the finer hierarchy does not even necessary fall inside the correspondent zones).

- [`PCON` Westminster Parliamentary Constituency]() `n = 533 + 40 = 573`, last updated Dec-21
- [`WARD` Wards](https://geoportal.statistics.gov.uk/maps/wards-december-2022-boundaries-gb-bfc) `n = 6904 + 762 = 7666` (with 14 *missing* in the lookups in England only), last updated Dec-22
- [`PAR` Parished and Non Civil Parished](https://geoportal.statistics.gov.uk/datasets/parishes-and-non-civil-parished-areas-december-2022-ew-bfc) `n = 10689 + 878 = 11567` (with 1,022 *missing* in the lookups in England only), last updated Dec-22
- `CCG` Clinical Commisioning Group, 
  as  [`LOC` Sub Integrated Care Board Locations](https://geoportal.statistics.gov.uk/maps/sub-integrated-care-board-locations-july-2022-en-bfc) in England `n = 106`, last updated Jul-22, 
  and [Local Health Boards](https://geoportal.statistics.gov.uk/maps/local-health-boards-april-2022-wa-bfc-1) in Wales `n = 7`, last updated Apr-22, for a total of `113`


## Attributions
 - Contains OS data © Crown copyright and database rights 2023 
 - Source: Office for National Statistics licensed under the [Open Government Licence v.3.0](http://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/)
 - Contains Parliamentary information licensed under the [Open Parliament Licence v3.0](https://www.parliament.uk/site-information/copyright/open-parliament-licence/)
