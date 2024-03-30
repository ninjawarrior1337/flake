{inputs, ...}:

{
  imports = [
    ../desktop/gnome.nix
    ../programs/chrome.nix
    ../programs/spicetify.nix
    ../programs/hacking.nix
    ../shell.nix
    ../git.nix
    ../packages
  ];

  home.stateVersion = "23.11";
}