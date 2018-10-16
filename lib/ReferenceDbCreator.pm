package ReferenceDbCreator;

use Log::Log4perl qw(:no_extra_logdie_message);
use File::Path qw(make_path);
use NCBI::Taxonomy;

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
	my $full_search_string = "($search_term)";
	# add taxonomic range
	$full_search_string .= " AND Taraxacum[ORGN]";
	# add seq length range
	$full_search_string .= " AND 100:2000[SLEN]";
	# exclud EST and GSS data
	$full_search_string .= " NOT gbdiv est[prop] NOT gbdiv gss[prop]";
	$L->info("Full search string: ".$full_search_string);
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

sub add_taxonomy_to_fasta{
	my $self = shift;
	my $outdir = $self->{outdir};
	$L->info("Adding taxonomy to fasta");
	my %acc2taxid = $self->get_accession_to_taxid_map();
	open IN, "<$outdir/sequences.fa" or $L->logdie("$!");
	open OUT, ">$outdir/sequences.tax.fa" or $L->logdie("$!");
	while(<IN>){
		if(/^>([^.\s]+)[.\s]/){
			$lineage = $self->get_lineage_string_for_taxid($acc2taxid{$1});
			print OUT ">$1;tax=$lineage;\n";
		}
		else{
			print OUT;
		}
	}
	close IN or $L->logdie("$!");
	close OUT or $L->logdie("$!");
	$L->info("Finished: Adding taxonomy to fasta");
}

sub get_lineage_string_for_taxid{
	my $self = shift;
	my $taxid = shift;
	my @lineage = @{NCBI::Taxonomy::getlineagebytaxid($taxid)};
    my %tax_elements;
    foreach my $tax_element (@lineage){
		$tax_elements{$tax_element->{rank}} = $tax_element->{sciname};
    }
	my @lineage_elements = ();
	push(@lineage_elements, $self->get_tax_string_for_level(\%tax_elements, 'kingdom'));
	push(@lineage_elements, $self->get_tax_string_for_level(\%tax_elements, 'domain'));
	push(@lineage_elements, $self->get_tax_string_for_level(\%tax_elements, 'phylum'));
	push(@lineage_elements, $self->get_tax_string_for_level(\%tax_elements, 'class'));
	push(@lineage_elements, $self->get_tax_string_for_level(\%tax_elements, 'order'));
	push(@lineage_elements, $self->get_tax_string_for_level(\%tax_elements, 'family'));
	push(@lineage_elements, $self->get_tax_string_for_level(\%tax_elements, 'genus'));
	push(@lineage_elements, $self->get_tax_string_for_level(\%tax_elements, 'species'));
	my $tax_string = join(",",grep {$_} @lineage_elements);
	return $tax_string;
}

sub get_tax_string_for_level{
	my $self = shift;
    my $tax_elements = shift;
	my $level = shift;
    my $prefix = substr($level, 0, 1);
	my $taxstring = "";
    if(defined $tax_elements->{$level}){
		$taxstring = $prefix.":".$tax_elements->{$level};
    }
    return $taxstring;
}

sub get_accession_to_taxid_map{
	my $self = shift;
	my $outdir = $self->{outdir};
	my %acc2taxid = {};
	open IN, "<$outdir/list.txt" or $L->logdie("$!");
	while(<IN>){
		chomp;
		my ($acc, $taxid) = split;
		$acc2taxid{$acc} = $taxid;
	}
	close IN or $L->logdie("$!");
	return %acc2taxid;
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