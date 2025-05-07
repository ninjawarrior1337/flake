{
  stdenvNoCC,
  fetchzip,
  symlinkJoin,
  lib,
}:
stdenvNoCC.mkDerivation rec {
  pname = "nebula-sans";
  version = "1.010";

  src = fetchzip {
    url = "https://nebulasans.com/download/NebulaSans-${version}.zip";
    hash = "sha256-jFoHgxczU7VdZcVj7HI4OOjK28jcptu8sGOrs3O+0S0=";
    stripRoot = false;
  };

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  doCheck = false;
  dontFixup = true;

  installPhase = ''
    install -m444 -Dt $out/share/fonts/truetype/ ${src}/TTF/*.ttf
    runHook postInstall
  '';

  meta = with lib; {
    description = "Versatile, modern, humanist sans-serif with a neutral aesthetic, designed for legibility in both digital and print applications";
    homepage = "https://nebulasans.com/";
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
