[back to the index](./index.md)

# Parameter Explanation
{:.no_toc}

* TOC list
{:toc}

## Parameters
Independent of whether the command line or web interface were used, the tool considers the following parameters. 
In the webinterface some parameters are however fixed to most common parameters. 

See the **Command line reference** for more details on each command. See also **NCBI query details** below in how the actual search query to NCBI is composed.

**Required:**
 - Search term (marker): ```--marker-search-string```  
 
**Optional**
 - Taxonomic scope (default: root): ```--taxonomic-range```
 - Taxa List (default: none): ```--taxa-list```
 - Degenerate primers (trimming/orientation)
 - HMMs (trimming/orientation) - not yet implemented
 - Maximum number of sequences per taxon (*Web interface: fixed 9*)

**Web interface fixed, but changeable in command line version:** 
 - Check that all taxa have sequences available (*Web: TRUE*): ```--check-tax-names``` and ```--warn-failed-tax-names```
 - Length range  (*Web: 100bp - 2000bp*): ```--sequence-length-filter```
 - Maximum #Sequences/Taxon (*Web: 9*): ```--sequences-per-taxon```
 - Sequence trimming (*Web: disabled*): ```--primer-file ```
 - Zenodo push settings (*Web:from user login*): ```--zenodo-token-file```, ```--zenodo-author-name```, ```--zenodo-author-orcid```
 - Output settings: ```--zip```, ```--outdir```

**Expert options (command line only, and not necessary with Docker):**

```--names-dmp-path```, ```--edirect-dir```,```--edirect-batch-size```, ```--krona-bin```, ```--seqfilter-bin```, ```--dispr-bin``` 


**Command Line Reference:**

You can also get this information for your version by running 
`bcdatabaser.pl --help`:

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

## NCBI query details

NCBI allows for advanced searches with a specific search syntax as [described in detail in their handbook](https://www.ncbi.nlm.nih.gov/books/NBK49540/).

### Construction from user data
From the user provided parameters a search query string is constructed as follows:

```
(<SEARCH_STRING>) AND <TAXONOMIC_SCOPE>[ORGN] AND <LENGTH_RANGE>[SLEN] NOT gbdiv est[prop] NOT gbdiv gss[prop] NOT patent NOT environmental NOT unverified
```
so your search string, taxonomic scope and length range are used as provided.
Additionally the search excludes est and gss data sets as well as patented, environmental and unverified sequences.

### Example
A query string from the web interface with the `rbcL` preset and *Bellis* as taxonomic scope would be:
```
(rbcL OR 'ribulose-1,5-bisphosphate carboxylase/oxygenase large subunit') AND Bellis[ORGN] AND 100:2000[SLEN] NOT gbdiv est[prop] NOT gbdiv gss[prop] NOT patent NOT environmental NOT unverified
```

### Taxa List File
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
resulting in:
```
AND (Bellis perennis[ORGN] OR Brassica napus[ORGN] OR Dionaea muscipula[ORGN] OR Achillea millefolium[ORGN] OR Cirsium arvense[ORGN])
```
