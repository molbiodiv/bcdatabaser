[back to the index](./index.md)

# BCdatabaser output files
{:.no_toc}

* TOC list
{:toc}

## Directory name format

In the webinterface, the name format of the zip file/directory is determined by input paramters, 
with the scheme: 
```
<MARKER>.<TAXONOMIC-RANGE>.<TAXA-RESTRICTION-LIST>.<DATE>
```
e.g.:
```
coi.insecta.DE-Frankonia.2019-10-24
```
In this extracted directory, the following files are present. 

## Sequence data

* **sequences.tax.fa** All result sequences including taxonomy information parsed into the header (sse Syntax below) 
```
>LS453445;tax=k:Metazoa,p:Arthropoda,c:Insecta,o:Coleoptera,f:Carabidae,g:Molops,s:Molops_piceus;
ACATCCTGAAGTTTATATTTTAATTCTCCCAGGATTTGGAATAATTTCCCATATTATTAGACAAGAAAGA
GGTAAAAAAGAAACATTTGGTTCATTAGGAATAATTTATGCTATATTAGCTATTGGTTTATTAGGATTTG
[...]
```

* **sequences.fa** All result sequences without taxonomy, basically the sequences as have been named in NCBI
```
>LS453445.1 Molops piceus mitochondrial partial COI gene for cytochrome oxidase subunit 1, specimen voucher MNCN-AI362
ACATCCTGAAGTTTATATTTTAATTCTCCCAGGATTTGGAATAATTTCCCATATTATTAGACAAGAAAGA
GGTAAAAAAGAAACATTTGGTTCATTAGGAATAATTTATGCTATATTAGCTATTGGTTTATTAGGATTTG
TAGTATGAGCTCATCATATATTTACAGTAGGAATAGATGTGGATACTCGAGCTTATTTTACATCAGCTAC
[...]
```

## Syntax of taxonomy
Taxonomy is presented in a syntax directly in the FASTA header as used by a variety of classifiers. Slight modifications might need to made for some software tools (see the [./classification](classification documentation)). In more detail, we follow strictly the SINTAX nomenclature as described in the [https://www.drive5.com/usearch/manual/tax_annot.html](USEARCH manual):
```
><UNIQUEID>;tax=k:Kingdom,p:Phylum,c:Class,o:Order,f:Family,g:Genus,s:Species;
```
e.g.:
```
>LS453445;tax=k:Metazoa,p:Arthropoda,c:Insecta,o:Coleoptera,f:Carabidae,g:Molops,s:Molops_piceus;
```

The syntax is very similar to the **RDP variant** of the nomenclature: 
```
>LS453445	Metazoa;Arthropoda;Insecta;Coleoptera;Carabidae;Molops;Molops_piceus
```
and can be parsed with this command: 
```sh
sed -e "s/;tax=k:/\t/" -e "s/,[^:]:/;/g" sequences.tax.fa  > sequences.tax.rdp.fa 
```

Also it is very similar to the **Greengenes variant** of the nomenclature:
```
>LS453445  k__Metazoa;p__Arthropoda;c__Insecta;o__Coleoptera;f__Carabidae;g__Molops;s__:Molops_piceus
```
and can be parsed with this command: 
```sh
sed -e "s/;tax=k:/\t/" -e "s/,/;/g" -e "s/:/__/g" sequences.tax.fa  > sequences.tax.gg.fa 
```


## Visualisation as Krona Charts

## Additional files
Also in the directory will be more files which may be interesting: 
* **[CITATION](./CITATION)**, the same file as in this repository includes CITATION information for BCdatabaser and internally used tools
* **bcdatabaser.log** A file that logs all of the steps BCdatabaser has performed, paramaters and if unsuccessfull error descriptions, e.g.:
```
[...]
[10-24 08:44:38] [BCdatabaser] Finished: Add CITATION file to output directory
[10-24 08:44:38] [BCdatabaser] Starting: Zipping output directory
[10-24 08:44:38] [BCdatabaser] zip -r coi.insecta.DE-Frankonia.2019-10-24.zip coi.insecta.DE-Frankonia.2019-10-24
```
* three **list.** files: 
  - **list.txt**, all hits given the taxonomic range, taxa list and/or length restriction
  - **list.sorted.txt** the same list, yet sorted according to sequence length
  - **list.filtered.txt** the sorted list limited to ```--sequences-per-taxon``` per taxon
  
* **taxa_list.txt** the taxa list included in the analyses, if used
