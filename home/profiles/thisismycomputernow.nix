{inputs, pkgs, ...}:

{
  imports = [
    ../desktop/gnome.nix
    ../programs/chrome.nix
    ../programs/spicetify.nix
    ../shell.nix
    ../git.nix
    ../packages
  ];

  home.packages = [
    pkgs.osu-lazer-bin
  ];

  home.stateVersion = "24.05";
}