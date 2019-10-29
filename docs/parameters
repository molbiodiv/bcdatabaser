# Parameters and Output
{:.no_toc}

* TOC list
{:toc}

## Parameters
Independent of whether the command line or web interface were used, the tool considers the following parameters. 
In the webinterface some parameters are however fixed to most common parameters. 

**Required:**
 - Search term (marker)

**Optional**
 - Taxonomic scope (default: root): 
 - Taxonlist
 - Length range  (*Web interface: 100bp - 2000bp*)
 - Degenerate primers (trimming/orientation)
 - HMMs (trimming/orientation) - not yet implemented
 - Maximum number of sequences per taxon (*Web interface: fixed 9*)
 
## Output
Recommended naming scheme: `<Marker>.<Taxonomic Group>.<country code>.<date>`

Basic:
 - Sequence fasta (filtered/trimmed/sintax style taxonomy header)
 
Additional:
 - Report (e.g. Taxonomy table (Krona))

## Steps
 - Check dependencies
 - Check inputs
 - Download sequences
 - optional: trim/orient via primers (or HMM in the future)
 - Add taxonomy
 - Write reports

## Helper scripts
 - geographicRange2taxonList
