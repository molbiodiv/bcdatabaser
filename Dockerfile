FROM ubuntu:18.04
ARG BRANCH=master
LABEL maintainer="markus.ankenbrand@uni-wuerzburg.de"

RUN apt-get update \
&& apt-get install -yq git unzip vim wget make liblog-log4perl-perl libgetopt-argvfile-perl libdatetime-format-natural-perl ncbi-entrez-direct \
&& rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/greatfireball/NCBI-Taxonomy
RUN cd /NCBI-Taxonomy && perl Makefile.PL && make && perl make_taxid_indizes.pl
RUN sed -i 's#\./t/data#/NCBI-Taxonomy#' /NCBI-Taxonomy/lib/NCBI/Taxonomy.pm

ENV PERL5LIB=/NCBI-Taxonomy/lib:/metabDB/lib:$PERL5LIB

COPY bin/ /metabDB/bin
COPY lib/ /metabDB/lib
COPY README.md /metabDB/
