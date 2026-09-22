{
  pkgs,
  ...
}: {
  imports = [
    ../programs/chrome.nix
    ../programs/spicetify.nix
    # ../programs/spotify.nix
    ../programs/hacking.nix
    ../programs/t3code.nix
    # ../modules/gtk-theme.nix
    ../shell.nix
    ../git.nix
    ../packages
  ];

  home.packages = with pkgs; [
    kagi
    t3code.unwrapped
    zen-browser
    voxtype-vulkan
  ];

  home.stateVersion = "24.05";
}
