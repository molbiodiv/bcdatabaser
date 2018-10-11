# Reference DB Creator

## Introduction

The Reference DB Creator is a pipeline to create reference databases for arbitrary markers and taxonomic groups from NCBI data.
It can optionally be used to trim and orient the sequences and train taxonomic classifiers.

## Overview

### Input
Required:
 - Search term (marker)

Optional
 - Taxonomic scope (default: root)
 - Taxonlist
 - Length range
 - HMMs (trimming/orientation)
 - Degenerate primers (trimming/orientation)

### Output
Naming scheme: `<Marker>.<Taxonomic Group>.<country code>.<date>`

Basic:
 - Sequence fasta (filtered/trimmed/sintax style taxonomy header)
 
Additional:
 - Report (e.g. Taxonomy table (Krona))

### Steps
 - Check dependencies
 - Check inputs
 - Download sequences
 - optional: trim/orient via HMM or primers
 - Add taxonomy
 - Write reports

### Helper scripts
 - geographicRange2taxonList
 
## Dataset Upload
 - via zenodo with fixed metadata (referencing our doi)
 
## Web Interface
 - list and download existing datasets
 - create new datasets on the server
