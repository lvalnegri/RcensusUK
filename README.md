# RcensusUK

Data, metadata, digital vector boundaries, and functionalities for querying and mapping related to the UK Census 2021.

As of Jan-23, data at *small area* level are available only for England and Wales. 

The package at the moment only contains metadata, organized data, geographic references, and boundaries. Other functionalities will (hopefully) follow.


## Installation
Being more than 3GB in size, `RcensusUK` is not available on CRAN, and probably never will be.

You can only install it from here using:
```
# install.packages('devtools')
devtools::install_github('lvalnegri/RcensusUK)
```


## Datasets

All data values from the Census are contained in *data.tables* with lower-case names starting with `dt_`. All other objects in lower-case are metadata and geography *data.tables*, while objects in upper-case are all boundaries in *sf* format.

If not detailed otherwise, see the list below or the table `tables`, all data included in each table is available (only) for the smallest possible `OA` *Output Area* level (while working to include functions to query data, see below how to get data for upper levels).

For detailed information about all the included variables, see the table `vars`, while in the `summaries` table you can find the Nation's and Countries' totals. 

The table `vars_refs` allows to query the *reference* upper level(s) variable(s) for each lower level(s) variable(s), so that it is possible to create proper proportions and rates. You also need the table `main_refs` if you want to exactly *square* all included data, which I don't think it's necessary for most purposes. 

The following lists display: 
- the *domains* in which all *univariate* data are partitioned into, at some finer degree than the ones set out by the [ONS](https://www.nomisweb.co.uk/sources/census_2021_bulk)
- the name of the associated `dt_` *data.table* in the package
- the list of corresponding ONS tables in the domain
- the smallest available level when different from `OA`, one in [`MSOA`] or [`LTLA`]

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

All names and geographic characteristics for each Zone in all hierarchies are listed in the `zones` table. In particular:
- `LSOA` and `MSOA` names are not the originals from ONS, but they correspond to the more readable format released by the [House of Commons Library](https://houseofcommonslibrary.github.io/msoanames/)
- the coordinates listed as `w` are the simple *weighted* centroids, calculated using the total population in micro grid of 30 meters provided by the [Meta Data For Good project](https://dataforgood.facebook.com/dfg/tools/high-resolution-population-density-maps)
- the coordinates listed as `p` describe the [Visual Center](https://blog.mapbox.com/a-new-algorithm-for-finding-a-visual-center-of-a-polygon-7c77e6492fbc) or [Pole of Inaccessibility](https://inaccessibility.net/), "the location in a geographical area that is the furthest away from all its borders". This point is useful in mapping as it is often the best location to put a text label or a tooltip on a polygon to minimize the risks of overlapping and improve readability.

Because `WARD` and in a greater extent `PAR` are sometimes smaller than `OA`, some of them are *missing* from the lookups, as more than one Zone is deemed to be part of a single `OA`. The `lookups` table only reference the Zone with the greater covered area, leaving to the `missing` table to list the other conflicting Zones. This also obviously implies that on these Zones the values of Census data are *not* exact (I'll probably add for completeness a general table with all the correct values for these Zones when ONS will publish them).

The package also contains the following self-describing tables, mainly for search purposes in applications:
- `postcodes`, which includes the lookups between the 2.620 millions *postcodes units* (`PCU`) in the UK and the `OA`. For more details see the [ONS Postcode Directory](https://geoportal.statistics.gov.uk/search?collection=Dataset&sort=-created&tags=all(PRD_ONSPD)) on the [ONS Geography Portal](https://geoportal.statistics.gov.uk/), official publisher of the lookups, or my other package [RpostcodesUK](https://github.com/lvalnegri/RpostcodesUK) that also include lookups and boundaries for the upper levels of the *Postal* hierarchy: Postcode *Sectors*, Postcode *Districts*, *Post Towns*, Postcode *Areas*.
- `localities`, a list of all *Places* in England and Wales. For more details see the [Index of Place Names](https://geoportal.statistics.gov.uk/datasets/index-of-place-names-in-great-britain-december-2022/about).

Finally, the table `neighbours` contains all the adjacent Zones for each Zone in each hierarchy, as an aid for some simple spatial analysis.


## Boundaries

Included in the package are quite a few Digital Vector Boundaries, that only include the ONS code of each Zone, so that they need to be joined with data and metadata from some of the above tables.

They can be partitioned in the following two main hierarchies:

### Census Boundaries

The Census Hierarchy consists of the following items, each perfectly nesting into each other from the lower level `OA` up to `CTRY`:
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

The other boundaries are obtained by using the lookup tables [OA to LSOA and MSOA](https://geoportal.statistics.gov.uk/datasets/output-area-to-lower-layer-super-output-area-to-middle-layer-super-output-area-to-local-authority-district-december-2021-lookup-in-england-and-wales-v2-1) and [OA to LTLA to UTLA to RGN to CTRY](https://geoportal.statistics.gov.uk/datasets/output-area-to-upper-tier-local-authorities-december-2021-lookup-in-england-and-wales-1) to *dissolve* the above simplified version of *Output Areas.


### Non-Census Boundaries

This is a hierarchy with elements not directly related to ONS Census products, but anyway important for some purposes. The spatial operation used to build the lookups against the *Output Areas*, is *max area in polygon*, where the `OA` boundary is overlayered to the hierarchy and each OA is associated with the Zone who covers most of the area (this is considered to be a safer process than the more classic *point in polygon* operation, as in the latter the centroid of the zone for the finer hierarchy does not even necessary fall inside the correspondent zones).

- [`PCON` Westminster Parliamentary Constituencies](https://geoportal.statistics.gov.uk/maps/westminster-parliamentary-constituencies-dec-2021-uk-bfc) `n = 533 + 40 = 573`, last updated Dec-21
- [`WARD` Wards](https://geoportal.statistics.gov.uk/maps/wards-december-2022-boundaries-gb-bfc) `n = 6904 + 762 = 7666` (with 14 *missing* in the lookups in England only), last updated Dec-22
- [`PAR` Parished and Non Civil Parished Areas](https://geoportal.statistics.gov.uk/datasets/parishes-and-non-civil-parished-areas-december-2022-ew-bfc) `n = 10689 + 878 = 11567` (with 1,022 *missing* in the lookups in England only), last updated Dec-22
- `CCG` Clinical Commissioning Group, 
  as  [`LOC` Sub Integrated Care Board Locations](https://geoportal.statistics.gov.uk/maps/sub-integrated-care-board-locations-july-2022-en-bfc) in England `n = 106`, last updated Jul-22, 
  and [Local Health Boards](https://geoportal.statistics.gov.uk/maps/local-health-boards-april-2022-wa-bfc-1) in Wales `n = 7`, last updated Apr-22, for a total of `113`

Do notice that these are *NOT* official boundaries, although the *child* level listed in the `zone_types` table nests exactly in each Zone which in turn nests exactly in its parent (at least when confronting with the codes included in the `lookups` table only), and there is some statistical errors involved when dealing with them, in particular `PAR` and to less extent `WARD`.


## Attributions
 - Contains OS data © Crown copyright and database rights 2023 
 - Source: Office for National Statistics licensed under the [Open Government Licence v.3.0](http://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/)
 - Contains Parliamentary information licensed under the [Open Parliament Licence v3.0](https://www.parliament.uk/site-information/copyright/open-parliament-licence/)
 - Facebook Connectivity Lab and Center for International Earth Science Information Network - CIESIN - Columbia University. 2016. High Resolution Settlement Layer (HRSL). Source imagery for HRSL © 2016 DigitalGlobe. Accessed 15 Dec 2022."
