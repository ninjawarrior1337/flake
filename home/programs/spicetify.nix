{
  pkgs,
  lib,
  inputs,
  ...
}: let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
in {
  # import the flake's module for your system
  imports = [inputs.spicetify-nix.homeManagerModules.default];

  # configure spicetify :)
  programs.spicetify = {
    enable = true;
    theme = spicePkgs.themes.catppuccin;
    colorScheme = "mocha";
    spotifyPackage = pkgs.callPackage ../../packages/spotify {spotify-adblock = pkgs.callPackage ../../packages/spotify-adblock {};};

    enabledExtensions = with spicePkgs.extensions; [
      fullAppDisplay
      shuffle # shuffle+ (special characters are sanitized out of ext names)
      songStats
      adblock
    ];
  };
}
