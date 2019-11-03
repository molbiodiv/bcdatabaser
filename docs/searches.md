[back to the index](./index.md)

# How is the NCBI data searched?
{:.no_toc}

* TOC list
{:toc}

## NCBI query string

NCBI allows for advanced searches with a specific search syntax as [described in detail in their handbook](https://www.ncbi.nlm.nih.gov/books/NBK49540/).

## Construction from user data
From the user provided parameters a search query string is constructed as follows:

```
(<SEARCH_STRING>) AND <TAXONOMIC_SCOPE>[ORGN] AND <LENGTH_RANGE>[SLEN] NOT gbdiv est[prop] NOT gbdiv gss[prop] NOT patent NOT environmental NOT unverified
```
so your search string, taxonomic scope and length range are used as provided.
Additionally the search excludes est and gss data sets as well as patented, environmental and unverified sequences.

## Example
A query string from the web interface with the `rbcL` preset and *Bellis* as taxonomic scope would be:
```
(rbcL OR 'ribulose-1,5-bisphosphate carboxylase/oxygenase large subunit') AND Bellis[ORGN] AND 100:2000[SLEN] NOT gbdiv est[prop] NOT gbdiv gss[prop] NOT patent NOT environmental NOT unverified
```

## Taxa List File
If a taxa list file is provided the following part is added to the search string right after the taxonomic scope:
```
AND (<LINE1>[ORGN] OR <LINE2>[ORGN] OR <LINE3>[ORGN] OR <LINE4>[ORGN] OR <LINE5>[ORGN] OR ...)
```

so in a real case this could look like this, for an example taxa list file:
```
Bellis perennis
Brassica napus
Dionaea muscipula
Achillea millefolium
Cirsium arvense
```
resultin in:
```
AND (Bellis perennis[ORGN] OR Brassica napus[ORGN] OR Dionaea muscipula[ORGN] OR Achillea millefolium[ORGN] OR Cirsium arvense[ORGN])
```
