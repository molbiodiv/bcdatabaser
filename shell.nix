with import <nixpkgs> {};
let GetoptArgvFile = buildPerlPackage rec {
  name = "Getopt-ArgvFile-1.11";
  src = fetchurl {
    url = "https://cpan.metacpan.org/authors/id/J/JS/JSTENZEL/${name}.tar.gz";
    sha256 = "08jvhfqcjlsn013x96qa6paif0095x6y60jslp8p3zg67i8sl29p";
  };
};
in
stdenv.mkDerivation {
  name = "bcdatabaser";
  buildInputs = with perlPackages; [
    TestScript
    GetoptArgvFile
    DateTimeFormatNatural
    Log4Perl
    perl
  ];
  shellHook = ''
    export PERL5LIB=$PWD/lib:$PERL5LIB
  '';
}
