use strict;
use warnings;

use Test::More tests=>3;
use Test::Script;
use FindBin;
use lib "$FindBin::RealBin/../lib";

# Test for use of bcdatabaser module and existence of script
BEGIN { use_ok('BCdatabaser') };
my $script = "bin/bcdatabaser.pl";
ok(-f $script, "bcdatabaser.pl exists");
script_compiles($script, "Test if script compiles");
