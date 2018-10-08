with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "reference_db_creator";
  buildInputs = [ perlPackages.TestScript perl ];
  shellHook = ''
    export PERL5LIB=$PWD/lib:$PERL5LIB
  '';
}
