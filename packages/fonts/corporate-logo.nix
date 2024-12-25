{
  stdenv,
  fetchzip,
  symlinkJoin,
}: let
  mediumSrc = fetchzip {
    name = "medium";
    url = "https://logotype.jp/wp-content/uploads/2022/10/Corporate-Logo-Medium-ver3.zip";
    hash = "sha256-neKXzvzY8YW5WpsehOr5mNEMlsPeEO3iukLn4+r2uzc=";
  };
  boldSrc = fetchzip {
    name = "bold";
    url = "https://logotype.jp/wp-content/uploads/2022/10/Corporate-Logo-Bold-ver3.zip";
    hash = "sha256-ZLijZgNSByoM0lt5Tz2U1jl4UGF8u25e16tvpNWvQKs=";
  };
in
  stdenv.mkDerivation {
    pname = "corportate-logo-fonts";
    version = "3";

    src = symlinkJoin {
      name = "corporate-logo-all";
      paths = [mediumSrc boldSrc];
    };

    installPhase = ''
      install -m444 -Dt $out/share/fonts/opentype ${mediumSrc}/*.otf
      install -m444 -Dt $out/share/fonts/opentype ${boldSrc}/*.otf
    '';
  }
