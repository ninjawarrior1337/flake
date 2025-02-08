{pkgs, ...}: {
  home.packages = [
    (pkgs.callPackage ../../packages/spotify {spotify-adblock = pkgs.callPackage ../../packages/spotify-adblock {};})
  ];
}
