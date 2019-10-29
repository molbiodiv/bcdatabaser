[back to the index](./index.md)

# Automated post-processing databases before classification
{:.no_toc}

* TOC list
{:toc}

## Issues with taxon names including special characters

For a variety of downstream classifiers, names that include special characters may pose a problem. In this case you can execute a regular expression and substitution on your database file with the following command to replace unwanted characters. This regular expression covers the current issues we faced, feel free to open an issue [here](https://github.com/molbiodiv/bcdatabaser/issues) in case you encounter others. 

Change into database directory where the file ```sequences.tax.fa```  is located and execute:
```sh
sed -i .bak -e "s/,\(.[^:]\)/_\1/" -e "s/,_/_/g" -e "s/;$//"  sequences.tax.fa
```

## Removal of sequences with many ambitious base pairs
Databases created with the BCdatabaser prioritize on inclusion of the longest references to increase the likelihood to span the entire region of interest (within length constraits). 
It may thus include sequences that have high content of Ns in their midst (e.g. paired end sequencing) which makes them usually unsuitable for barcoding purposes. 
Databases can be cleaned up with the **Prinseq-lite** tool available here: [https://github.com/b-brankovics/grabb/blob/master/docker/prinseq-lite.pl](https://github.com/b-brankovics/grabb/blob/master/docker/prinseq-lite.pl)
Execution is as follows: 

```sh
perl prinseq-lite.pl -fasta sequences.tax.fa  -ns_max_n 10 -out_good sequences.tax.noN.fa
```
Be aware, the file suffix changes from ```.fa``` to ```.fasta```

## Length restriction 

Prinseq-lite can also be used to apply a length filter. Length filter can also be directly applied in the BCdatabaser, yet values deriving from the default only with the command line version. If further filters want to be applied in post-processing, this can be done with: 

```sh
perl prinseq-lite.pl -fasta -min_len 200 -max_len 500 -out_good sequences.tax.len.fa
```

## Chimera detection

It is possible to screen the database for chimeric sequences using VSEARCH available at [https://github.com/torognes/vsearch](https://github.com/torognes/vsearch)

```sh
vsearch --uchime_denovo sequences.tax.fa --nonchimeras sequences.tax.nochimera.fa
```

**Reference:** *Rognes T, Flouri T, Nichols B, Quince C, Mahé F. (2016) VSEARCH: a versatile open source tool for metagenomics. PeerJ 4:e2584. doi: 10.7717/peerj.2584*

## Dereplication 

Sequences may still include duplicate sequences in the database. This should in most cases not harm the classification procedure, yet might result in longer calculations. This may be circumvent by using VSEARCH for dereplication, but be aware that this might result in unwanted results when two closely related taxa share exactly the complete identical marker sequence: 

```sh
vsearch --derep_fulllength sequences.tax.fa --output sequences.tax.unique.fa
```

Databases can be alternatively dereplicated, curated and trimmed using the tool MetaCurator, which considers taxonomy in dereplication [![DOI](https://img.shields.io/badge/DOI-10.1111%2F2041--210X.13314-blue)](https://doi.org/10.1111/2041-210X.13314)

For usage please refer to the respective Github page: [https://github.com/RTRichar/MetaCurator](https://github.com/RTRichar/MetaCurator)

**Reference:** *Richardson, R. T., Sponsler, D. B., McMinn‐Sauder, H. and Johnson, R. M. (2019), MetaCurator: A hidden Markov model‐based toolkit for extracting and curating sequences from taxonomically‐informative genetic markers. Methods Ecol Evol. Accepted Author Manuscript. doi:10.1111/2041-210X.13314*

