#gbif.R::
#query species occurrence data from GBIF
#clean up the data
#save it as a CSV file
#create a map to display the species occurrence points

# list of packages to install
packages<-c("tidyverse","rgbif","usethis","CoordinateCleaner","leaflet","mapview", "webshot2")

# install packages not yet installed
installed_packages<-packages %in% rownames(installed.packages())
if(any(installed_packages==FALSE)){
  install.packages(packages[!installed_packages])
}

# packages loading, with library function
invisible(lapply(packages, library, character.only=TRUE))

# create new .Renviron file
usethis::edit_r_environ()

spiderBackbone<-name_backbone(name="Habronattus americanus")
speciesKey<-spiderBackbone$usageKey

occ_download(pred("taxonKey", speciesKey), format="SIMPLE_CSV")

<<gbif download>>
# Your download is being processed by GBIF:
  https://www.gbif.org/occurrence/download/0012231-240202131308920
Most downloads finish within 15 min.
Check status with
occ_download_wait('0012231-240202131308920')
After it finishes, use
to retrieve your download.
Download Info:
  Username: mairint
E-mail: lc20-0309@lclark.edu
Format: SIMPLE_CSV
Download key: 0012231-240202131308920
Created: 2024-02-13T20:23:42.744+00:00
Citation Info:  
  Please always cite the download DOI when using this data.
https://www.gbif.org/citation-guidelines
DOI: 10.15468/dl.f5zs9z
Citation:
  GBIF Occurrence Download https://doi.org/10.15468/dl.f5zs9z Accessed from R via rgbif (https://github.com/ropensci/rgbif) on 2024-02-13
Connected to your session in progress, last started 2024-Feb-13 20:15:55 UTC (10 minutes ago)

# download the download to computer
d <- occ_download_get('0012231-240202131308920', path="data/") %>%
  occ_download_import()

# make copy of d dataset as csv file
write_csv(d, "data/rawdata.csv")

# data cleaning !!
fData<-d %>%
  filter(!is.na(decimalLatitude), !is.na(decimalLongitude))

fData<-fData %>%
  filter(countryCode %in% c("US", "CA", "MX"))

fData<-fData %>%
  filter(!basisOfRecord %in% c("FOSSIL_SPECIMEN", "LIVING_SPECIMEN"))

fData<-fData %>%
  cc_sea(lon="decimalLongitude", lat="decimalLatitude")

# remove duplicates
fData<-fData %>%
  distinct(decimalLongitude, decimalLatitude, speciesKey, datasetKey, .keep_all = TRUE)

# one fell swoop:
#cleanData<-d %>%
  #filter(!is.na(decimalLatitude), !is.na(decimalLongitude))
  #filter(countryCode %in% c("US", "CA", "MX"))
  #filter(!basisOfRecord %in% c("FOSSIL_SPECIMEN", "LIVING_SPECIMEN"))
  #cc_sea(lon="decimalLongitude", lat="decimalLatitude")
  #distinct(decimalLongitude, decimalLatitude, speciesKey, datasetKey, .keep_all = TRUE)
  

# save data as a csv file
write.csv(fData, "data/cleanedData.csv")








