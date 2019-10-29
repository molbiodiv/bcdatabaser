# Automated post-processing databases before classification
{:.no_toc}

* TOC list
{:toc}

## Issues with taxon names including special characters

For a variety of downstream classifiers, names that include special characters may pose a problem. In this case you can execute a regular expression and substitution on your database file with the following command to replace unwanted characters:
Change into database directory where the file ```sequences.tax.fa```  is located and execute:
```sh
sed -i .bak -e "s/,\(.[^:]\)/_\1/" -e "s/,_/_/g" -e "s/;$//"  sequences.tax.fa
```

## Removal of sequences with many ambitious base pairs
Databases created with the BCdatabaser prioritize on inclusion of the longest references to increase the likelihood to span the entire region of interest (within length constraits). 
It may thus include sequences that have high content of Ns in their midst (e.g. paired end sequencing) which makes them usually unsuitable for barcoding purposes. 
Databases can be cleaned up with the **Prinseq-lite** tool available here: https://github.com/b-brankovics/grabb/blob/master/docker/prinseq-lite.pl
Execution is as follows: 

```
perl $pr -fasta sequences.tax.fa  -ns_max_n 10 -out_good sequences.tax.corr
```
Be aware, the file suffix changes from ```.fa``` to ```.fasta```

## Dereplication 

Databases can be further dereplicated and trimmed using the tool MetaCurator [![DOI](https://img.shields.io/badge/DOI-10.1111/2041-210X.13314g-blue.svg)](https://doi.org/10.1111/2041-210X.13314g)

For usage please refer to the respective Github page: https://github.com/RTRichar/MetaCurator

Reference: *Richardson, R. T., Sponsler, D. B., McMinn‐Sauder, H. and Johnson, R. M. (2019), MetaCurator: A hidden Markov model‐based toolkit for extracting and curating sequences from taxonomically‐informative genetic markers. Methods Ecol Evol. Accepted Author Manuscript. doi:10.1111/2041-210X.13314*
