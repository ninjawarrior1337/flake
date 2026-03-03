{
  pkgs,
  lib,
  inputs,
  ...
}: {
  programs.nix-ld.enable = true;

  programs.nix-ld.libraries = (pkgs.callPackage (import "${inputs.nixpkgs}/pkgs/build-support/appimage") {}).defaultFhsEnvArgs.multiPkgs pkgs;
}
