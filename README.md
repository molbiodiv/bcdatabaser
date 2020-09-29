# BCdatabaser

## Introduction

The Reference DB Creator (BCdatabaser) is a pipeline to create reference databases for arbitrary markers and taxonomic groups from NCBI data.
It can optionally be used to trim and orient the sequences and train taxonomic classifiers.
Please cite our preprint [![DOI](https://img.shields.io/badge/DOI-10.32942%2Fosf.io%2Fcmfu2-blue.svg)](https://doi.org/10.32942/osf.io/cmfu2) in addition to the created dataset if you use this pipeline. Also consider citing the tools used in this pipeline as outlined in [CITATION](./CITATION).

See [the online docu](https://molbiodiv.github.io/bcdatabaser/) for more details.

## Web Interface

A user friendly web interface with limited options is available at https://bcdatabaser.molecular.eco

## Overview

### Input
Required:
 - Search term (marker)

Optional
 - Taxonomic scope (default: root)
 - Taxonlist
 - Length range
 - Degenerate primers (trimming/orientation)
 - HMMs (trimming/orientation) - not yet implemented

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
 - optional: trim/orient via primers (or HMM in the future)
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
If you encounter any problems please open an [issue](https://github.com/molbiodiv/bcdatabaser/issues) and we will do our best to help.

### Docker
Pull the container from DockerHub and you are ready to go

```bash
docker pull iimog/bcdatabaser
```

The default command of this container is the `bcdatabaser.pl` script so you can execute this command.
```bash
docker run --rm iimog/bcdatabaser --help
```

In order to use data from your local directory inside the container and operate as your current user (instead of root):
```bash
docker run -u $UID:$GID -v $PWD:/data --rm iimog/bcdatabaser # arguments
```

You're all set, skip to the [Examples](#examples) section to get started.

The NCBI taxonomy databases in the docker image might be outdated. Build the image manually to get up to date versions:
```bash
git clone https://github.com/molbiodiv/bcdatabaser
cd bcdatabaser
docker build -t bcdatabaser .
```

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
docker run -u $UID:$GID -v $PWD:/data --rm iimog/bcdatabaser\
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
docker run -u $UID:$GID -v $PWD:/data --rm iimog/bcdatabaser\
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

    [--check-tax-names]      If this option is set all taxon names provided
                             by the user (--taxonomic-range and entries in
                             the --taxa-list file) are checked against the
                             names.dmp file from NCBI The program stops with
                             an error if any species name is not listed in
                             names.dmp. If --warn-failed-tax-names is set
                             the program does not stop but prints a warning.
                             Set the path to the names.dmp file via
                             --names-dmp-path Default: false

    [--warn-failed-tax-names]
                             Only used if --check-tax-names is set. Instead
                             of dying when a tax name in the --tax-list is
                             unknown these taxa are removed from the search
                             string and a warning is printed. This means
                             that your search string does not contain all
                             taxa in your file so it is important to check
                             the warning to see which ones were removed.
                             Default: false

    [--names-dmp-path <PATH>]
                             Path to the NCBI taxonomy names.dmp file to
                             check taxonomic names. Only relevant if
                             --check-tax-names is set. The default value is
                             suitable for use with the docker container. It
                             is the same file used by NCBI::Taxonomy to
                             assign the tax strings. Default:
                             /NCBI-Taxonomy/names.dmp Example:
                             --names-dmp-path $HOME/ncbi/names.dmp

    [--sequence-length-filter <SLEN>]
                             Sequence length filter for search at NCBI
                             (single number or colon separated range). This
                             is only applied to the search initial search
                             via "AND <SLEN>[SLEN]". Empty string means no
                             restriction. Default: empty (no restriction)
                             Example: --sequence-length-filter 100:2000

    [--sequences-per-taxon <INTEGER>]
                             Number of sequences to download for each
                             distinct NCBI taxid. If there are more
                             sequences for a taxid the longest ones are
                             kept. Default: 9 Example: --sequences-per-taxon
                             1

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
                             subfolder specified with --outdir Default:
                             false

    [--zenodo-token-file <FILENAME>]
                             Push resulting output zip file to zenodo using
                             the token stored in FILENAME. This option
                             implies --zip (will be set automatically). The
                             token file should only contain the zenodo token
                             in the first line. Be aware that datasets
                             pushed to zenodo are public and receive a doi
                             so they can not simply be deleted. Default:
                             false

    [--zenodo-author-name <STRING>]
                             Name of the author that created this file.
                             Required if --zenodo-token-file is used,
                             otherwise ignored.

    [--zenodo-author-orcid <STRING>]
                             ORCID iD of the author that created this file.
                             Required if --zenodo-token-file is used,
                             otherwise ignored.

    [--help]                 show help

    [--version]              show version number of bcdatabaser and exit
```
 
## Dataset Upload
Automated dataset upload to zenodo is possible. You have to supply a file containing the zenodo token to bcdatabaser.
The dataset is uploaded in the name of the owner of that token. If that's you, you are able to modify metadata but not to delete the record.
 
## Logo
The current logo is designed by [@mirzazulfan](https://github.com/mirzazulfan).
Thanks a lot Mirza!
![Logo](logo/512px.png)

## LICENSE

This software is licensed under [MIT](./LICENSE). Be aware that the libraries and external programs are licensed separately (possibly under different licenses).

## Changes
 - 1.1.1 <2019-11-05> Add online documentation
 - 1.1.0 <2019-11-03> Add author options. Fix line-ending bug (#23)
 - 1.0.0 <2019-07-15> Initial stable release
