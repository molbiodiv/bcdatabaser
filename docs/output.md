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
In this extracted directory the following files are present. We recommend to also follow this file format in the command line version, especially if deposited in a database as a reference set (see also: [Public deposition](./public_deposition.md)).

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
Taxonomy is included in a syntax directly in the FASTA header as used by a variety of classifiers. Slight modifications might be necessary to made for some software tools accpt this format (see also the [classification documentation](./classification.md)). In more detail, we follow strictly the SINTAX nomenclature as described in the [USEARCH manual](https://www.drive5.com/usearch/manual/tax_annot.html):
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

In the directory, there is also a visual and interactive summary of sequences included in the final dataset, named as ```taxonomy.krona.html```. This file can be viewed and interacted with using a standard internet browser. For large databases, the data of the chart may also be located in a corresponding subdirectory. 

![Example Krona Chart](https://i.ibb.co/Tq5GW98/Bildschirmfoto-2019-10-31-um-13-36-42.png)


## Additional files
Also in the directory will be more files which may be interesting: 
* **CITATION**, the same file as in this repository including CITATION information for BCdatabaser and internally used tools
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
