#!/bin/bash
input=US_PA

cat $input.txt | perl -pe 's/\n/" OR "/' | sed -e 's/^/"/' -e 's/ OR \"$//' > ncbi.request
req=`cat ncbi.request`
esearch -db nuccore -query "(ITS2 OR \"internal transcribed spacer 2\") AND Viridiplantae[ORGN] AND 100:2000[SLEN] AND ($req)" |  efetch -format docsum | xtract -pattern DocumentSummary -element Caption,TaxId > list.txt

split -l 10000 list.txt


for file in `ls x*` ;
do
  echo "Processing >>> $file <<<";

  cut -f2 $file | epost -db taxonomy | efetch -format xml | xtract -pattern Taxon  -element TaxId,Lineage,ScientificName | sed -e "s/\t/; /g" > taxonomy.$file.txt
  cut -f1 $file | epost -db nuccore  | efetch -format fasta  > sequences.$file.fasta

  cut -f2 $file |
    epost -db taxonomy |
    efetch -format xml > features.$file.xml
  cat features.$file.xml | xtract -pattern Taxon -block "*/Taxon" -tab "\n" -element Id,Rank,TaxId,ScientificName | grep "^kingdom\|^domain\|^phylum\|^order\|^family\|^genus\|^species" | sed "s/\t/_/g" | tr -s "\n" "," |  sed -e "s/kingdom_/\nk:/g" -e "s/domain/d:/g" -e "s/phylum_/p:/g" -e "s/class_/c:/g" -e "s/order_/o:/g" -e "s/family_/f:/g" -e "s/genus_/g:/g" -e"s/species_/s:/g" | sed '/^\s*$/d' > tmp_lineage.$file.txt
  cat features.$file.xml | xtract -pattern Taxon -tab "\n" -element TaxId,ScientificName | sed -e '/^\s*$/d' -e "s/\t/_/g"> tmp_spcname.$file.txt

  paste tmp_lineage.$file.txt tmp_spcname.$file.txt | sed "s/\t/s:/"  > taxonomy.$file.extended.txt
done;

cat  taxonomy.*.extended.txt > taxonomy.extended.txt
cat sequences.*.fasta > sequences.fasta

#mv sequences.fasta its2.$input.$(date +%Y-%m-%d).fasta

perl ../../add_taxonomy_to_fasta.pl list.txt taxonomy.extended.txt sequences.fasta > its2.$input.$(date +%Y-%m-%d).fasta
