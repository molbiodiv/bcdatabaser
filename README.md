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
This pipeline consists of a perl script that depends on a number of libraries.
It also utilizes external programs that need to be available. See the next section for details.
As it can be difficult to download and setup all the dependencies we provide a ready to use docker container.
We recommend using this container (it should also work with singularity).
However, if you want or need a native installation please see the websites of the modules and tools
for installation instructions for your platform and refer to the steps in the [Dockerfile](./Dockerfile).
If you encounter any problems please open an [issue](https://github.com/molbiodiv/metabDB/issues) and we will do our best to help.

### Docker
Pull the container from DockerHub and you are ready to go

```bash
docker pull iimog/metabdb_dev
```

The default command of this container is the `bcdatabaser.pl` script so you can execute this command.
```bash
docker run --rm iimog/metabdb_dev --help
```

In order to use data from your local directory inside the container and operate as your current user (instead of root):
```bash
docker run -u $UID:$GID -v $PWD:/data --rm iimog/metabdb_dev # arguments
```
If you see this message: `whoami: cannot find name for user ID` apear in the log, you can ignore it. This is because your user is not known to the docker container but this will not cause any problems.

You're all set, skip to the [Examples](#examples) section to get started.

## Dependencies

Perl Modules:
 - Pod::Usage
 - FindBin
 - Log::Log4perl
 - Getopt::Long
 - Getopt::ArgvFile 
 - File::Path
 - [NCBI::Taxonomy](https://github.com/greatfireball/NCBI-Taxonomy)

External Programs:
 - [NCBI eutils](https://www.ncbi.nlm.nih.gov/books/NBK25500)
 - [KronaTools](https://github.com/marbl/Krona)
 - [SeqFilter](https://github.com/BioInf-Wuerzburg/SeqFilter)
 - [dispr](https://github.com/molbiodiv/metabDB/issues)

## Examples

These examples assume that you are using the docker installation.
For Singularity or local installations the commands have to be adjusted accordingly.

Simple example (ITS2 sequences for the genus Bellis):
```
docker run -u $UID:$GID -v $PWD:/data --rm iimog/metabdb_dev\
 --outdir its2.bellis.full.2018-11-12\
 --marker-search-string "(ITS2 OR internal transcribed spacer 2)"\
 --taxonomic-range Bellis\
 --sequence-length-filter 100:2000
```

This created a folder `its2.bellis.full.2018-11-12` in your current working directory with the following content:
 - **sequences.tax.fa**: the sequences with sinax-style taxonomy information in the header
 - **taxonomy.krona.html**: Krona chart of the taxa in the resulting database
 - **list.txt**: list of accessions and taxids downloaded
 - **sequences.fa**: the raw sequence download
 - **bcdatabaser.log**: log file with all the messages printed to stdout
 - **CITATION**: info on how to cite this pipeline

Advance example (ITS2 sequences for a custom species list with trimming using dispr):
```
docker run -u $UID:$GID -v $PWD:/data --rm iimog/metabdb_dev\
 --outdir its2.viridiplantae.custom.2018-11-12\
 --marker-search-string "(ITS2 OR internal transcribed spacer 2)"\
 --taxonomic-range Viridiplantae\
 --taxa-list /metabDB/examples/some_plants.txt\
 --sequence-length-filter 100:20000\
 --primer-file /metabDB/data/primers/its2.sickel2015.fa
```

This creates a folder ` ` in your current working directory with the following additional files (compaded to the previous example):
 - **sequences.dispr.fa**: the sequences that were successfully trimmed and oriented using dispr and the provided primer pairs
 - **sequences.combined.fa**: the trimmed/oriented sequences from above or the raw ones if the primer pair was not found on that sequence

## Command Line Reference

```
Usage:
      $ bcdatabaser.pl [@configfile] --marker-search-string="<SEARCHSTRING>" [options]

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
                             (default: bcdatabaser)

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

    [--sequences-per-taxon <INTEGER>]
                             Number of sequences to download for each
                             distinct NCBI taxid. If there are more sequences
                             for a taxid the longest ones are kept.
                             Default: 3 Example: --sequences-per-taxon 1

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

    [--zip]                  Create output .zip file containing the folder.
                             If set the output folder will be zipped and
                             deleted(!). So please be careful when using
                             --zip and only use it with a dedicated
                             subfolder specified with --outdir Default=false

    [--help]                 show help

    [--version]              show version number of bcdatabaser and
                             exit
```
 
## Dataset Upload - planned but not yet implemented
 - via zenodo with fixed metadata (referencing our doi)
 
## Web Interface - planned but not yet implemented
 - list and download existing datasets
 - create new datasets on the server

## LICENSE

This software is licensed under [MIT](./LICENSE). Be aware that the libraries and external programs are licensed separately (possibly under different licenses).
