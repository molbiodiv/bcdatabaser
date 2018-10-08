use strict;
use warnings;
use Data::Dumper;

my $fileList = $ARGV[0];
my $fileTax = $ARGV[1];
my $fileFasta = $ARGV[2];

open IN, "<$fileList" or die "$!";
my %acc2taxid = ();
while(<IN>){
	chomp;
	my($acc, $taxid) = split;
	$acc2taxid{$acc} = $taxid;
}
close IN or die "$!";

open IN, "<$fileTax" or die "$!";
my %taxid2taxonomy = ();
while(<IN>){
	chomp;
	s/ /_/g;
	my $taxonomy = $_;
	/,s:(\d+)_[^,]+$/;
	$taxid2taxonomy{$1} = $taxonomy;
}
close IN or die "$!";
# print Dumper(\%taxid2taxonomy);

open IN, "<$fileFasta" or die "$!";
while(<IN>){
	if(/^>([A-Z0-9]+)/){
		$_=">$1:$taxid2taxonomy{$acc2taxid{$1}}\n";
	}
	print;
}
close IN or die "$!";
