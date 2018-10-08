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
Basic:
 - Sequence fasta (filtered/trimmed/taxonomy in header)
 - Taxonomy table
 - Taxonomy report (Krona)

Additional:
 - Classifier training files

### Steps
 - Check dependencies
 - Check inputs
 - Download sequences
 - optional: trim/orient via HMM or primers
 - Add taxonomy
 - optional: train classifiers
 - Write reports

### Helper scripts
 - geographicRange2taxonList
