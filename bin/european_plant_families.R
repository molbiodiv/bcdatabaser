# R script by Andreas Kolter to get european plant families via gbif

# a related script can be found here: http://sacrevert.blogspot.com/2018/04/creating-country-checklists-using-gbif.html

european_plant_families <- function(pl_family_unique)
{
  library(rgbif)
 
  fam_u <- pl_family_unique
  keeper <- vector(length=length(fam_u),mode="logical")
  #http://arthur-e.github.io/Wicket/sandbox-gmaps3.html
  WKT_europe <- "POLYGON((3.427734375 56.69485488778099,18.28125 56.69485488778099,18.28125 43.75839933647409,3.427734375 43.75839933647409,3.427734375 56.69485488778099))"
 
 
  for (i in 1:length(fam_u))
  {
    family_id <- name_backbone(name=fam_u[i],kingdom="Plantae")$usageKey
    
    #check occurrences in europe
    germany_neigh <- occ_data(taxonKey=family_id,geometry=WKT_europe,hasCoordinate = T,
                              limit=0,hasGeospatialIssue=F)$meta$count
    if (germany_neigh<10) next
    
    #check globally
    all_occ <- occ_data(taxonKey=family_id,hasCoordinate=T,limit=0,hasGeospatialIssue=F)$meta$count
    
    if (all_occ<10) next
    
    if ( (germany_neigh/all_occ>0.1)|(germany_neigh>100) ) keeper[i] <- T
   if (i %% 10 == 0) print(i)
  }
  fam_u[keeper%>%as.logical]
        
}
