[back to the index](./index.md)

# Manual post-processing databases before classification
{:.no_toc}

* TOC list
{:toc}

In general, the output sequence files, particularly the ```sequences.tax.fa``` are plain text files, which can be manually edited with any standard text editor (e.g. All platforms: [Atom](https://atom.io); MacOSX: TextEdit, [BBEdit](https://www.barebones.com/products/textwrangler/download.html); Windows: NotePad; Linux: Wordpad and many more). How to do this is self-explainatory when following the [Syntax description](./output.md). 

We here show different examples to manually edit databases using the command line, which has many advantages, as e.g. fast and for larger numbers. 

## Adding local references to the database
The ```sequences.tax.fa``` is a standard fasta-formated text file, which can be complemented with any other fasta-file, e.g. unpublished sequences or such from other sources. 

```
cat sequences.tax.fa unpulished.fa > sequences.tax.add.fa
```
This results however in those sequences not including the taxonomic annotations. 
* They can be manually added by checking the taxa of interest at the [NCBI taxonomy](https://www.ncbi.nlm.nih.gov/taxonomy) webpage and adjusting headers according to the [taxonomy syntax](./output.md). 
* Alternatively, for larger numbers, they can be obtained in bulk using the [NCBI eutils](https://www.ncbi.nlm.nih.gov/books/NBK25500/), you can have a look at the requests BCdatabaser does in scripts as a starter: [add_taxonomy_to_fasta.pl](https://github.com/molbiodiv/bcdatabaser/blob/master/bin/add_taxonomy_to_fasta.pl) and [makeRefDB.sh](https://github.com/molbiodiv/bcdatabaser/blob/master/bin/makeRefDB.sh)

**However, we strongly recommend to deposit unpublished sequences**, and once they are validated by NCBI, they will also be available in the automated BCdatabaser created datasets. Thus, we encourage scientists first to [deposit](https://www.ncbi.nlm.nih.gov/guide/howto/submit-sequence-data/) unpublished sequences in NCBI and then run BCdatabaser. This will include the taxonomic information for these sequences automatically, and most journals already require sequence deposition prior to manuscript submission anyways.

## Checking and deleting suspicious sequences
If you find suspicious taxonomic assignments, you may want to apply more stringent parameters to your classification algorithm (check their manuals). If this still not helps it might be wrongly taxonomized sequences in NCBI. 
NCBI may hold wrong sequence-taxa links, although checks have become more detailed in that regard recently. You might be interested in this recent [paper](https://www.pnas.org/content/early/2019/10/16/1911714116). In case you encounter such cases, you might want to remove them from your generated from the database:

To find sequences of the "suspicious" taxa, you can do this with: 
```
grep "Molops_piceus" sequences.tax.fa 
```
this will output all of the sequences associated with this species in the database:
```
>LS453445;tax=k:Metazoa,p:Arthropoda,c:Insecta,o:Coleoptera,f:Carabidae,g:Molops,s:Molops_piceus;
>JF889461;tax=k:Metazoa,p:Arthropoda,c:Insecta,o:Coleoptera,f:Carabidae,g:Molops,s:Molops_piceus;
>KU906638;tax=k:Metazoa,p:Arthropoda,c:Insecta,o:Coleoptera,f:Carabidae,g:Molops,s:Molops_piceus;
>KU906549;tax=k:Metazoa,p:Arthropoda,c:Insecta,o:Coleoptera,f:Carabidae,g:Molops,s:Molops_piceus;
>KM449442;tax=k:Metazoa,p:Arthropoda,c:Insecta,o:Coleoptera,f:Carabidae,g:Molops,s:Molops_piceus;
```

For example, these sequences can be isolated and checked with a manual alignemnt, whether there is one or more sequence which do not align well with the rest or checked otherwise (e.g. [NCBI BLAST](https://blast.ncbi.nlm.nih.gov/Blast.cgi?PAGE_TYPE=BlastSearch)). This can be done with [SeqFilter](https://github.com/BioInf-Wuerzburg/SeqFilter)

```
SeqFilter --ids-patt 'LS453445|JF889461|KU906638|KU906549|KM449442' --out Molops_piceus.fa sequences.tax.fa
```

In case a suspicuous sequence is found, it can also be trimmed from the reference database using [SeqFilter](https://github.com/BioInf-Wuerzburg/SeqFilter), e.g.:

```
SeqFilter --ids-patt 'LS453445' --ids-exclude --out sequences.tax.exclude.fa sequences.tax.fa
```


## Renaming taxa

The [NCBI taxonomy](https://www.ncbi.nlm.nih.gov/taxonomy) is in general a very good start for taxonomy, yet it might not have the most recent nomenclature changes incorporated. If you find such taxa which have been renamed, these can be adjusted using ```sed```:

The basic syntax for ```sed``` as applied here is (but check ```man sed``` for more details):

```sh
sed -i bak "s/SEARCH-TERM/REPLACEMENT/" sequences.tax.fa
```

In a real life example: 

```sh
sed -i bak "s/Molops_piceus/Molops_newbeetlename/" sequences.tax.fa
```

this can be done also for higher level taxa, e.g. families: 

```sh
sed -i bak "s/Molops/NewGenus/" sequences.tax.fa
```
or also, if only some taxa were separated to to a different Lineage:

```sh
sed -i bak "s/f:Carabidae,g:Molops/f:NewFamily,g:Molops/" sequences.tax.fa
```


## Alternative taxonomic lineages

As already mentioned above, [NCBI taxonomy](https://www.ncbi.nlm.nih.gov/taxonomy) is in general a very good start for taxonomy. However, as in science general, not everybody will agree to their classification. In such cases, the taxonomy can be replaced with other systems. A good choice might be the [taxize](https://cran.r-project.org/web/packages/taxize/index.html) package for R, which will use the taxonomy as used by [EOL](https://eol.org) and [ITIS](https://www.itis.gov).

Given that a taxonomic classification has been completed, and the final results are loaded into R, this can be done as: 

Basic:
```R
species <- c("Papaver rhoeas","Sinapis alba", "Helianthus annuus")
(result <- tax_name(query = species, get = c("kingdom","order","family","genus","species"), db = "itis"))
```

With BCdatabaser results: The format depends on your classifier output, wherefore we here assume that it has been imported as a standardized [phyloseq](https://joey711.github.io/phyloseq/import-data.html) object:

**All species level classifications:**
```R
species <- gsub("s:","",tax_table(physeq)[,"species"])
(result <- tax_name(query = species, get = c("kingdom","order","family","genus","species"), db = "itis"))
```

**Or in case you use hierarchical classification with variable resolution:**
```R
tax_table(dataset.comp)[tax_table(dataset.comp)[,"phylum"]=="","phylum"]<-paste(tax_table(dataset.comp)[tax_table(dataset.comp)[,"phylum"]=="","kingdom"],"_spc",sep="")
tax_table(dataset.comp)[tax_table(dataset.comp)[,"order"]=="","order"]<-paste(tax_table(dataset.comp)[tax_table(dataset.comp)[,"order"]=="","phylum"],"_spc",sep="")
tax_table(dataset.comp)[tax_table(dataset.comp)[,"family"]=="","family"]<-paste(tax_table(dataset.comp)[tax_table(dataset.comp)[,"family"]=="","order"],"_spc",sep="")
tax_table(dataset.comp)[tax_table(dataset.comp)[,"genus"]=="","genus"]<-paste(tax_table(dataset.comp)[tax_table(dataset.comp)[,"genus"]=="","family"],"_spc",sep="")
tax_table(dataset.comp)[tax_table(dataset.comp)[,"species"]=="","species"]<-paste(tax_table(dataset.comp)[tax_table(dataset.comp)[,"species"]=="","genus"],"_spc",sep="")

taxa <- gsub("_spc.*","",gsub(".*:","",tax_table(data.species)[,"species"]))
(result <- tax_name(query = taxa, get = c("kingdom","order","family","genus","species"), db = "itis"))

```

Please be aware that some taxa names might not shared between the NCBI and ITIS databases, which may results in some taxa not yielding successfull results.


