{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ../programs/chrome.nix
    ../programs/firefox.nix
    ../programs/spicetify.nix
    # ../programs/spotify.nix
    ../programs/hacking.nix
    ../modules/gtk-theme.nix
    ../shell.nix
    ../git.nix
    ../packages
  ];

  home.packages = with pkgs; [
    bisq2
  ];

  home.stateVersion = "24.05";
}
