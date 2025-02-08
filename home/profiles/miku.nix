{inputs, ...}: {
  imports = [
    ../programs/chrome.nix
    ../programs/firefox.nix
    ../programs/spicetify.nix
    # ../programs/spotify.nix
    ../programs/hacking.nix
    # ../modules/gtk-theme.nix
    ../shell.nix
    ../git.nix
    ../packages
  ];

  home.stateVersion = "24.05";
}
