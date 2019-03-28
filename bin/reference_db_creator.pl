#!/usr/bin/env perl
use strict;
use warnings;
use Pod::Usage;
use FindBin;
use lib "$FindBin::RealBin/../lib";
use Log::Log4perl qw(:no_extra_logdie_message);
use Getopt::Long;
use Getopt::ArgvFile;
use ReferenceDbCreator;

my %options;

=head1 NAME

reference_db_creator.pl

=head1 DESCRIPTION

A pipeline to create reference databases for arbitrary markers and taxonomic groups from NCBI data

=head1 USAGE

  $ reference_db_creator.pl [@configfile] --marker-search-string="<SEARCHSTRING>" [options]

=head1 OPTIONS

=over 25

=item [@configfile]

Optional path to a configfile with @ as prefix.
Config files consist of command line parameters and arguments just as passed on the command line.
Space and comment lines are allowed (and ignored).
Spreading over multiple lines is supported.

=cut

=item --marker-search-string <SEARCHSTRING>

Search string for the marker, passed literally to the NCBI search

=cut

$options{'marker-search-string|m=s'} = \( my $opt_marker_search_string );

=item [--outdir <STRING>]

output directory for the generated output files (default: reference_db_creator)

=cut

$options{'outdir=s'} = \( my $opt_outdir="reference_db_creator" );

=item [--taxonomic-range <SCINAME>]

Scientific (or common) name of the taxon all sequences have to belong to.
This will be added to the query string as "AND <SCINAME>[ORGN]".
Default: empty (no restriction)
Example: --taxonomic-range Viridiplantae

=cut

$options{'taxonomic-range=s'} = \( my $opt_taxonomic_range="" );

=item [--taxa-list <FILENAME>]

File with list of scientific (or common) names to include (one per line).
Attention: All children of higher taxonomic ranks will be included.
This will be added to the query string as "AND (<SCINAME1>[ORGN] OR <SCINAME2>[ORGN] ...)".
Default: empty (no restriction)
Example: --taxa-list plants_in_germany.txt

=cut

$options{'taxa-list=s'} = \( my $opt_taxa_list="" );

=item [--check-tax-names]

If this option is set all taxon names provided by the user (--taxonomic-range and
entries in the --taxa-list file) are checked against the names.dmp file from NCBI
The program stops with an error if any species name is not listed in names.dmp.
Set the path to the names.dmp file via --names-dmp-path
Default: false

=cut

$options{'check-tax-names'} = \( my $opt_check_tax_names=0 );

=item [--names-dmp-path <PATH>]

Path to the NCBI taxonomy names.dmp file to check taxonomic names. Only relevant if
--check-tax-names is set. The default value is suitable for use with the docker container.
It is the same file used by NCBI::Taxonomy to assign the tax strings.
Default: /NCBI-Taxonomy/names.dmp
Example: --names-dmp-path $HOME/ncbi/names.dmp

=cut

$options{'names-dmp-path=s'} = \( my $opt_names_dmp_path="/NCBI-Taxonomy/names.dmp" );

=item [--sequence-length-filter <SLEN>]

Sequence length filter for search at NCBI (single number or colon separated range).
This is only applied to the search initial search via "AND <SLEN>[SLEN]".
Empty string means no restriction.
Default: empty (no restriction)
Example: --sequence-length-filter 100:2000

=cut

$options{'sequence-length-filter=s'} = \( my $opt_sequence_length_filter="" );

=item [--sequences-per-taxon <INTEGER>]

Number of sequences to download for each distinct NCBI taxid.
If there are more sequences for a taxid the longest ones are kept.
Default: 3
Example: --sequences-per-taxon 1

=cut

$options{'sequences-per-taxon=i'} = \( my $opt_seqs_per_taxon=3 );

=item [--edirect-dir <STRING>]

directory containing the entrez direct utilities (default: empty, look for programs in PATH)
More info about edirect: https://www.ncbi.nlm.nih.gov/books/NBK179288/

=cut

$options{'edirect-dir=s'} = \( my $opt_edirect_dir="" );

=item [--edirect-batch-size <INT>]

Sequence download is split into batches of <INT> sequences to avoid network timeouts.
Default: 100

=cut

$options{'edirect-batch-size=i'} = \( my $opt_edirect_batch_size=100 );

=item [--krona-bin <STRING>]

Path to the executable of ktImportTaxonomy (https://github.com/marbl/Krona)
Default: ktImportTaxonomy (assumes Krona Tools to be in PATH)

=cut

$options{'krona-bin=s'} = \( my $opt_krona_bin="ktImportTaxonomy" );

=item [--seqfilter-bin <STRING>]

Path to the executable of SeqFilter (https://github.com/BioInf-Wuerzburg/SeqFilter)
Default: SeqFilter (assumes SeqFilter to be in PATH)

=cut

$options{'seqfilter-bin=s'} = \( my $opt_seqfilter_bin="SeqFilter" );

=item [--dispr-bin <STRING>]

Path to the executable of dispr (https://github.com/douglasgscofield/dispr) for degenerate in silico pcr for filtering, trimming, and orientation
In order to use dispr --primer-file must be provided as well
Default: dispr (assumes dispr to be in PATH)

=cut

$options{'dispr-bin=s'} = \( my $opt_dispr_bin="dispr" );

=item [--primer-file <FILENAME>]

Path to the primers file for dispr.
From the dispr help text:

        Fasta-format file containing primer sequences.  Each
        primer sequence must have a name of the format
          >tag:F       or   >tag:R
          CCYATGTAYY        CTBARRSTG
        indicating forward and reverse primers, respectively.
        Valid IUPAC-coded sequences are required.
        The tag is used to mark hits involving the primer pair
        and must be identical for each forward-reverse pair.

Default: empty (dispr not used for filtering/trimming/orientation)

=cut

$options{'primer-file=s'} = \( my $opt_primer_file="" );

=item [--zip]

Create output .zip file containing the folder.
If set the output folder will be zipped and deleted(!).
So please be careful when using --zip and only use it with
a dedicated subfolder specified with --outdir
Default: false

=cut

$options{'zip'} = \( my $opt_zip = 0 );

=item [--zenodo-token-file <FILENAME>]

Push resulting output zip file to zenodo using the token stored in
FILENAME. This option implies --zip (will be set automatically).
The token file should only contain the zenodo token in the first line.
Be aware that datasets pushed to zenodo are public and receive a doi
so they can not simply be deleted.
Default: false

=cut

$options{'zenodo-token-file=s'} = \( my $opt_zenodo_token_file );

=item [--help]

show help

=cut

$options{'help|h|?'} = \( my $opt_help );

=item [--version]

show version number of reference_db_creator and exit

=cut

$options{'version'} = \( my $opt_version );

=back

=head1 CODE

=cut

my @origARGV = @ARGV;
GetOptions(%options) or pod2usage(1);
if($opt_version){
    print "reference_db_creator version: ".$bcgTree::VERSION."\n";
    exit 0;
}
pod2usage(1) if ($opt_help);
pod2usage( -msg => "No marker search string specified. Use --marker-search-string='<SEARCHSTRING>'", -verbose => 0, -exitval => 1, -output => \*STDERR )  unless ( $opt_marker_search_string );
# Append / to edirect dir if it is not empty and does not already contain a trailing slash
$opt_edirect_dir .= "/" if($opt_edirect_dir && substr($opt_edirect_dir,-1) ne "/");
# zip implied by zenodo_token
$opt_zip = 1 if($opt_zenodo_token_file);

# init a root logger in exec mode
Log::Log4perl->init(
	\q(
                log4perl.rootLogger                     = DEBUG, Screen
                log4perl.appender.Screen                = Log::Log4perl::Appender::Screen
                log4perl.appender.Screen.stderr         = 1
                log4perl.appender.Screen.layout         = PatternLayout
                log4perl.appender.Screen.layout.ConversionPattern = [%d{MM-dd HH:mm:ss}] [%C] %m%n
        )
);

my $L = Log::Log4perl::get_logger();

my $reference_db_creator = ReferenceDbCreator->new({
	'marker_search_string' => $opt_marker_search_string,
    'outdir' => $opt_outdir,
    'edirect_dir' => $opt_edirect_dir,
    'edirect_batch_size' => $opt_edirect_batch_size,
    'taxonomic_range' => $opt_taxonomic_range,
    'taxa_list' => $opt_taxa_list,
    'check_tax_names' => $opt_check_tax_names,
    'names_dmp_path' => $opt_names_dmp_path,
    'sequence_length_filter' => $opt_sequence_length_filter,
    'seqs_per_taxon' => $opt_seqs_per_taxon,
    'krona_bin' => $opt_krona_bin,
    'seqfilter_bin' => $opt_seqfilter_bin,
    'dispr_bin' => $opt_dispr_bin,
    'primer_file' => $opt_primer_file,
    'zenodo_token_file' => $opt_zenodo_token_file
});
$L->info(join(" ", "Call:", $0, @origARGV));
$reference_db_creator->search_ncbi();
$reference_db_creator->limit_seqs_per_taxon();
$reference_db_creator->download_sequences();
$reference_db_creator->add_taxonomy_to_fasta();
$reference_db_creator->filter_and_orient_by_primers();
$reference_db_creator->combine_filtered_and_raw_sequences();
# TODO #10
#$reference_db_creator->write_summary_statistics();
$reference_db_creator->create_krona_summary();
$reference_db_creator->add_citation_file();
$reference_db_creator->zip_output() if($opt_zip);
$reference_db_creator->push_to_zenodo() if($opt_zenodo_token_file);

sub logfile{
	return "$opt_outdir/reference_db_creator.log";
}

__END__

=head1 AUTHORS

=over

=item * Markus J. Ankenbrand, markus.ankenbrand@uni-wuerzburg.de

=item * Alexander Keller, a.keller@biozentrum.uni-wuerzburg.de

=back
