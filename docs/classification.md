[back to the index](./index.md)

# Classification examples using different examples
{:.no_toc}

* TOC list
{:toc}

## USEARCH/SINTAX

The databases created with BCdatabaser can be directly used in USEARCH, although you might consider applying [automated](./postprocessing.md) and [manual](./postprocessing_manual.md) post-processing options. 
Also consider the USEARCH manual for parameter and algotihm choices: [https://drive5.com/usearch/manual/](https://drive5.com/usearch/manual/)

*Direct global alignment searches: *
```sh 
usearch -usearch_global sequence-of-interest.fa -db sequences.tax.fa -id 0.97 -uc zotus.directglobal.uc -strand both
```

*Direct local alignment searches: *
```sh 
usearch -usearch_local sequence-of-interest.fa -db sequences.tax.fa -id 0.97 -uc zotus.directglobal.uc -strand both
```

*Hierarchical SINTAX classification (USEARCH v9+): *
```sh 
usearch -sintax sequence-of-interest.fa -db sequences.tax.fa -tabbedout zotus.directglobal.sintax -strand both -sintax_cutoff 0.8
```

**References: **

* R.C. Edgar (2010), Search and clustering orders of magnitude faster than BLAST, Bioinformatics 26(19) 2460-2461 
R.C. Edgar (2016), SINTAX: a simple non-Bayesian taxonomy classifier for 16S and ITS sequences, https://doi.org/10.1101/074161 *

## VSEARCH/SINTAX

Similar to USEARCH, databases are already fully compatible with VSEARCH


*Direct global alignment searches: *
```sh 
vsearch --usearch_global sequence-of-interest.fa --db sequences.tax.fa --id 0.97 --uc zotus.directglobal.uc --strand both
```
*Hierarchical SINTAX classification (USEARCH v9+): *
```sh 
vsearch -sintax sequence-of-interest.fa --db sequences.tax.fa --tabbedout zotus.directglobal.sintax --strand both --sintax_cutoff 0.8
```

**Reference:** * Rognes T, Flouri T, Nichols B, Quince C, Mahé F. (2016) VSEARCH: a versatile open source tool for metagenomics. PeerJ 4:e2584. doi: 10.7717/peerj.2584*

## BLAST

Also direct local alignments can be applied immediatly through BLAST: 

```sh
blastn -query sequence-of-interest.fa -max_target_seqs 1 -outfmt 6 -subject sequences.tax.fa > tabular.out
```

## RDP classifier

The RDP classifier uses a similar, yet not completely consistent syntax with the tools above. Therefore slight modifications have to be applied:

BCdatabaser/tools above fasta syntax: 
```
>LS453445;tax=k:Metazoa,p:Arthropoda,c:Insecta,o:Coleoptera,f:Carabidae,g:Molops,s:Molops_piceus;
ACATCCTGAAGTTTATATTTTAATTCTCCCAGGATTTGGAATAATTTCCCATATTATTAGACAAGAAAGA
GGTAAAAAAGAAACATTTGGTTCATTAGGAATAATTTATGCTATATTAGCTATTGGTTTATTAGGATTTG
TAGTATGAGCTCATCATATATTTACAGTAGGAATAGATGTGGATACTCGAGCTTATTTTACATCAGCTAC
TATAATTATTGCTGTTCCTACAGGAATTAAGATCTTTTCTTGGCTTGCAACTTTACACGGAACTCAGTTA
```

RDP fasta syntax:
```
>LS453445	Metazoa;Arthropoda;Insecta;Coleoptera;Carabidae;Molops;Molops_piceus
ACATCCTGAAGTTTATATTTTAATTCTCCCAGGATTTGGAATAATTTCCCATATTATTAGACAAGAAAGA
GGTAAAAAAGAAACATTTGGTTCATTAGGAATAATTTATGCTATATTAGCTATTGGTTTATTAGGATTTG
TAGTATGAGCTCATCATATATTTACAGTAGGAATAGATGTGGATACTCGAGCTTATTTTACATCAGCTAC
TATAATTATTGCTGTTCCTACAGGAATTAAGATCTTTTCTTGGCTTGCAACTTTACACGGAACTCAGTTA
```

To format this accordingly, the following regular expression can be applied: 

```sh
sed -e "s/;tax=k:/\t/" -e "s/,[^:]:/;/" sequences.tax.fa  > sequences.tax.rdp.fa 




