#!/usr/bin/perl
use strict;
use warnings;
use Pod::Usage;
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

=item [--edirect-dir <STRING>]

directory containing the entrez direct utilities (default: empty, look for programs in PATH)
More info about edirect: https://www.ncbi.nlm.nih.gov/books/NBK179288/

=cut

$options{'edirect-dir=s'} = \( my $opt_edirect_dir="" );

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

GetOptions(%options) or pod2usage(1);
if($opt_version){
    print "reference_db_creator version: ".$bcgTree::VERSION."\n";
    exit 0;
}
pod2usage(1) if ($opt_help);
pod2usage( -msg => "No marker search string specified. Use --marker-search-string='<SEARCHSTRING>'", -verbose => 0, -exitval => 1, -output => \*STDERR )  unless ( $opt_marker_search_string );
# Append / to edirect dir if it is not empty and does not already contain a trailing slash
$opt_edirect_dir .= "/" if($opt_edirect_dir && substr($opt_edirect_dir,-1) ne "/");

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
    'edirect_dir' => $opt_edirect_dir
});
$reference_db_creator->search_ncbi();

sub logfile{
	return "$opt_outdir/reference_db_creator.log";
}

__END__

=head1 AUTHORS

=over

=item * Markus J. Ankenbrand, markus.ankenbrand@uni-wuerzburg.de

=item * Alexander Keller, a.keller@biozentrum.uni-wuerzburg.de

=back