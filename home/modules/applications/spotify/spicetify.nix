{
  pkgs,
  inputs,
  ...
}: let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in {
  imports = [inputs.spicetify-nix.homeManagerModules.default];

  programs.spicetify = {
    enable = true;
    theme = spicePkgs.themes.catppuccin;
    colorScheme = "mocha";
    spotifyPackage = import ./package.nix {inherit pkgs;};

    enabledExtensions = with spicePkgs.extensions; [
      fullAppDisplay
      shuffle
      songStats
      adblock
    ];
  };
}
