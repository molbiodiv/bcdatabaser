[back to the index](./index.md)

# Manual post-processing databases before classification
{:.no_toc}

* TOC list
{:toc}

## Adding local references to the database

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

For example, these sequences can be isolated and checked with a manual alignemnt, whether there is one or more sequence which does not align well with the rest. This can be done with [SeqFilter](https://github.com/BioInf-Wuerzburg/SeqFilter)

```
SeqFilter --ids-patt 'LS453445|JF889461|KU906638|KU906549|KM449442' --out Molops_piceus.fa sequences.tax.fa
```

In case a suspicuous sequence is found, it can also be trimmed from the reference database using [SeqFilter](https://github.com/BioInf-Wuerzburg/SeqFilter), e.g.:

```
SeqFilter --ids-patt 'LS453445' --ids-exclude --out sequences.tax.exclude.fa sequences.tax.fa
```


## Renaming taxa

## Alternative taxonomic lineages

## 
