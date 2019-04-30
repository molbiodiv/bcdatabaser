#!/bin/bash

cd /NCBI-Taxonomy/
perl make_taxid_indizes.pl
cd /Krona/KronaTools/
./updateTaxonomy.sh
