FROM ubuntu:18.04
ARG BRANCH=master
LABEL maintainer="markus.ankenbrand@uni-wuerzburg.de"

RUN apt-get update \
&& apt-get install -yq git unzip vim curl wget build-essential liblog-log4perl-perl libgetopt-argvfile-perl libdatetime-format-natural-perl ncbi-entrez-direct libbio-perl-perl \
&& rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/greatfireball/NCBI-Taxonomy
RUN cd /NCBI-Taxonomy && perl Makefile.PL && make && perl make_taxid_indizes.pl
RUN sed -i 's#\./t/data#/NCBI-Taxonomy#' /NCBI-Taxonomy/lib/NCBI/Taxonomy.pm

RUN git clone https://github.com/douglasgscofield/dispr
RUN ln -s /dispr/dispr /bin/dispr
# Install optional re::engine::RE2 for better performance
RUN perl -MCPAN -e 'my $c = "CPAN::HandleConfig"; $c->load(doit => 1, autoconfig => 1); $c->edit(prerequisites_policy => "follow"); $c->edit(build_requires_install_policy => "yes"); $c->commit'
RUN cpan -f re::engine::RE2

RUN git clone https://github.com/marbl/Krona
RUN mkdir /Krona/KronaTools/taxonomy
RUN cd /Krona/KronaTools && ./install.pl # && ./updateTaxonomy.sh

ENV PERL5LIB=/NCBI-Taxonomy/lib:/metabDB/lib:$PERL5LIB

COPY bin/ /metabDB/bin
COPY lib/ /metabDB/lib
COPY README.md /metabDB/
