use strict;
use warnings;

use Test::More tests => 2;
use Test::Script;
use File::Path qw(remove_tree);

my %options = (exit => 1);

my $tmpdir = "04_tmp";

my $script_args = ['bin/bcdatabaser.pl'];

script_runs($script_args, \%options, "Test if script runs without search term as parameter");
script_stderr_like(qr/No marker search string specified./, "Result of run with missing search term returned error message");
remove_tree($tmpdir);
