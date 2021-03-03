# BCdatabaser

The Reference DB Creator (BCdatabaser) is a pipeline to create reference databases for arbitrary markers and taxonomic groups from NCBI data.

In a nutshell:
* check inputs for available data at NCBI
* downloads sequences according to parameters 
* *optional:* trims/orients via primers
*  adds taxonomy to sequences
*  write reports
*  *web interface or optionally on command line:* deposits data publicly at Zenodo.org and assigns a citable DOI

## Basic documentation 
* [Web interface](./web.md) A user-friendly web interface with limited options is available at [https://bcdatabaser.molecular.eco](https://bcdatabaser.molecular.eco). Login via ORCID is mandatory, created databases will be publicly available and assigned a DOI at Zenodo. 
* [Command line version](cmd.md)
* [Parameters and Search Details](parameters.md)
* [Output and file syntax](output.md)

## Further documentation 
* [Automated post-processing of databases](postprocessing.md) (e.g. additional filters and checks)
* [Manual post-processing of databases](postprocessing_manual.md) (e.g. adding sequences or modifying taxonomy)
* [Usage with classifiers](classification.md)
* [Public deposition](public_deposition.md)
 
**If you use this software, please cite it as below:**

Alexander Keller, Sonja Hohlfeld, Andreas Kolter, Jörg Schultz, Birgit Gemeinholzer,
Markus J Ankenbrand, BCdatabaser: on-the-fly reference database creation for 
(meta-)barcoding, Bioinformatics, Volume 36, Issue 8, 15 April 2020, Pages 2630–2631,
https://doi.org/10.1093/bioinformatics/btz960
https://github.com/molbiodiv/bcdatabaser

**Please also cite the software used by this pipeline:**
* [NCBI eutils](https://www.ncbi.nlm.nih.gov/books/NBK25500/)
* [NCBI::Taxonomy module](https://github.com/greatfireball/NCBI-Taxonomy) - Förster F. greatfireball/NCBI-Taxonomy v0.90. Zenodo. 2018 Oct 15; http://doi.org/10.5281/zenodo.1462861
*  [SeqFilter](https://github.com/BioInf-Wuerzburg/SeqFilter)
*  [dispr](https://github.com/douglasgscofield/dispr)
*  [Krona](https://github.com/marbl/Krona) - Ondov BD, Bergman NH, and Phillippy AM. Interactive metagenomic visualization in a Web browser. BMC Bioinformatics. 2011 Sep 30; 12(1):385.

 
