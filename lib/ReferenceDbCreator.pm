package ReferenceDbCreator;

use Log::Log4perl qw(:no_extra_logdie_message);
use File::Path qw(make_path);

our $VERSION = '0.0.1';

my $L = Log::Log4perl::get_logger();

sub new {
	my $class = shift;
	my $object = shift;
	bless $object, $class;
    $object->create_outdir_if_not_exists();
	# init a root logger in exec mode
	Log::Log4perl->init(
	\q(
                log4perl.rootLogger                     = DEBUG, Screen, FileApp
				log4perl.appender.FileApp				= Log::Log4perl::Appender::File
				log4perl.appender.FileApp.filename		= sub{ logfile() }
				log4perl.appender.FileApp.layout		= PatternLayout
				log4perl.appender.FileApp.layout.ConversionPattern = [%d{MM-dd HH:mm:ss}] [%C] %m%n
                log4perl.appender.Screen                = Log::Log4perl::Appender::Screen
                log4perl.appender.Screen.stderr         = 1
                log4perl.appender.Screen.layout         = PatternLayout
                log4perl.appender.Screen.layout.ConversionPattern = [%d{MM-dd HH:mm:ss}] [%C] %m%n
        )
	);
	return $object;
}

sub create_outdir_if_not_exists{
	my $self = shift;
	my $outdir = $self->{outdir};
	make_path($outdir, {error => \my $err});
	if (@$err)
	{
	    for my $diag (@$err) {
			my ($file, $message) = %$diag;
			# Just die instead of logdie here as the logger is not initialized when first called.
			# Set exit code to 1 explicitly - otherwise not predictable (or testable)
			$! = 1;
			if ($file eq '') {
				die("Creating folder failed with general error: $message");
			}
			else {
				die("Creating folder failed for folder '$file': $message");
			}
	    }
	}
}

sub search_ncbi{
	my $self = shift;
	my $outdir = $self->{outdir};
	my $search_term = $self->{marker_search_string};
	my $edirect_dir = $self->{edirect_dir};
	my $full_search_string = "($search_term) AND Taraxacum[ORGN] AND 100:2000[SLEN]";
	my $cmd = $edirect_dir."esearch -db nuccore -query \"$full_search_string\" | ".$edirect_dir."efetch -format docsum | ".$edirect_dir."xtract -pattern DocumentSummary -element Caption,TaxId > $outdir/list.txt";
	$self->run_command($cmd, "Run search against NCBI");
}

sub download_sequences{
	my $self = shift;
	my $outdir = $self->{outdir};
	my $batch_size = 100;
	my $edirect_dir = $self->{edirect_dir};
	my $efetch_bin = $edirect_dir."efetch";
	my $epost_bin = $edirect_dir."epost";

	# get number of results
	my $num_results = qx(wc -l $outdir/list.txt);
	$L->info("Number of search results: $num_results");

	# clear sequence file (might exist from previous incomplete run)
	$L->info("Removing $outdir/sequences.fa if it exists");
	if ( -e $outdir."/sequences.fa" ) {
        unlink($outdir."/sequences.fa") or $L->logdie("$!");
    }
	
	$L->info("Now downloading sequences in batches of $batch_size");
	for(my $i=1; $i<=$num_results; $i+=$batch_size){
		my $msg = "Downloading fasta sequences for batch: $i - ".($i+$batch_size-1);
		my $cmd = "tail -n+$i $outdir/list.txt | head -n $batch_size | cut -f1 | $epost_bin -db nuccore | $efetch_bin -format fasta >>$outdir/sequences.fa";
		$self->run_command($cmd, $msg);
	}
	$L->info("Finished downloading sequences");
}

sub run_command{
	my $self = shift;
	my $cmd = shift;
	my $msg = shift;
	my $ignore_error = shift;
	$L->info("Starting: $msg");
	$L->info($cmd);
	my $result = qx($cmd);
	$L->debug($result);
	$L->logdie("ERROR: $msg failed") if $? >> 8 and !$ignore_error;
	$L->info("Finished: $msg");
	return $result;
}


1;