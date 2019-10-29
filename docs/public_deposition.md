# Public deposition of BCdatabaser created datasets

# Full dataset DOI assignment

Complete datasets can be directly publicly deposited at [Zenodo.org](Zenodo.org) using BCdatabaser. 
This includes all the files, including additional information and the taxonomic distribution charts. 
This allows citation of the database as a dataset in publications by referencing the DOI. 

## Web-Interface

Databases created with the web-interface will be automatically made public at Zenodo.org with an unique DOI. 
The user logged into the web frontend by ORCID will be associated with the dataset as author. 

## Command line

Also command line created databases can be pushed to Zenodo, provided that the User creates and provides an own Zenodo access token ([see here](https://developers.zenodo.org/#introduction)).
This token can be provided with the parameter ```--zenodo-token-file```.

# Further deposition in sequence databases

For better discoverability, we also recommend to publicly deposit data additionally in one of the INSDC databases. 
In these databases, the reference database can also be deposited in a bundle with the actual sequencing data for which it was used, for example in a BioProject.
Further additional metadata can be directly deposited, which allows better findability. 
* (NCBI)[https://www.ncbi.nlm.nih.gov/bioproject/] 
* (DDBJ)[http://trace.ddbj.nig.ac.jp/bioproject/index_e.html]
* (EMBL-EBI)[http://www.ebi.ac.uk/ena/about/formats]
