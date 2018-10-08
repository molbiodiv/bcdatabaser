use strict;
use warnings;

use Test::More tests=>3;
use Test::Script;
use FindBin;

# Test for use of cpgTree module and existence of script
BEGIN { use_ok('ReferenceDbCreator') };
my $script = "bin/reference_db_creator.pl";
ok(-f $script, "reference_db_creator.pl exists");
script_compiles($script, "Test if script compiles");
