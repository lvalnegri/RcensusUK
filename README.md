# RcensusUK

### Datasets




### Boundaries

Included in the package are quite a few boundaries and corresponding Names and lookups, that we can divide in two main hierarchies:

#### Census Boundaries

- [`OA` Output Areas ](https://geoportal.statistics.gov.uk/search?collection=Dataset&sort=name&tags=all(BDY_OA%2CDEC_2021)) (`n = 188,880`)
- [`LSOA` Lower-Layer Super Output Areas](https://geoportal.statistics.gov.uk/search?collection=Dataset&sort=name&tags=all(BDY_OA%2CDEC_2021)) 
  (`n = 35,672`)
- [`MSOA` Middle-Layer Super Output Areas](https://geoportal.statistics.gov.uk/search?collection=Dataset&sort=name&tags=all(BDY_OA%2CDEC_2021))
   (`n = 7,264`)
- `LTLA` Lower-Tier Local Authorities (`n = 331`)
- `UTLA` Upper-Tier Local Authorities (`n = 174`)
- `RGN` Regions (`n = 9 + 1`)
- `CTRY` Countries (`n = 2`)

The process requires first to download the original OA boundaries from the ONS as [Full Clipped EW (BFC)]() and [Generalised Clipped EW (BGC)](), The former format is kept as is for geographical operations, while the latter is simplified at 20%, and included in the package in a transformed WGS84 CRS ([EPSG:4326]()).

The other boundaries are obtained by using the lookup tables [OA to LSOA and MSOA]() and [OA to LTLA to UTLA to RGN to CTRY](), then dissolve a simplfied version at 20% of the ONS boundaries with WGS84 CRS.

#### non-Census Boundaries

These are hierarchies not related to Census, but anyway important. The connection between them is made using "max area in polygon", where each OA is overlayered to the hierarchy and associated with the zone who covers most of the OA area.

- [`PCON` ]() (`n = 650`, Dec-21)
- [`WARD` ]() (`n = `, Dec-22)
- [`PAR` ]() (`n = `, Dec-22)
- [`CCG` ]() (`n = `, Apr-22)



