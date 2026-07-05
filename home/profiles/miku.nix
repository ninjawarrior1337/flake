{
  pkgs,
  ...
}: {
  imports = [
    ../programs/chrome.nix
    ../programs/spicetify.nix
    # ../programs/spotify.nix
    ../programs/hacking.nix
    ../modules/gtk-theme.nix
    ../shell.nix
    ../git.nix
    ../packages
  ];

  home.packages = with pkgs; [
    kagi
    warp-terminal
  ];

  home.stateVersion = "24.05";
}
