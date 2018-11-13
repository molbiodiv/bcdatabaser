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
 - Degenerate primers (trimming/orientation)
 - HMMs (trimming/orientation) - planned but not yet implemented

### Output
Recommended naming scheme: `<Marker>.<Taxonomic Group>.<country code>.<date>`

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

## Installation

## Examples

## Command Line Reference

```
Usage:
      $ reference_db_creator.pl [@configfile] --marker-search-string="<SEARCHSTRING>" [options]

Options:
    [@configfile]            Optional path to a configfile with @ as prefix.
                             Config files consist of command line parameters
                             and arguments just as passed on the command
                             line. Space and comment lines are allowed (and
                             ignored). Spreading over multiple lines is
                             supported.

    --marker-search-string <SEARCHSTRING>
                             Search string for the marker, passed literally
                             to the NCBI search

    [--outdir <STRING>]      output directory for the generated output files
                             (default: reference_db_creator)

    [--taxonomic-range <SCINAME>]
                             Scientific (or common) name of the taxon all
                             sequences have to belong to. This will be added
                             to the query string as "AND <SCINAME>[ORGN]".
                             Default: empty (no restriction) Example:
                             --taxonomic-range Viridiplantae

    [--taxa-list <FILENAME>] File with list of scientific (or common) names
                             to include (one per line). Attention: All
                             children of higher taxonomic ranks will be
                             included. This will be added to the query
                             string as "AND (<SCINAME1>[ORGN] OR
                             <SCINAME2>[ORGN] ...)". Default: empty (no
                             restriction) Example: --taxa-list
                             plants_in_germany.txt

    [--sequence-length-filter <SLEN>]
                             Sequence length filter for search at NCBI
                             (single number or colon separated range). This
                             is only applied to the search initial search
                             via "AND <SLEN>[SLEN]". Empty string means no
                             restriction. Default: empty (no restriction)
                             Example: --sequence-length-filter 100:2000

    [--edirect-dir <STRING>] directory containing the entrez direct
                             utilities (default: empty, look for programs in
                             PATH) More info about edirect:
                             https://www.ncbi.nlm.nih.gov/books/NBK179288/

    [--edirect-batch-size <INT>]
                             Sequence download is split into batches of
                             <INT> sequences to avoid network timeouts.
                             Default: 100

    [--krona-bin <STRING>]   Path to the executable of ktImportTaxonomy
                             (https://github.com/marbl/Krona) Default:
                             ktImportTaxonomy (assumes Krona Tools to be in
                             PATH)

    [--seqfilter-bin <STRING>]
                             Path to the executable of SeqFilter
                             (https://github.com/BioInf-Wuerzburg/SeqFilter)
                             Default: SeqFilter (assumes SeqFilter to be in
                             PATH)

    [--dispr-bin <STRING>]   Path to the executable of dispr
                             (https://github.com/douglasgscofield/dispr) for
                             degenerate in silico pcr for filtering,
                             trimming, and orientation In order to use dispr
                             --primer-file must be provided as well Default:
                             dispr (assumes dispr to be in PATH)

    [--primer-file <FILENAME>]
                             Path to the primers file for dispr. From the
                             dispr help text:

                                     Fasta-format file containing primer sequences.  Each
                                     primer sequence must have a name of the format
                                       >tag:F       or   >tag:R
                                       CCYATGTAYY        CTBARRSTG
                                     indicating forward and reverse primers, respectively.
                                     Valid IUPAC-coded sequences are required.
                                     The tag is used to mark hits involving the primer pair
                                     and must be identical for each forward-reverse pair.

                             Default: empty (dispr not used for
                             filtering/trimming/orientation)

    [--help]                 show help

    [--version]              show version number of reference_db_creator and
                             exit
```
 
## Dataset Upload - planned but not yet implemented
 - via zenodo with fixed metadata (referencing our doi)
 
## Web Interface - planned but not yet implemented
 - list and download existing datasets
 - create new datasets on the server
